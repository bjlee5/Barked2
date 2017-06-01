//
//  FeedVC.swift
//  Barked
//
//  Created by MacBook Air on 4/28/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Foundation

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CellSubclassDelegate {
    
    
////////////////// bestInShow() - the function I have may work - however I need to make a call to Firebase to change the bestInShow value 
    
    // Refactor this storage ref using DataService //
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var storageRef: FIRStorage { return FIRStorage.storage() }
    var profilePicLoaded = false 
    var following = [String]()
    /// Referencing the Storage DB then, current User
    let userRef = DataService.ds.REF_BASE.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
    var selectedUID: String = ""

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var currentUser: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.isHidden = true
        currentUser.isHidden = true
        
        self.posts.sort(by: self.sortDatesFor)
        followingFriends()
        loadUserInfo()
        fetchPosts()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets.zero
        

        // Dismiss Keyboard //
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    } // End ViewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchPosts()
        followingFriends()
        tableView.reloadData()
        self.posts.sort(by: self.sortDatesFor)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - NSDate Stuff
    
    
    func mayRangeContains(date: Date) -> Bool {
        
        let may_1_2017 = DateComponents(calendar: Calendar.current,
                                        timeZone: TimeZone.current,
                                        era: nil,
                                        year: 2017,
                                        month: 5,
                                        day: 1).date!
        
        let may_31_2017 = DateComponents(calendar: Calendar.current,
                                         timeZone: TimeZone.current,
                                         era: nil,
                                         year: 2017,
                                         month: 5,
                                         day: 31).date!

        
        let dateRange = may_1_2017 ... may_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func juneRangeContains(date: Date) -> Bool {
        
        let june_1_2017 = DateComponents(calendar: Calendar.current,
                                        timeZone: TimeZone.current,
                                        era: nil,
                                        year: 2017,
                                        month: 6,
                                        day: 1).date!
        
        let june_31_2017 = DateComponents(calendar: Calendar.current,
                                         timeZone: TimeZone.current,
                                         era: nil,
                                         year: 2017,
                                         month: 6,
                                         day: 31).date!
        
        
        let dateRange = june_1_2017 ... june_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func julyRangeContains(date: Date) -> Bool {
        
        let july_1_2017 = DateComponents(calendar: Calendar.current,
                                         timeZone: TimeZone.current,
                                         era: nil,
                                         year: 2017,
                                         month: 7,
                                         day: 1).date!
        
        let july_31_2017 = DateComponents(calendar: Calendar.current,
                                          timeZone: TimeZone.current,
                                          era: nil,
                                          year: 2017,
                                          month: 7,
                                          day: 31).date!
        
        
        let dateRange = july_1_2017 ... july_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func augustRangeContains(date: Date) -> Bool {
        
        let august_1_2017 = DateComponents(calendar: Calendar.current,
                                         timeZone: TimeZone.current,
                                         era: nil,
                                         year: 2017,
                                         month: 8,
                                         day: 1).date!
        
        let august_31_2017 = DateComponents(calendar: Calendar.current,
                                          timeZone: TimeZone.current,
                                          era: nil,
                                          year: 2017,
                                          month: 8,
                                          day: 31).date!
        
        
        let dateRange = august_1_2017 ... august_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func septemberRangeContains(date: Date) -> Bool {
        
        let september_1_2017 = DateComponents(calendar: Calendar.current,
                                           timeZone: TimeZone.current,
                                           era: nil,
                                           year: 2017,
                                           month: 9,
                                           day: 1).date!
        
        let september_31_2017 = DateComponents(calendar: Calendar.current,
                                            timeZone: TimeZone.current,
                                            era: nil,
                                            year: 2017,
                                            month: 9,
                                            day: 30).date!
        
        
        let dateRange = september_1_2017 ... september_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func octoberRangeContains(date: Date) -> Bool {
        
        let october_1_2017 = DateComponents(calendar: Calendar.current,
                                              timeZone: TimeZone.current,
                                              era: nil,
                                              year: 2017,
                                              month: 10,
                                              day: 1).date!
        
        let october_31_2017 = DateComponents(calendar: Calendar.current,
                                               timeZone: TimeZone.current,
                                               era: nil,
                                               year: 2017,
                                               month: 10,
                                               day: 31).date!
        
        
        let dateRange = october_1_2017 ... october_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func novemberRangeContains(date: Date) -> Bool {
        
        let november_1_2017 = DateComponents(calendar: Calendar.current,
                                            timeZone: TimeZone.current,
                                            era: nil,
                                            year: 2017,
                                            month: 11,
                                            day: 1).date!
        
        let november_30_2017 = DateComponents(calendar: Calendar.current,
                                             timeZone: TimeZone.current,
                                             era: nil,
                                             year: 2017,
                                             month: 11,
                                             day: 30).date!
        
        
        let dateRange = november_1_2017 ... november_30_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    func decemberRangeContains(date: Date) -> Bool {
        
        let december_1_2017 = DateComponents(calendar: Calendar.current,
                                            timeZone: TimeZone.current,
                                            era: nil,
                                            year: 2017,
                                            month: 12,
                                            day: 1).date!
        
        let december_31_2017 = DateComponents(calendar: Calendar.current,
                                             timeZone: TimeZone.current,
                                             era: nil,
                                             year: 2017,
                                             month: 12,
                                             day: 31).date!
        
        
        let dateRange = december_1_2017 ... december_31_2017
        
        if dateRange.contains(date) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Best in Show

    func bestInShow() {
        
        var postLikes = [Int]()

        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if mayRangeContains(date: date!) {
                
                let myLikes = post.likes
                postLikes.append(myLikes)
                let mostLikes = postLikes.max()
                
                if post.likes >= mostLikes! {
                
                DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
            } else {
                DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
            }
        }
    }
}
    
    func juneBestInShow() {
        
        var junePostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if juneRangeContains(date: date!) {
                
                let myLikes = post.likes
                junePostLikes.append(myLikes)
                let mostLikes = junePostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }
    
    func julyBestInShow() {
        
        var julyPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if julyRangeContains(date: date!) {
                
                let myLikes = post.likes
                julyPostLikes.append(myLikes)
                let mostLikes = julyPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }
    
    func augustBestInShow() {
        
        var augustPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if augustRangeContains(date: date!) {
                
                let myLikes = post.likes
                augustPostLikes.append(myLikes)
                let mostLikes = augustPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }
    
    func septemberBestInShow() {
        
        var septemberPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if septemberRangeContains(date: date!) {
                
                let myLikes = post.likes
                septemberPostLikes.append(myLikes)
                let mostLikes = septemberPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }
    
    func octoberBestInShow() {
        
        var octoberPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if octoberRangeContains(date: date!) {
                
                let myLikes = post.likes
                octoberPostLikes.append(myLikes)
                let mostLikes = octoberPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }

    
    func novemberBestInShow() {
        
        var novemberPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if novemberRangeContains(date: date!) {
                
                let myLikes = post.likes
                novemberPostLikes.append(myLikes)
                let mostLikes = novemberPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }
    
    func decemberBestInShow() {
        
        var decemberPostLikes = [Int]()
        
        for post in self.posts {
            
            let someDate = post.currentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: someDate)
            
            if decemberRangeContains(date: date!) {
                
                let myLikes = post.likes
                decemberPostLikes.append(myLikes)
                let mostLikes = decemberPostLikes.max()
                
                if post.likes >= mostLikes! {
                    
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": true])
                } else {
                    DataService.ds.REF_POSTS.child(post.postKey).updateChildValues(["bestInShow": false])
                }
            }
        }
    }


    
    func loadUserInfo(){
        userRef.observe(.value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            let imageURL = user.photoURL!
            self.currentUser.text = user.username

            
            /// We are downloading the current user's ImageURL then converting it using "data" to the UIImage which takes a property of data
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let data = imgData {
                            self.profilePic.image = UIImage(data: data)
                            self.profilePicLoaded = true
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /// Sort Feed of Posts by Current Date
    func sortDatesFor(this: Post, that: Post) -> Bool {
        return this.currentDate > that.currentDate
    }
    
    /// Sort Feed of Posts by Amount of Likes
    func sortLikesFor(this: Post, that: Post) -> Bool {
        return this.likes > that.likes
    }
    
    // Show Current User Feed
    
    func followingFriends() {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            
            for (_, value) in users {
                if let uName = value["username"] as? String {
                    self.userRef.observe(.value, with: { (snapshot) in
                        
                        let myUser = Users(snapshot: snapshot)
                        
                        if uName == myUser.username {
                            if let followingUsers = value["following"] as? [String: String] {
                                for (_, user) in followingUsers {
                                    self.following.append(user)
                                    
                                }
                            }
                            
                            self.following.append((FIRAuth.auth()?.currentUser?.uid)!)
                            print("BRIAN: You are following these users \(self.following)")
                            
                        }
                    })
                }
            }
            
            self.fetchPosts()
        })
    }
    
    func fetchPosts() {
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        print("POST: \(postDict)")
                        if let postUser = postDict["uid"] as? String {
                            if self.following.contains(postUser) {
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                self.posts.append(post)

                            }
                        }
                    }
                }
                
                self.tableView.reloadData()
                self.posts.sort(by: self.sortDatesFor)
                self.bestInShow()
                self.juneBestInShow()
                self.julyBestInShow()
                self.augustBestInShow()
                self.septemberBestInShow()
                self.octoberBestInShow()
                self.novemberBestInShow()
                self.decemberBestInShow()
            }
        })
        
    }
    
    // User Feed //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
    
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            cell.delegate = self
            
            if post.bestInShow == true {
                cell.bestShowPic.isHidden = false
            } else {
                cell.bestShowPic.isHidden = true
            }

            
            // Cell Styling
            
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.white.cgColor
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString!), let proImg = FeedVC.imageCache.object(forKey: post.profilePicURL as NSString!) {
                cell.configureCell(post: post, img: img, proImg: proImg)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            
            return PostCell()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendProfileVC" {
            print("LEEZUS: Segway to FriendsVC performed!!")
            let destinationViewController = segue.destination as! FriendProfileVC
            destinationViewController.selectedUID = selectedUID
        }
    }
    
    func buttonTapped(cell: PostCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
        return
        }
        
        //  Do whatever you need to do with the indexPath
        
        print("BRIAN: Button tapped on row \(indexPath.row)")
        let clickedUser = posts[indexPath.row].uid
        DataService.ds.REF_BASE.child("users/\(clickedUser)").observe(.value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            self.selectedUID = user.uid
            self.checkSelectedUID()
    })
}
    
    func checkSelectedUID() {
        if selectedUID == FIRAuth.auth()?.currentUser?.uid {
            performSegue(withIdentifier: "MyProfileVC", sender: self)
        } else if selectedUID != "" {
            performSegue(withIdentifier: "FriendProfileVC", sender: self)
        }
    }

    @IBAction func profileBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileVC")
        self.present(vc, animated: true, completion: nil)
    }

    // Logging Out //
    
    @IBAction func signOutPress(_ sender: Any) {
    
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            
            // This code causes view stacking (potentially memory leaks), but cannot figure out a better way to get to LogInVC and clear the log in text //
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC")
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
