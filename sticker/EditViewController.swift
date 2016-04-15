//
//  EditViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    @IBAction func unwindToAddSticker(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectSticker" {
            let controller = segue.sourceViewController as! CollectionViewController
            if let selected = controller.collectionView?.indexPathsForSelectedItems() {
                let image = controller.images[selected[0].row]
                let sticker = UIImageView(image: UIImage(named: image))
                self.view.insertSubview(sticker, belowSubview: self.view.viewWithTag(20)!)
                sticker.center = self.view.center
                sticker.userInteractionEnabled = true
                stickers.append(sticker)
                
                defaultStickerRect = sticker.frame
                
                sticker.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(EditViewController.handleMove(_:))))
                
                let pinch = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.handleScale(_:)))
                sticker.addGestureRecognizer(pinch)
                pinch.delegate = self
                
                let rotation = UIRotationGestureRecognizer(target: self, action: #selector(EditViewController.handleRotate(_:)))
                sticker.addGestureRecognizer(rotation)
                rotation.delegate = self
            }
        }
    }
    
    func getImageRectFromSticker(sticker: UIImageView)->CGRect {
        let imageView = self.view.viewWithTag(10) as! UIImageView
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
        let image = (self.view.viewWithTag(10) as! UIImageView).image!
        
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
    
    func handleMove(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleScale(recognizer:UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale)
        }
        
        recognizer.scale = 1
    }
    
    func handleRotate(recognizer:UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
        }
        recognizer.rotation = 0
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}