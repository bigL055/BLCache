//
//  ViewController.swift
//  BLCache
//
//  Created by linhan.linhey@outlook.com on 01/08/2018.
//  Copyright (c) 2018 linhan.linhey@outlook.com. All rights reserved.
//

import UIKit
import BLDebugTools
import BLCache

class ViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      DebugWindow.shared.begin()
      BLCache.set(name: "test",value: 1, state: BLCache.State.userDefault)
      BLCache.set(name: "test",value: 1, state: BLCache.State.sql(.cache))
      BLCache.set(name: "test",value: 1, state: BLCache.State.sql(.doc))
      BLCache.set(name: "test",value: 1, state: BLCache.State.sql(.tmp))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

