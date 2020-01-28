//
//  FirstViewController.swift
//  TestCatalyst
//
//  Created by Harry Ng on 10/1/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import UIKit
import DynamicColor
import BonMot

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Catalyst.appKit?.setup()
        
        // DynamicColor works in UIKit as UIColor (alias DynamicColor) is loaded
        let color = DynamicColor(hexString: "#263342")
        
        // BonMot works as well as UIFont (alias BonMot) is loaded
        let style = StringStyle()
    }


}

