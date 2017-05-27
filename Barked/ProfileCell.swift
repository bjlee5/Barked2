//
//  MyPostCell.swift
//  Barked
//
//  Created by MacBook Air on 4/28/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase

class ProfileCell: UICollectionViewCell {
    
 
    @IBOutlet weak var myImage: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        
        if img != nil {
            self.myImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("BRIAN: Unable to download image from Firebase")
                } else {
                    print("Image downloaded successfully")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.myImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString!)
                        }
                    }
                    
                    
                }
            })
        }
    }
    
}

