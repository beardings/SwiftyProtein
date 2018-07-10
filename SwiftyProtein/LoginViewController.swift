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
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
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

