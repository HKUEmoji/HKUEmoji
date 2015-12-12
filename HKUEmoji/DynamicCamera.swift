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


extension UIImage {
    
    func fixOrientation(orientation:UIImageOrientation) -> UIImage {
        if (self.imageOrientation == orientation) {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        
        switch (orientation) {
        case .Left:
            transform = CGAffineTransformTranslate(transform, self.size.height,0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right:
            transform = CGAffineTransformTranslate(transform, 0,self.size.width)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            return self
        }
        
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
            CGImageGetBitsPerComponent(self.CGImage), 0,
            CGImageGetColorSpace(self.CGImage),
            CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage )
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        return UIImage(CGImage: cgimg!)
    }
}

class cameraTool :  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickView: UIImageView!
    
    @IBOutlet weak var myAlbum: UIButton!
    @IBOutlet weak var pickFace: UIButton!
    @IBOutlet weak var takePhoto: UIButton!
    var overlayView: UIImageView!
    var choosedPicture: UIImage!
    var resizeImage : UIImage!
    var faceImage : UIImage!
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
//    @IBOutlet weak var overlayView: UIImageView!
    
    // 初始化图片选择控制器
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        /*choosedPicture = UIImage(named: "pickFace.jpg")
        resizeImage = resizeImageFromFrame(choosedPicture)
        pickView.frame = CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height)
        pickView.image = resizeImage*/
        
        //pickView.image = choosedPicture
        pickView.userInteractionEnabled = false
        overlayView = UIImageView(image: UIImage(named: "overlay"))
        
        //gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        self.view.addGestureRecognizer(pinchGesture)
        pickFace.hidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        self.view.sendSubviewToBack(pickView)
        if !self.view.subviews.contains(overlayView) {
            overlayView.frame = CGRect(x: 70, y: 140, width: 100, height: 135)
            overlayView.userInteractionEnabled = true
            overlayView.tag = 10
            self.view.addSubview(overlayView)
        }
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //pickedImage.fixOrientation(pickedImage.imageOrientation)
        resizeImage = resizeImageFromFrame(pickedImage)
        resizeImage = resizeImage.fixOrientation(pickedImage.imageOrientation)
        pickView.frame = CGRect(x: pickView.frame.origin.x, y:pickView.frame.origin.y , width: resizeImage.size.width, height: resizeImage.size.height)
        pickView.image = resizeImage
        pickFace.hidden = false
        myAlbum.hidden = true
        takePhoto.hidden = true
        
        
    }
    
    @IBAction func captureFace(sender: UIButton) {
        let offsetX = overlayView.frame.origin.x - pickView.frame.origin.x
        let offsetY = overlayView.frame.origin.y - pickView.frame.origin.y
        
        
        let cgRef = resizeImage.CGImage;
        let imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(offsetX,offsetY, overlayView.frame.size.width, overlayView.frame.size.height))
        faceImage = UIImage(CGImage: imageRef!)
        faceImage=Toucan(image: faceImage).maskWithImage(maskImage: UIImage(named: "cut.png")!).image
        pickView.image = faceImage
        
        if let fromPageInfo = fromPage {
            let rootViewController = self.navigationController!
            let mainStoryboard: UIStoryboard = self.storyboard!
            if fromPageInfo == "static" {
                let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("StaticEmoji") as! StaticEmojiGen
                profileViewController.originalImage = faceImage
                rootViewController.pushViewController(profileViewController, animated: true)
            } else {
                let profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("DynamicEmoji") as! Dynamic
                profileViewController.faceImage = faceImage
                rootViewController.pushViewController(profileViewController, animated: true)
            }
        }
    }
                
    
    private func resizeImageFromFrame(originalImage: UIImage) -> (UIImage) {
        let image = CIImage(image: originalImage)
        let ratioW = Double((self.view.frame.size.width)/(originalImage.size.width))
        let ratioH = Double((self.view.frame.size.height)/(originalImage.size.height))
        let ratio = min(ratioH, ratioW)
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(ratio, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
        let outputImage = filter.valueForKey(kCIOutputImageKey) as! CIImage
        
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
        let scaledImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent))
        return scaledImage
    }
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer){
        var factor = sender.scale
        if factor > 1{
            //图片放大
             overlayView.transform = CGAffineTransformMakeScale(lastScaleFactor+factor-1, lastScaleFactor+factor-1)
        }else{
            //缩小
            overlayView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor)
        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            if factor > 1{
                lastScaleFactor = lastScaleFactor + factor - 1
            }else{
                lastScaleFactor = lastScaleFactor * factor
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGenerater" {
            let svc = segue.destinationViewController as! StaticEmojiGenII
        }
    }
        
    
   
    
    @IBAction func save(sender: UIButton) {        CustomPhotoAlbum.sharedInstance.saveImage(faceImage)

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		let touch = touches.first!
		let location = touch.locationInView(self.view)
		if let node = touch.view {
			if node.tag == 10 {
				let newLocation = CGPoint(x: location.x, y: location.y)
				node.center = newLocation
			}
		}
	}


	private func resizeImageFromFrame(originalImage: UIImage) -> (UIImage) {
		let image = CIImage(image: originalImage)
		let ratioW = Double((self.view.frame.size.width) / (originalImage.size.width))
		let ratioH = Double((self.view.frame.size.height) / (originalImage.size.height))
		let ratio = min(ratioH, ratioW)
		let filter = CIFilter(name: "CILanczosScaleTransform")!
		filter.setValue(image, forKey: kCIInputImageKey)
		filter.setValue(ratio, forKey: kCIInputScaleKey)
		filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
		let outputImage = filter.valueForKey(kCIOutputImageKey) as! CIImage

		let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
		let scaledImage = UIImage(CGImage: context.createCGImage(outputImage, fromRect: outputImage.extent))
		return scaledImage
	}

	//捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
	func handlePinchGesture(sender: UIPinchGestureRecognizer) {
		let factor = sender.scale
		if factor > 1 {
			//图片放大
			overlayView.transform = CGAffineTransformMakeScale(lastScaleFactor + factor - 1, lastScaleFactor + factor - 1)
		} else {
			//缩小
			overlayView.transform = CGAffineTransformMakeScale(lastScaleFactor * factor, lastScaleFactor * factor)
		}
		//状态是否结束，如果结束保存数据
		if sender.state == UIGestureRecognizerState.Ended {
			if factor > 1 {
				lastScaleFactor = lastScaleFactor + factor - 1
			} else {
				lastScaleFactor = lastScaleFactor * factor
			}
		}
	}

	@IBAction func save(sender: UIButton) {
		if let currentImage = faceImage {
			UIImageWriteToSavedPhotosAlbum(currentImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
		}

	}

	func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) {
		if error == nil {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		} else {
			let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}
}
