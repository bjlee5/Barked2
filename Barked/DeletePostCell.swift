//
//  DeletePostCell.swift
//  Barked
//
//  Created by MacBook Air on 5/5/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase

class DeletePostCell: UITableViewCell {
    
    var likesRef: FIRDatabaseReference!
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil, proImg: UIImage? = nil) {
        
        self.likesRef = DataService.ds.REF_CURRENT_USERS.child("likes").child(post.postKey)
        self.postCaption.text = post.caption
        self.postLikes.text = "\(post.likes)"
        self.postDate.text = post.currentDate
        
        let userRef = DataService.ds.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        userRef.observe(.value, with: { (snapshot) in
            self.postUser.text = "\(post.postUser)"
        })
        
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("BRIAN: Unable to download image from Firebase")
                } else {
                    print("Image downloaded successfully")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString!)
                        }
                    }
                    
                    
                }
            })
        }
    }

}
