//
//  EditViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    
    var defaultStickerRect: CGRect!
    var stickers: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func unwindToAddSticker(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectSticker" {
            let controller = segue.sourceViewController as! CollectionViewController
            if let selected = controller.collectionView?.indexPathsForSelectedItems() {
                
            }
        }
    }*/
    
    func getImageFrame() -> CGRect {
        let imageView = self.imageView
        let imageSize: CGSize! = imageView.image?.size
        var imageFrame = imageView.frame
        if imageSize.width/imageSize.height <  imageFrame.width/imageFrame.height{
            let w = imageFrame.height * imageSize.width / imageSize.height
            imageFrame.origin.x = (imageFrame.width - w) * CGFloat(0.5)
            imageFrame.size.width = w
        } else {
            let h =  imageFrame.width * imageSize.height / imageSize.width
            imageFrame.origin.y = (imageFrame.height - h) * CGFloat(0.5)
            imageFrame.size.height = h
        }
        
        return imageFrame;
    }
    
    func addSticker(image: String, on: CGPoint) {
        let sticker = UIImageView(image: UIImage(named: image))
        self.view.insertSubview(sticker, belowSubview: self.toolBar)
        sticker.userInteractionEnabled = true
        stickers.append(sticker)
        
        let imageView = self.imageView
        let imageSize: CGSize! = imageView.image?.size
        let imageFrame = getImageFrame()
        
        let scale = imageFrame.width / imageSize.width
        sticker.center.x = self.view.center.x - imageFrame.width*0.5 + on.x * scale
        sticker.center.y = self.view.center.y + imageFrame.height*0.5 - on.y * scale
        
        defaultStickerRect = sticker.frame
        
        let drag = DragGestureRecognizer(target: self, action: #selector(EditViewController.handleDrag(_:)))
        var frame = self.view.frame
        frame.size.height = frame.size.height - 44
        drag.focusRect = frame
        sticker.addGestureRecognizer(drag)
    }
    
    // detect mouth and add death breath
    func faceDetector() {
        let imageView = self.imageView
        let image = CIImage(CGImage: imageView.image!.CGImage!)
        
        let detector = CIDetector(ofType:CIDetectorTypeFace, context:nil, options:[CIDetectorAccuracy: CIDetectorAccuracyLow])
        let features:NSArray = detector.featuresInImage(image)
        
        for feature in features {
            if feature.hasMouthPosition == true {
                self.addSticker("stickers/atomic breath/deathray.png", on: feature.mouthPosition)
            }
        }
    }
    
    func getImageRectFromSticker(sticker: UIImageView)->CGRect {
        let imageView = self.imageView
        let imageSize: CGSize! = imageView.image?.size
        let imageFrame = getImageFrame()
        
        let scale = imageSize.width / imageFrame.width
        let stickerFrame = defaultStickerRect
        var rect = CGRectZero
        rect.origin.x = (sticker.center.x - stickerFrame.width * 0.5 - imageFrame.origin.x) * scale
        rect.origin.y = (sticker.center.y - stickerFrame.height * 0.5 - imageFrame.origin.y) * scale
        rect.size.width = stickerFrame.width * scale
        rect.size.height = stickerFrame.height * scale
        
        return rect
    }
    
    @IBAction func export(sender: AnyObject) {
        let image = self.imageView.image!
        
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        image.drawAtPoint(CGPointZero)
        for sticker in stickers {
            let stickerRect = self.getImageRectFromSticker(sticker)
            let centerX = stickerRect.origin.x + stickerRect.width * 0.5
            let centerY = stickerRect.origin.y + stickerRect.height * 0.5
            CGContextTranslateCTM(context, centerX, centerY)
            CGContextConcatCTM(context, sticker.transform)
            sticker.image!.drawInRect(
                CGRectMake(
                    -stickerRect.width*0.5,
                    -stickerRect.height*0.5,
                    stickerRect.width,
                    stickerRect.height
                )
            )
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activityItem: [AnyObject] = [newImage as AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        self.presentViewController(avc, animated: true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func handleDrag(recognizer:DragGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale)
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotate)
        }
        recognizer.rotate = 0
        recognizer.scale = 1
    }
    
}