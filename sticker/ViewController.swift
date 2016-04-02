//
//  ViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/22.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

    @IBAction func useCamera(sender: AnyObject) {
        open(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        open(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    func open(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Editor") as! EditViewController
        let imageView = vc.view.viewWithTag(10) as! UIImageView
        let picture = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = picture
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

