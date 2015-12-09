//
//  StaticCamera.swift
//  HKUEmoji
//
//  Created by Wang Youan on 28/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import MobileCoreServices

class StaticCamera: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var staticPhotoTaker: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    
    @IBAction func takePhone(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker.allowsEditing = false
            
                
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = true
        }
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
