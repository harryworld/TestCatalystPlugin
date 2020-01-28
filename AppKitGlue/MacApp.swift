//
//  MacApp.swift
//  AppKitGlue
//
//  Created by Harry Ng on 10/1/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import Cocoa
import DynamicColor
import BonMot

// Expected
/*
class MacApp: NSObject, AppKit {
    var hotKey: HotKey?
    
    func setup() {
        let hotKey = HotKey(key: .a, modifiers: [.control, .shift])
        hotKey.keyDownHandler = {
            print("Pressed at \(Date())")
        }
        self.hotKey = hotKey
    }
}
*/

// Actual
class MacApp: NSObject, AppKit {
    var hotKey: HotKey?

    func setup() {
        let hotKey = HotKey(key: .a, modifiers: [.control, .shift])
        hotKey.keyDownHandler = {
            self.handleKeyDown(hotKey)
        }
        self.hotKey = hotKey
    }
    
    func handleKeyDown(_ key: HotKey) {
        print("Pressed at \(Date())")
        key.keyDownHandler = {
            self.handleKeyDown(key)
        }
    }
    
    func viewSecondVC() {
        // DynamicColor crashes by saying `Symbol not found` for NSColor
        let color = DynamicColor(hexString: "#263342")
        let color = NSColor(hexString: "#263342")
        
        // BonMot crashes with initializer
        let style = StringStyle()
    }
}
