//
//  Catalyst.swift
//  TestCatalyst
//
//  Created by Harry Ng on 10/1/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import UIKit

enum Catalyst {
    static var appKit: AppKit? {
        #if targetEnvironment(macCatalyst)
        guard let url = Bundle.main.builtInPlugInsURL?.appendingPathComponent("AppKitGlue.bundle") else {
            return nil
        }
        guard let bundle = Bundle(path: url.path) else { return nil }
        guard bundle.load() else { return nil }
        guard let cls = bundle.principalClass as? NSObject.Type else { return nil }
        guard let appKit = cls.init() as? AppKit else { return nil }
        return appKit
        #else
        return nil
        #endif
    }
}
