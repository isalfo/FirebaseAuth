//
//  HomeViewController.swift
//  FirebaseTest
//
//  Created by Gonzalo Alfonso on 30/09/2021.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCrashlytics

enum ProviderType: String {
  case basic = "Basic"
  case google = "Google"
  case facebook = "Facebook"
}

class HomeViewController: UIViewController {
  
  @IBOutlet weak var userTxt: UILabel!
  @IBOutlet weak var providerTxt: UILabel!
  @IBOutlet weak var errorBtn: UIButton!
  
  @IBOutlet weak var logOutBtn: UIButton!
  
  private let email: String
  private let provider: ProviderType
  
  init(email: String, provider: ProviderType) {
    self.email = email
    self.provider = provider
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    userTxt.text = email
    providerTxt.text = provider.rawValue
    navigationItem.setHidesBackButton(true, animated: true)
    
    //Save user data
    let defaults = UserDefaults.standard
    defaults.set(email, forKey: "email")
    defaults.set(provider.rawValue, forKey: "provider")
    defaults.synchronize()
  }
  
  private func fireBaseLogOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      self.showSimpleAlert("Error", message: error.localizedDescription)
    }
  }
  
  @IBAction func errorBtnClicked(_ sender: Any) {
    // Send User ID
    Crashlytics.crashlytics().setUserID(email)
    
    // Send custom key
    Crashlytics.crashlytics().setValue(provider, forKey: "PROVIDER")
    
    // Send Error Log
    Crashlytics.crashlytics().log("Error button pressed")
    
    fatalError()
  }
  @IBAction func logOutClicked(_ sender: Any) {
    
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "email")
    defaults.removeObject(forKey: "provider")
    defaults.synchronize()
    
    switch provider {
    case .basic:
      fireBaseLogOut()
    case .google:
      GIDSignIn.sharedInstance.signOut()
      fireBaseLogOut()
    case .facebook:
      fireBaseLogOut()
    }
    self.navigationController?.popViewController(animated: true)
  }
}
