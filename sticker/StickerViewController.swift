//
//  StickerViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class StickerViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.viewControllers?.count == 1 {
            var controllers = self.viewControllers!
            
            // get all folder under stickers
            if var resource = NSBundle.mainBundle().resourcePath {
                resource += "/stickers"
                let stickerFolders = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(resource)
                for stickerFolder in stickerFolders! {
                    let tab = self.storyboard!.instantiateViewControllerWithIdentifier("collection") as! CollectionViewController
                    tab.gotStickers(resource + "/" + stickerFolder)
                    controllers.append(tab)
                }
            }
            self.viewControllers = controllers
            self.selectedIndex = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
