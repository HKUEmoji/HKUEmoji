//
//  StaticEmojiGen.swift
//  HKUEmoji
//
//  Created by Wang Youan on 30/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit
import ImageIO
import GPUImage

class StaticEmojiGen: UIViewController {

	@IBOutlet weak var imageShow: UIImageView!
	@IBOutlet weak var leftEye: UIImageView!
	@IBOutlet weak var rightEye: UIImageView!
	@IBOutlet weak var background: UIView!
	@IBOutlet weak var mouth: UIImageView!

	var faceBound: CGRect!
    
    var originalImage: UIImage!

//	lazy var originalImage: UIImage = {
//		return UIImage(named: "test.png")
//	}()!

	lazy var context: CIContext = {
		return CIContext(options: nil)
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Give the following view initial image and change the touchable information
		imageShow.image = originalImage
		imageShow.userInteractionEnabled = false
		mouth.image = UIImage(named: "mouth")
		mouth.userInteractionEnabled = true
		leftEye.image = UIImage(named: "eye")
		leftEye.userInteractionEnabled = true
		rightEye.image = UIImage(named: "eye")
		rightEye.userInteractionEnabled = true
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}

	/**
	 this function used to detect the face feature of a picture, include eyes and others
	 */
	func detecFace() {
		let inputImage = CIImage(image: originalImage)
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

		if let faceFeature = faceFeatures.first as CIFaceFeature! {
			//            print(faceFeature.bounds)

			faceBound = faceFeature.bounds
            var newFaceBound = faceBound
            var eyeHeight: CGFloat?
			if faceFeature.hasLeftEyePosition {
                newFaceBound.origin.x = faceFeature.leftEyePosition.x - faceFeature.bounds.size.width * 0.15
                eyeHeight = faceFeature.leftEyePosition.y + faceFeature.bounds.size.width * 0.1
				leftEye.frame = adjustFaceFeatures(CGRect(origin: faceFeature.leftEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
			}

			if faceFeature.hasRightEyePosition {
                if let temp = eyeHeight {
                    eyeHeight = (temp + faceFeature.rightEyePosition.y + faceFeature.bounds.size.width * 0.1) / 2
                } else {
                    eyeHeight = faceFeature.rightEyePosition.y + faceFeature.bounds.size.width * 0.1
                }
                newFaceBound.size.width = faceFeature.rightEyePosition.x + faceFeature.bounds.size.width * 0.15 - newFaceBound.origin.x
				rightEye.frame = adjustFaceFeatures(CGRect(origin: faceFeature.rightEyePosition, size: CGSize(width: faceFeature.bounds.size.width * 0.25, height: faceFeature.bounds.size.width * 0.15)))
			}

			if faceFeature.hasMouthPosition {
                if let test = eyeHeight {
                    newFaceBound.size.height = test - faceFeature.mouthPosition.y + faceFeature.bounds.size.width * 0.1
                } else {
                    newFaceBound.size.height -= faceFeature.mouthPosition.y - faceBound.origin.y - faceFeature.bounds.size.width * 0.1
                }
                newFaceBound.origin.y = faceFeature.mouthPosition.y - faceFeature.bounds.size.width * 0.1
				mouth.frame = adjustFaceFeatures(CGRect(origin: faceFeature.mouthPosition, size: CGSize(width: faceFeature.bounds.size.width * 0.45, height: faceFeature.bounds.size.width * 0.2)))
			}
            faceBound = newFaceBound
		}
	}

	/**
	 This function used to adjust the eye and mouth location

	 - parameter frameRec: a CGRect that used to locate the original location and size of mouth or eye

	 - returns: the location and size of image
	 */
	func adjustFaceFeatures(frameRec: CGRect) -> CGRect {
		let originalImageSize = originalImage.size
		let scale = min(imageShow.bounds.height / originalImageSize.height, imageShow.bounds.width / originalImageSize.width)

		var transform = CGAffineTransformMakeScale(1, -1)
		transform = CGAffineTransformTranslate(transform, 0, -originalImageSize.height)
		var newBound = CGRectApplyAffineTransform(frameRec, transform)

		newBound.origin.x -= newBound.size.width / 2
		newBound.origin.y += newBound.size.height / 2
		transform = CGAffineTransformMakeScale(scale, scale)
		newBound = CGRectApplyAffineTransform(newBound, transform)

		let offsetX = (imageShow.bounds.width - originalImageSize.width * scale) / 2 + imageShow.frame.origin.x + background.frame.origin.x
		let offsetY = (imageShow.bounds.height - originalImageSize.height * scale) / 2 + imageShow.frame.origin.y + background.frame.origin.y

		newBound.origin.x += offsetX
		newBound.origin.y += offsetY

		return newBound
	}
    
    func adjustFaceBound(frameRec: CGRect) -> CGRect {
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -originalImage.size.height)
        return CGRectApplyAffineTransform(frameRec, transform)
    }

	/**
	 This function used to compress the image to the ratio

	 - parameter originalImage: original image
	 - parameter ratio:         the size of the image after compressed

	 - returns: a new image after compressed
	 */
    func resizeImageFromRatio(originalImage: UIImage, ratio: Double) -> (UIImage) {
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
    
    private func keepImageNeededPart(originImage image:UIImage, keepPart frame:CGRect) -> UIImage {
        let cgRef = image.CGImage
        let imageRef = CGImageCreateWithImageInRect(cgRef, frame)
        return UIImage(CGImage: imageRef!)
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showGenerater" {
			let svc = segue.destinationViewController as! StaticEmojiGenII
//			let scale = min(imageShow.bounds.height / originalImage.size.height, imageShow.bounds.width / originalImage.size.width)
			let offsetX = background.frame.origin.x + imageShow.frame.origin.x
			let offsetY = background.frame.origin.y + imageShow.frame.origin.y

			// transfer the bound info of this imageview to next function.
			if let bound1 = rightEye?.frame {
				svc.rightEyeBound = CGRect(origin: CGPoint(x: bound1.origin.x - offsetX, y: bound1.origin.y - offsetY), size: bound1.size)
			}

			if let bound1 = leftEye?.frame {
				svc.leftEyeBound = CGRect(origin: CGPoint(x: bound1.origin.x - offsetX, y: bound1.origin.y - offsetY), size: bound1.size)
			}

			if let bound1 = mouth?.frame {
				svc.mouthBound = CGRect(origin: CGPoint(x: bound1.origin.x - offsetX, y: bound1.origin.y - offsetY), size: bound1.size)
			}

            if let bound = faceBound {
                svc.faceImage = keepImageNeededPart(originImage: originalImage, keepPart: adjustFaceBound(bound))
            } else {
                svc.faceImage = originalImage
            }
		}
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		let touch = touches.first!
		let location = touch.locationInView(self.view)
		if let node = touch.view {
			if node.tag == 1024 {
				let newLocation = CGPoint(x: location.x, y: location.y)
				node.center = newLocation
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		detecFace()
		self.view.sendSubviewToBack(background)
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
