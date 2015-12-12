//
//  ViewController.swift
//  HKUEmoji
//
//  Created by Wang Youan on 23/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showStaticPage(sender: AnyObject) {
        let rootViewController = self.navigationController!
        let mainStoryboard: UIStoryboard = self.storyboard!
        let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CameraBoard") as! cameraTool
        profileViewController.fromPage = "static"
        rootViewController.pushViewController(profileViewController, animated: true)
    }
    
    @IBAction func showDynamicPage(sender: AnyObject) {
        let rootViewController = self.navigationController!
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CameraBoard") as! cameraTool
        profileViewController.fromPage = "dynamic"
        rootViewController.pushViewController(profileViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mainbackground")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

