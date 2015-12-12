//
//  ViewController.swift
//  HKUEmoji
//
//  Created by Wang Youan on 23/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "1.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

