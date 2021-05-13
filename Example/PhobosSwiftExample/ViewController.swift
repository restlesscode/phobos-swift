//
//  ViewController.swift
//  PhobosSwiftExample
//
//  Created by Theo Chen on 2021/5/12.
//

import UIKit
import PhobosSwiftCore

class ViewController: UIViewController {

    let core = PBSCore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        core.checkInternalVersion { needUpgrade, previousVersion, currentVersion in
            print(needUpgrade, previousVersion.string, currentVersion.string)
        }
    }
}

