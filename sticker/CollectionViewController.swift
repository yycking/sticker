//
//  CollectionViewController.swift
//  sticker
//
//  Created by YehYungCheng on 2016/3/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath)
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            imageView.image = UIImage(named: images[indexPath.row])
        }

        return cell
    }
    
    func gotStickers(stickerFolder: String) {
        let stickerImages = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(stickerFolder)
        for stickerImage in stickerImages! {
            self.images.append(stickerFolder + "/" + stickerImage)
        }
        let image = UIImage(named: images[0])
        self.tabBarItem.image = self.imageWithImage(image!, scaledToSize: CGSizeMake(30, 30))
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}