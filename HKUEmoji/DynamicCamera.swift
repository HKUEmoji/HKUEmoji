//
//  DynamicCamera.swift
//  HKUEmoji
//
//  Created by huhao on 15/11/30.
//  Copyright © 2015年 huhao. All rights reserved.
//

import UIKit
import MobileCoreServices


class cameraTool :  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var testview: UIImageView!
    @IBOutlet weak var overlayView: UIImageView!
    // 初始化图片选择控制器
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var isFullScreen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePhone(sender: UIButton) {
       /*let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
        alertView.show()*/
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true//默认是打开的这样才有拍照键，前后摄像头切换的控制，一半设置为NO的时候用于自定义ovelay
            
            //var overLayViews = NSBundle.mainBundle().loadNibNamed("cameraOverlayView", owner: nil, options: nil)
            //var overlayView = overLayViews.last as! UIView
            let overLayView: UIView = UIView(frame: imagePicker.cameraOverlayView!.bounds )
            let overLayImg : UIImageView = UIImageView(image: UIImage(named: "background.png"))
            overLayView.addSubview(overLayImg)
            
            imagePicker.cameraOverlayView = overLayView
            //    overLayImg.image = [UIImage imageNamed:@"overlay.png"];
            
            //    imagePicker.cameraOverlayView = overLayImg;//3.0以后可以直接设置cameraOverlayView为overlay
            //    imagePicker.wantsFullScreenLayout = YES;
           /*
            var views = NSBundle.mainBundle().loadNibNamed("XIBName", owner: self, options: nil)
            var view = views.last as UIView
            var r = view.frame
            r.origin.y += 30
            view.frame = r
            self.view.addSubview(view)*/
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
        alertView.show()
        
        //testview = UIImage(info)
        
    }
    
    
    
    @IBAction func searchFromLib(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    
}
