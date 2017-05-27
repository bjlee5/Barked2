//
//  ForgotPasswordVC.swift
//  Barked
//
//  Created by MacBook Air on 4/28/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var emailField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func resetPassword(_ sender: Any) {
    
        let email = emailField.text!
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                showComplete("Password", subTitle: "You will receive an e-mail momentarily with instructions!")
                
            } else {
                showWarningMessage("Oops!", subTitle: "Please enter a valid e-mail address")
                print(error?.localizedDescription)
            }
            
        })
    }
    

    @IBAction func backPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC")
        self.present(vc, animated: true, completion: nil)
    }
    
} 

