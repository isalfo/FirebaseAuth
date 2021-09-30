//
//  HomeViewController.swift
//  FirebaseTest
//
//  Created by Gonzalo Alfonso on 30/09/2021.
//

import UIKit
import FirebaseAuth

enum ProviderType: String {
  case basic = "Basic"
}

class HomeViewController: UIViewController {
  
  @IBOutlet weak var userTxt: UILabel!
  @IBOutlet weak var providerTxt: UILabel!
  
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
  }
  
  @IBAction func logOutClicked(_ sender: Any) {
    switch provider {
    case .basic:
      do {
        try Auth.auth().signOut()
        self.navigationController?.popViewController(animated: true)
      } catch {
        self.showSimpleAlert("Error", message: error.localizedDescription)
      }
    }
  }
}
