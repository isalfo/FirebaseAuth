//
//  AuthViewController.swift
//  FirebaseTest
//
//  Created by Gonzalo Alfonso on 30/09/2021.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKLoginKit

// MARK: AuthVC class
class AuthViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passTxt: UITextField!
  @IBOutlet weak var googleBtn: UIButton!
  @IBOutlet weak var registerBtn: UIButton!
  @IBOutlet weak var logInBtn: UIButton!
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Authentication"
    googleBtn.imageEdgeInsets.left = -90
    
    let FacebookLoginButton = FBLoginButton()
    view.addSubview(FacebookLoginButton)
    FacebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
    FacebookLoginButton.topAnchor.constraint(equalTo: googleBtn.bottomAnchor, constant: 16).isActive = true
    FacebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    FacebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    FacebookLoginButton.permissions = ["public_profile", "email"]
    
    // Analytics Event
    Analytics.logEvent("InitScreen", parameters: ["message":"Firebase Integration Complete"])
    
    // Check for authenticated user
    let defaults = UserDefaults.standard
    if let email = defaults.value(forKey: "email") as? String,
       let provider = defaults.value(forKey: "provider") as? String {
      navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType(rawValue: provider)!), animated: false)
    }
    if let token = AccessToken.current, !token.isExpired {
      navigationController?.popToViewController(HomeViewController(email: "", provider: .facebook), animated: true)
    }
    
  }
  
  // MARK: - IBAction methods
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
  
  
  @IBAction func googleClicked(_ sender: Any) {
    
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

      if let error = error {
        self.showSimpleAlert("Error", message: error.localizedDescription)
        return
      }

      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else {
        return
      }

      let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                     accessToken: authentication.accessToken)

      Auth.auth().signIn(with: credential) { authResult, error in
          if let error = error {
            self.showSimpleAlert("Error", message: error.localizedDescription)
          }
        self.navigationController?.pushViewController(HomeViewController(email: authResult!.user.email!, provider: .google), animated: true)
      }
    }
  }
}

