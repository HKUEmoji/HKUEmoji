//
//  StaticEmojiGenII.swift
//  HKUEmoji
//
//  Created by Wang Youan on 3/12/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import ImageIO
import GPUImage

class StaticEmojiGenII: UIViewController {

	var leftEyeBound: CGRect?
	var rightEyeBound: CGRect?
	var mouthBound: CGRect?
	var faceImage: UIImage?

	var currentImage: String = ""
    var inputText: String! {
        didSet {
            self.drawImagesAndText()
        }
    }
	var trueEmojiNames = ["CP3 2": 0,
		"CP3": 0,
		"curry1": 1,]

	var cartoonEmojiNames = ["erkangface": CGRect(x: 172, y: 114, width: 151, height: 188)]

	var currentFilter: CIFilter!

	lazy var context: CIContext = {
		return CIContext(options: nil)
	}()

	var backgroundImage: UIImage!

	@IBOutlet weak var imageView: UIImageView!

	@IBAction func chooseBackground(sender: AnyObject) {
		//		displayBackGround()
		//        let chooseBackgroundView = UICollectionViewController()

	}

	@IBAction func addText(sender: AnyObject) {

		//1. Create the alert controller.
		let alert = UIAlertController(title: "Input", message: "Enter a text", preferredStyle: .Alert)

		//2. Add the text field. You can configure it however you need.
		alert.addTextFieldWithConfigurationHandler({(textField) -> Void in
				textField.text = ""
			})

		//3. Grab the value from the text field, and print it when the user clicks OK.
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
					let textField = alert.textFields![0] as UITextField
					self.inputText = textField.text!
				}))

		// 4. Present the alert.
		self.presentViewController(alert, animated: true, completion: nil)
	}

	@IBAction func changeThreshold(sender: AnyObject) {
		let sketchFilter = GPUImageThresholdSketchFilter()
		sketchFilter.edgeStrength = 0.847457647
		sketchFilter.threshold = 0.402542382
		let toonFilter = GPUImageToonFilter()
		toonFilter.texelHeight = 0.0027118644
		toonFilter.texelWidth = 0.001610169559
		toonFilter.threshold = 0.70762711763381958

		let filterGroup = GPUImageFilterGroup()

		filterGroup.addFilter(sketchFilter)
		filterGroup.addFilter(toonFilter)

		filterGroup.initialFilters = [toonFilter]
		toonFilter.addTarget(sketchFilter)
		filterGroup.terminalFilter = sketchFilter

		let processedImage = filterGroup.imageByFilteringImage(faceImage)
		imageView.image = addFaceToBackGround(self.cartoonEmojiNames.values.first!, backgroundImage: backgroundImage, faceImage: processedImage)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		if currentImage == "" {
			currentImage = self.cartoonEmojiNames.first!.0
		}
		//        changeBackground(UIAlertAction(title: currentImage.0, style: .Default, handler: nil))

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "saveOrShare")
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		self.changeBackground(UIAlertAction(title: self.currentImage, style: .Default, handler: nil))
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "choose background" {
			let svc = segue.destinationViewController as! ChooseStaticEmojiBackground
			svc.cartoonEmojiBackground = Array(self.cartoonEmojiNames.keys)
			svc.trueEmojiBackground = Array(self.trueEmojiNames.keys)
		}
	}

	/**
	 add face image to the background

	 - parameter faceBound:       the bound information of the face
	 - parameter backgroundImage: background image
	 - parameter faceImage:       face image

	 - returns: a image with face inside.
	 */
	func addFaceToBackGround(faceBound: CGRect, backgroundImage: UIImage, faceImage: UIImage) -> UIImage {
		//        let ratio = min(faceBound.height / faceImage.size.height, faceBound.width / faceImage.size.width)
		//        let newFaceImage = StaticEmojiGen.resizeImageFromRatio(faceImage, ratio: Double(ratio))
		UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
		backgroundImage.drawInRect(CGRect(origin: CGPointZero, size: backgroundImage.size))
		faceImage.drawInRect(faceBound)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}

	/**
	 faceBoundDetection function used to detect face bound

	 - parameter originPic: the picture need to be detected

	 - returns: the bound of face info
	 */
	func faceBoundDetection(originPic: UIImage) -> CGRect {
		let inputImage = CIImage(image: originPic)
		let detector = CIDetector(ofType: CIDetectorTypeFace, context: context,
			options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
		var faceFeatures: [CIFaceFeature]!
		if let orientation: AnyObject = inputImage?.properties[kCGImagePropertyOrientation as String] {
			faceFeatures = detector.featuresInImage(inputImage!,
				options: [CIDetectorImageOrientation: orientation]
			) as! [CIFaceFeature]
		} else {
			faceFeatures = detector.featuresInImage(inputImage!) as! [CIFaceFeature]
		}

		var transform = CGAffineTransformMakeScale(1 / originPic.scale, 1 / originPic.scale)
		var bounds = CGRectApplyAffineTransform(faceFeatures[self.trueEmojiNames[currentImage]!].bounds, transform)

		transform = CGAffineTransformMakeScale(1, -1)
		transform = CGAffineTransformTranslate(transform, 0, -originPic.size.height)
		bounds = CGRectApplyAffineTransform(bounds, transform)
		bounds.size.height *= 1.25
		bounds.size.width *= 1.1
		return bounds
	}

	func saveOrShare() {
		if let currentImage = backgroundImage {
			UIImageWriteToSavedPhotosAlbum(currentImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
		}
	}
    
    func drawImagesAndText() {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageView.image!.size.width, height: (imageView.image!.size.height + 100)), false, 0)
        _ = UIGraphicsGetCurrentContext()
        
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        // 3
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 30)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        // 4
        self.inputText.drawWithRect(CGRect(x: 32, y: 32, width: imageView.image!.size.width, height: 100), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
        
        // 5
        let mouse = imageView.image
        mouse?.drawAtPoint(CGPoint(x: 0, y: 100))
        
        // 6
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 7
        imageView.image = img
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

	func getCartoonFace(originalImage: UIImage) -> (UIImage) {
		let sketchFilter = GPUImageThresholdSketchFilter()
		sketchFilter.edgeStrength = 0.847457647
		sketchFilter.threshold = 0.402542382
		let toonFilter = GPUImageToonFilter()
		toonFilter.texelHeight = 0.0027118644
		toonFilter.texelWidth = 0.001610169559
		toonFilter.threshold = 0.70762711763381958

		let filterGroup = GPUImageFilterGroup()

		filterGroup.addFilter(sketchFilter)
		filterGroup.addFilter(toonFilter)

		filterGroup.initialFilters = [toonFilter]
		toonFilter.addTarget(sketchFilter)
		filterGroup.terminalFilter = sketchFilter

		let processedImage = filterGroup.imageByFilteringImage(faceImage)
		return processedImage
	}

	/**
	 use UIAlertController to display exist background info
	 */
	func displayBackGround() {
		let ac = UIAlertController(title: "Choose Background", message: "Please choose a image as your background", preferredStyle: .Alert)
		for background in trueEmojiNames {
			ac.addAction(UIAlertAction(title: background.0, style: .Default, handler: changeBackground))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}

	/**
	 change the background of emotion

	 - parameter action: as this function used for uialert.
	 */
	func changeBackground(action: UIAlertAction) {
		if self.trueEmojiNames.keys.contains(action.title!) {
			currentImage = action.title!
			backgroundImage = UIImage(named: self.currentImage)
			let backgroundbond = faceBoundDetection(backgroundImage!)
			backgroundImage = addFaceToBackGround(backgroundbond, backgroundImage: backgroundImage, faceImage: faceImage!)
			imageView.image = backgroundImage
		} else if self.cartoonEmojiNames.keys.contains(action.title!) {
			let newFaceImage = getCartoonFace(faceImage!)
			backgroundImage = UIImage(named: "\(action.title!).png")
			backgroundImage = addFaceToBackGround(self.cartoonEmojiNames[action.title!]!, backgroundImage: backgroundImage, faceImage: newFaceImage)
			imageView.image = backgroundImage
		} else {
			print("there must be something wrong")
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
