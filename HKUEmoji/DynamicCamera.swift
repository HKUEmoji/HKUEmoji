//
//  DynamicCamera.swift
//  HKUEmoji
//
//  Created by huhao on 15/11/30.
//  Copyright © 2015年 huhao. All rights reserved.
//

import UIKit
import MobileCoreServices
import Toucan


class cameraTool :  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var pickView: UIImageView!
    @IBOutlet weak var overlayView: UIImageView!
    // 初始化图片选择控制器
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickView.image = UIImage(named:"superdad.png")
        pickView.userInteractionEnabled = false
        overlayView.image = UIImage(named: "background.png")
        overlayView.userInteractionEnabled = true
        //overlayView.frame=CGRectMake(70, 140, 200, 200)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.sendSubviewToBack(pickView)
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
            
            //自定义overlay
            //var overLayViews = NSBundle.mainBundle().loadNibNamed("cameraOverlayView", owner: nil, options: nil)
            //var overlayView = overLayViews.last as! UIView
            
            //let overLayView: UIView = UIView(frame: CGRectMake(0, 100, imagePicker.cameraOverlayView!.bounds.size.width, 200) )
            //let overLayImg : UIImageView = UIImageView(image: UIImage(named: "superdad.png"))
            //overLayImg.frame = overLayView.frame
            //overLayView.addSubview(overLayImg)
            //imagePicker.cameraOverlayView = overLayView
            
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        /*ToucanImage.layerWithOverlayImage(overlay,overlayFrame: CGRectMake(0,0,testview.frame.size.width*10,testview.frame.size.height*10))*/
    
        pickView.image = pickedImage
    }
    
    
    @IBAction func captureFace(sender: UIButton) {
        var offsetX=overlayView.frame.origin.x - pickView.frame.origin.x
        var offsetY=overlayView.frame.origin.y - pickView.frame.origin.y
        var ratioX = (pickView.image?.size.width)!/pickView.frame.size.width
        var ratioY = (pickView.image?.size.height)!/pickView.frame.size.height
        var ratio = min(ratioX,ratioY)
        print(offsetX,",",offsetY)
        print("Imagesize",pickView.image?.size.width,",",pickView.image?.size.height)
        print("Viewsize",pickView.frame.size.width,",",pickView.frame.size.height)
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(offsetX*ratio,offsetY*ratio))
        path.addLineToPoint(CGPointMake(offsetX*ratio,(offsetY+overlayView.frame.size.height)*ratio))
        path.addLineToPoint(CGPointMake((offsetX+overlayView.frame.size.width)*ratio,(offsetY+overlayView.frame.size.height)*ratio))
        path.addLineToPoint(CGPointMake((offsetX+overlayView.frame.size.width)*ratio,offsetY*ratio))
        path.closePath()
        
        var faceImage = Toucan(image: pickView.image!).maskWithPath(path: path).image
        //faceImage=Toucan(image: faceImage).maskWithImage(maskImage: overlayView.image!).image
       // var faceImage=Toucan(image: pickView.image!).maskWithImage(maskImage: overlayView.image!).image

        pickView.image=faceImage
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        let touch = touches.first!
        let location = touch.locationInView(self.view)
        if let node = touch.view {
            if node.tag == 1 {
                let newLocation = CGPoint(x: location.x, y: location.y)
                node.center = newLocation
            }
        }
    }
    
    private func resizeImageFromRatio(originalImage: UIImage, ratio: Double) -> (UIImage) {
        let image = CIImage(image: originalImage)
        
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(ratio, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
        let outputImage = filter.valueForKey(kCIOutputImageKey) as! CIImage
        
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
        let scaledImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent))
        return scaledImage
    }
    
    
 /*   //完成拍照
    -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self performSelector:@selector(saveImage:) withObject:image];
    
    }
    //用户取消拍照
    -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
    {
    [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    //将照片保存到disk上
    -(void)saveImage:(UIImage *)image
    {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil)
    {
    imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    _fileName = [[[formatter stringFromDate:date] stringByAppendingPathExtension:@"png"] retain];
    
    
    NSURL *saveURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_fileName];
    
    [imageData writeToURL:saveURL atomically:YES];
    
    
    }*/
    
    
    
    
    
    
}
