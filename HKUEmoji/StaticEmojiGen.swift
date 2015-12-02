//
//  StaticEmojiGen.swift
//  HKUEmoji
//
//  Created by Wang Youan on 30/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import GPUImage

class StaticEmojiGen: UIViewController {

    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var leftEye: UIImageView!
    @IBOutlet weak var rightEye: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image: UIImage = UIImage(named: "test.png")!
        
        let stillImageFilter:GPUImageSketchFilter = GPUImageSketchFilter()
        
        imageShow.image = stillImageFilter.imageByFilteringImage(image)
        leftEye.image = UIImage(named: "eye.png")
        rightEye.image = UIImage(named: "eye.png")
        mouth.image = UIImage(named: "mouth.png")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
