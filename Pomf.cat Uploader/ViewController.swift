//
//  ViewController.swift
//  Pomf.cat Uploader
//
//  Created by Seth on 2015-12-21.
//  Copyright © 2015 DrabWeb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSApplication.sharedApplication().currentEvent?.window?.registerForDraggedTypes([NSURLPboardType]);
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

