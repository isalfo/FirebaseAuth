//
//  AuthViewController.swift
//  FirebaseTest
//
//  Created by Gonzalo Alfonso on 30/09/2021.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class AuthViewController: UIViewController {

  @IBOutlet weak var emailTxt: UITextField!
  
  @IBOutlet weak var passTxt: UITextField!
  
  @IBOutlet weak var registerBtn: UIButton!
  @IBOutlet weak var logInBtn: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Authentication"
    Analytics.logEvent("InitScreen", parameters: ["message":"Firebase Integration Complete"])
  }

  @IBAction func registerClicked(_ sender: Any) {
    
    if let email = emailTxt.text, let pass = passTxt.text {
      Auth.auth().createUser(withEmail: email, password: pass) { result, error in
        if let result = result, error == nil {
          self.navigationController?.pushViewController(HomeViewController(email: result.user.email ?? "", provider: .basic), animated: true)
        } else {
          self.showSimpleAlert("Error", message: error?.localizedDescription ?? "")
        }
      }
    }
  }
  @IBAction func logInClicked(_ sender: Any) {
    
    if let email = emailTxt.text, let pass = passTxt.text {
      Auth.auth().signIn(withEmail: email, password: pass) { result, error in
        if let result = result, error == nil {
          self.navigationController?.pushViewController(HomeViewController(email: result.user.email ?? "", provider: .basic), animated: true)
        } else {
          self.showSimpleAlert("Error", message: error?.localizedDescription ?? "")
        }
      }
    }
  }
}

