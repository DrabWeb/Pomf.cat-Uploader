//
//  AppDelegate.swift
//  Pomf.cat Uploader
//
//  Created by Seth on 2015-12-21.
//  Copyright © 2015 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // The status item for the menubar
    var statusItem : NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength);
    
    // The open panel, for choosing the file
    var openPanel : NSOpenPanel = NSOpenPanel();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Setup the status item
        setupStatusItem();
        
        // Setup the open panel
        setupOpenPanel();
    }
    
    func setupStatusItem() {
        // Get the image for teh status item
        var image : NSImage = NSImage(named: "menubar")!;
        
        // Set the image to be 4 pixels smaller then the status bar
        image.size = NSSize(width: NSStatusBar.systemStatusBar().thickness - 4, height: NSStatusBar.systemStatusBar().thickness - 4);
        
        // Set the status item image
        statusItem.image = image;
        
        // Set the status items clicked function
        statusItem.button?.action = Selector("openFile");
    }
    
    func setupOpenPanel() {
        // Set the open panel to only allow one file
        openPanel.allowsMultipleSelection = false;
        
        // Set the open panel not to allow folders
        openPanel.canChooseDirectories = false;
    }
    
    func openFile() {
        // Show the open panel
        openPanel.runModal();
        
        // Create filePath and set it to the URL of the file we just chose
        var filePath : NSURL = openPanel.URL!;
    
        // Create a string to hold the file path
        var filePathString : String = filePath.absoluteString;
        
        // Take off the "file://" from the front
        filePathString.removeRange(Range(start: filePathString.startIndex, end: filePathString.startIndex.advancedBy(7)));
        
        // Replace all %20's with a space
        filePathString = filePathString.stringByReplacingOccurrencesOfString("%20", withString: " ");
        
        // Create a task
        var task = NSTask();
        
        // Set it to open the pomfcat bash script in the app bundle
        task.launchPath = NSBundle.mainBundle().bundlePath + "/Contents/Resources/pomfcat";
        
        // Set the arguments to only have the file path we want to upload
        task.arguments = [filePathString];
        
        // Create a pipe to get the output
        var pipe = NSPipe();
        
        // Set the task output pipe to our new pipe
        task.standardOutput = pipe;
        
        // Create a handle to get the task output
        var handle = pipe.fileHandleForReading;
        
        // Launch it
        task.launch();
        
        // Get the URL for our uploaded file
        var uploadedPath : String! = String(data: handle.availableData, encoding: NSUTF8StringEncoding);
        
        // Replace new lines with nothing
        uploadedPath = uploadedPath.stringByReplacingOccurrencesOfString("\n", withString: "");
        
        task = NSTask();
        
        // Set it to open the pomfcat bash script in the app bundle
        task.launchPath = NSBundle.mainBundle().bundlePath + "/Contents/Resources/clipboard";
        
        // Set the arguments to only have the file path we want to upload
        task.arguments = [uploadedPath];
        
        task.launch();
        
        task = NSTask()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", "display notification \"Uploaded " + uploadedPath + "\" with title \"Pomf.cat Uploader\""]
        task.launch()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

