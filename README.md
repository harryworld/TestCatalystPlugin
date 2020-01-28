# TestCatalystPlugin
Demonstrate running Mac Catalyst with AppKit plugin bundle

## Background
We would like to include some natvie Mac experiences (e.g. NSWindow, Menu Bar Extra) while building Catalyst-based app.

## Works
- In order to use AppKit components, we learn to include a plugin target which builds on Cocoa framework.
- We also want to use CocoaPods to include 3rd-party frameworks
- Some UI-related frameworks use alias to share features
  - DynamicColor (UIColor vs NSColor)
  - BonMot (UIFont vs NSFont)
  - PinLayout (UIView vs NSView)

## Expectation
- These frameworks use corresponding classes when included in iOS or macOS based apps.
- For hosting app using Catalyst, it should pick UIKit related system frameworks like UIKit
- For plugin, it should pick AppKit related system frameworks like Cocoa

## Problem
- While running the plugin with frameworks, the app crashes
- It shows `Symbol not found` with other console error messages
- For example, in the case of `DynamicColor`, it tells that `NSColor` or alias `DynamicColor` is not found

## To reproduce
1. Run `pod install` to install the frameworks using CocoaPods
2. Open the workspace using the workspace file
3. `FirstViewController` runs the UIKit Catalyst codes
4. `SecondViewController` runs the plugin code which attempts to load symbols from frameworks

## Observation
If I import the framework source codes to the plugin by manually copying them, these codes can be built flaslessly under Cocoa environment.
