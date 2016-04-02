//
//  GobackViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class GoBackViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageFromSystemBarButton(systemItem: UIBarButtonSystemItem)-> UIImage {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.valueForKey("view") as! UIView
        for view in itemView.subviews {
            if view.isKindOfClass(UIButton){
                let button = view as! UIButton
                return button.imageView!.image!
            }
        }
        
        return UIImage()
    }
    
    var tabIcon: String = "" {
        didSet{
            self.tabBarItem.image = imageFromSystemBarButton(.Reply)
        }
    }
    
}
