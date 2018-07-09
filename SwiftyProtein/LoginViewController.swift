//
//  ViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 04.07.2018.
//  Copyright © 2018 Nikolas Ponomarov. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    let context = LAContext()
    var error: NSError?
    
    @IBOutlet weak var touchIDBtn: UIButton!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        // for test
//        self.touchIDBtn.isHidden = false
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.touchIDBtn.isHidden = false
        } else {
            self.showAlertController((error?.localizedDescription)!, "Warning")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Custom methods
    
    
    // MARK: - Actions
    
    func showAlertController(_ message: String, _ title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func touchIDBtnPressed(_ sender: Any) {
        
        let reason = "Authenticate with Touch ID"
        
//        // for test
//
//        let controller = ProteinListViewController.init(nibName: nil, bundle: nil)
//        controller.title = "Proteins List"
//
//        self.navigationController?.pushViewController(controller, animated: true)
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, evaluateError) in

            if success {
                DispatchQueue.main.async {

                    let controller = ProteinListViewController.init(nibName: nil, bundle: nil)
                    controller.title = "Proteins List"

                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
            } else {
                self.showAlertController((evaluateError?.localizedDescription)!, "Warning")
            }

        }
    }

}

