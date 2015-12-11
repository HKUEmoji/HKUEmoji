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

	var currentImage: (String, Int)!
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
	@IBAction func changeThreshold(sender: AnyObject) {
		//        let lowpassFilter = GPUImageLowPassFilter()
		//        lowpassFilter.filterStrength = 0.7
		let sketchFilter = GPUImageThresholdSketchFilter()
		        //        sketchFilter.texelWidth = 1
		        //        sketchFilter.texelHeight = 1
		sketchFilter.edgeStrength = 0.847457647
		sketchFilter.threshold = 0.402542382
		let toonFilter = GPUImageToonFilter()
		toonFilter.texelHeight = 0.0027118644
        toonFilter.texelWidth = 0.001610169559
		toonFilter.threshold = 0.70762711763381958
		
		let filterGroup = GPUImageFilterGroup()
		//        filterGroup.addFilter(crosshatchFilter)

//		let blackWhiteFilter = GPUImageGrayscaleFilter()
//        let crossHathcFilter = GPUImageCrosshatchFilter()
//        crossHathcFilter.lineWidth = CGFloat(toonFilterThresthod.value) / 1000
//        crossHathcFilter.crossHatchSpacing = CGFloat(edgeStrength.value) / 100

		filterGroup.addFilter(sketchFilter)
		filterGroup.addFilter(toonFilter)
//		filterGroup.addFilter(blackWhiteFilter)
//        filterGroup.addFilter(crossHathcFilter)
		//        toonFilter.addTarget(lowpassFilter)
		//        lowpassFilter.addTarget(sketchFilter)

//		crossHathcFilter.addTarget(sketchFilter)

		filterGroup.initialFilters = [toonFilter]
		toonFilter.addTarget(sketchFilter)
		filterGroup.terminalFilter = sketchFilter

		let processedImage = filterGroup.imageByFilteringImage(faceImage)
		imageView.image = addFaceToBackGround(self.cartoonEmojiNames.values.first!, backgroundImage: backgroundImage, faceImage: processedImage)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		currentImage = trueEmojiNames.first!
		//        changeBackground(UIAlertAction(title: currentImage.0, style: .Default, handler: nil))
		changeBackground(UIAlertAction(title: "erkangface", style: .Default, handler: nil))

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "saveOrShare")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
		var bounds = CGRectApplyAffineTransform(faceFeatures[self.currentImage.1].bounds, transform)

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

	func changeBackground(action: UIAlertAction) {
		if self.trueEmojiNames.keys.contains(action.title!) {
			currentImage = (action.title!, self.trueEmojiNames[action.title!]!)
			backgroundImage = UIImage(named: self.currentImage.0)
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
