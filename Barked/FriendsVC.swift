//
//  FriendsVC.swift
//  Barked
//
//  Created by MacBook Air on 4/28/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class FriendsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UserCellSubclassDelegate {
    
    var users = [Friend]()
    var filteredUsers = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        retrieveUser()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        friendsTableView.tableHeaderView = searchController.searchBar
        
        friendsTableView.backgroundView = UIImageView(image: UIImage(named: "FFBackground"))
        
    }
    
    func buttonTapped(cell: UserCell) {
        
        var isFollower = false
        
        guard let indexPath = friendsTableView.indexPath(for: cell) else {
            print("BRIAN: An error is occuring here")
            return
        }
        
        //  Do whatever you need to do with the indexPath
        
        var clickedUser: String
        
        if searchController.isActive && searchController.searchBar.text != "" {
            clickedUser = filteredUsers[indexPath.row].userID
        } else {
            clickedUser = users[indexPath.row].userID
        }
                
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let following = snapshot.value as? [String: AnyObject] {
                for (ke, value) in following {
                    
                    if value as? String == clickedUser {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(clickedUser).child("followers/\(ke)").removeValue()
                        print("LEEZUS: This is you \(clickedUser)")
                        
                        cell.followButton.image = UIImage(named: "follow")
                        
                    }
                }
            }
            
            if isFollower == false {
                let following = ["following/\(key)" : clickedUser]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(clickedUser).updateChildValues(followers)
                
                cell.followButton.image = UIImage(named: "followed")
                
            }
            
        })
        
        ref.removeAllObservers()
        
    }
    
    // Search Functionality
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { user in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        
        friendsTableView.reloadData()
    }
    
    func retrieveUser() {
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            self.users.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = Friend()
                        if let username = value["username"] as? String {
                            let imagePath = value["photoURL"] as? String
                            
                            userToShow.username = username
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.users.append(userToShow)
    
                        }
                    }
                }
            }
            
            self.friendsTableView.reloadData()
            
        })
        
        ref.removeAllObservers()
        
    }
    
    // MARK: - Table view data source
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let someFriend: Friend
        if searchController.isActive && searchController.searchBar.text != "" {
            someFriend = filteredUsers[indexPath.row]
        } else {
            someFriend = users[indexPath.row]
        }

        let someUID = someFriend.userID
        
        if let cell = friendsTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell {
            cell.userDelegate = self
            cell.backgroundColor = UIColor.clear
            cell.configure(friend: someFriend, indexPath: someUID!)
            cell.checkFollowing(indexPath: someUID!)
            return cell
        } else {
            return UserCell() 
        }
    }
    
    
        
//        if let cell = friendsTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell {
//        
//        let friend: Friend
//        if searchController.isActive && searchController.searchBar.text != "" {
//            friend = filteredUsers[indexPath.row]
//            
//        } else {
//            friend = users[indexPath.row]
//        }
//            
//        cell.userName.text = friend.username
//        cell.userID = friend.userID
//        cell.userImage.downloadImage(from: friend.imagePath!)
//        checkFollowing(indexPath: indexPath)
//        return cell
//        } else {
//            return UserCell()
//    }
//}
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        let key = ref.child("users").childByAutoId().key
//
//        var isFollower = false
//        soundEffect()
//        playSound()
//        
//        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            if let following = snapshot.value as? [String: AnyObject] {
//                for (ke, value) in following {
//                    
//                    if value as! String == self.users[indexPath.row].userID {
//                        isFollower = true
//                        
//                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
//                        ref.child("users").child(self.users[indexPath.row].userID).child("followers/\(ke)").removeValue()
//                        print("LEEZUS: This is you \(self.users[indexPath.row].userID)")
//                        
//                        self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .none
//                        
//                    }
//                }
//            }
//            
//            if !isFollower {
//                let following = ["following/\(key)" : self.users[indexPath.row].userID]
//                let followers = ["followers/\(key)" : uid]
//                
//                ref.child("users").child(uid).updateChildValues(following)
//                ref.child("users").child(self.users[indexPath.row].userID).updateChildValues(followers)
//                
//                self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//                
//            }
//            
//        })
//        
//        ref.removeAllObservers()
//        
//    }

//    func checkFollowing(indexPath: IndexPath) {
//        
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        
//        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            if let following = snapshot.value as? [String: AnyObject] {
//                for (_, value) in following {
//                    if value as! String == self.users[indexPath.row].userID {
//                        self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//                    }
//                }
//            }
//        })
//        
//        ref.removeAllObservers()
//        
//    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func profileBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    // Play Sounds
    
    var gameSound: SystemSoundID = 0
    
    func soundEffect() {
        let path = Bundle.main.path(forResource: "Liked", ofType: "mp3")!
        let soundURL = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    
}

extension UIImageView {
    
    func downloadImage(from imageURL: String!) {
        let url = URLRequest(url: URL(string: imageURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
            }
        }
        
        task.resume()
        
    }
    
}

extension FriendsVC: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}

