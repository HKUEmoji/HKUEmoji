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


class cameraTool : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var pickView: UIImageView!

	var overlayView: UIImageView!
	var choosedPicture: UIImage!
	var resizeImage : UIImage!
	var lastScaleFactor : CGFloat! = 1 //放大、缩小
	//    @IBOutlet weak var overlayView: UIImageView!

	// 初始化图片选择控制器
	let imagePicker: UIImagePickerController = UIImagePickerController()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		choosedPicture = UIImage(named: "curry1")
		//let ratioX = ((pickView.frame.size.width)/(choosedPicture.size.width))
		//let ratioY = ((pickView.frame.size.height)/(choosedPicture.size.height))
		//let ratio = min(ratioX, ratioY)
		//        pickView.frame = CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height)
		//        pickView.image = resizeImage

		//pickView.image = choosedPicture
		//        pickView.userInteractionEnabled = false
		overlayView = UIImageView(image: UIImage(named: "overlay.png"))

		//gesture
		let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
		self.view.addGestureRecognizer(pinchGesture)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		self.view.sendSubviewToBack(pickView)
		resizeImage = resizeImageFromFrame(choosedPicture)
		pickView.image = resizeImage
		if !self.view.subviews.contains(overlayView) {
			overlayView.frame = CGRect(x: 70, y: 140, width: 100, height: 135)
			overlayView.userInteractionEnabled = true
			overlayView.tag = 10
			self.view.addSubview(overlayView)
		}
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
		resizeImage = resizeImageFromFrame(pickedImage!)
		//        pickView.frame = CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height)
		pickView.image = resizeImage
	}


	@IBAction func captureFace(sender: UIButton) {
		let offsetX = overlayView.frame.origin.x - pickView.frame.origin.x
		let offsetY = overlayView.frame.origin.y - pickView.frame.origin.y


		let cgRef = resizeImage.CGImage;
		let imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(offsetX, offsetY, overlayView.frame.size.width, overlayView.frame.size.height))
		var faceImage = UIImage(CGImage: imageRef!)
		faceImage = Toucan(image: faceImage).maskWithImage(maskImage: UIImage(named: "cut.png")!).image
		pickView.image = faceImage

	}

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
