//
//  ViewController.swift
//  SwiftyProtein
//
//  Created by Nikolas Ponomarov on 04.07.2018.
//  Copyright © 2018 Nikolas Ponomarov. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {

    let context = LAContext()
    var error: NSError?
    
    @IBOutlet weak var touchIDBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var deleteAccBtn: UIButton!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.touchIDBtn.isHidden = false
        } else {
            self.showAlertController((error?.localizedDescription)!, "Warning")
        }
        
        self.loginTF.delegate = self
        self.passwordTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: Notification.Name("appDidEnterBackground") , object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (!UserDefaults.standard.bool(forKey: "UserIsCreated")) {
            DispatchQueue.main.async {
                self.title = "Register"
                self.loginBtn.setTitle("REGISTER", for: .normal)
                self.loginBtn.tag = 0
                
                self.deleteAccBtn.isHidden = true
            }
        } else {
            DispatchQueue.main.async {
                self.title = "Login"
                self.loginBtn.setTitle("LOGIN", for: .normal)
                self.loginBtn.tag = 1
            }
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Custom methods
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
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
    
    func checkTFIsNotEmpty() -> (Bool) {
        
        if (self.loginTF.text?.count)! < 6 {
            self.showAlertController("The length of your login must be more than 5 characters.", "Warning")
            return false
        }
        
        if (self.passwordTF.text?.count)! < 6 {
            self.showAlertController("The length of your password must be more than 5 characters.", "Warning")
            return false
        }
        
        return true
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc func appDidEnterBackground(notification: Notification) {
        self.loginTF.text = ""
        self.passwordTF.text = ""
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if self.loginBtn.tag == 0 {
            
            if checkTFIsNotEmpty() {
                
                UserDefaults.standard.set(self.loginTF.text, forKey: "login")
                UserDefaults.standard.set(self.passwordTF.text, forKey: "password")
                UserDefaults.standard.set(true, forKey: "UserIsCreated")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.title = "Login"
                    self.loginBtn.setTitle("LOGIN", for: .normal)
                    self.loginBtn.tag = 1
                }
                
                self.deleteAccBtn.isHidden = false
                self.showAlertController("Account successfully registered.", "Congratulations")
            }
            
        } else {
            if self.loginTF.text == UserDefaults.standard.string(forKey: "login") && self.passwordTF.text == UserDefaults.standard.string(forKey: "password") {
                
                DispatchQueue.main.async {
                    
                    let controller = ProteinListViewController.init(nibName: nil, bundle: nil)
                    controller.title = "Proteins List"
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                }
                
            } else {
                 self.showAlertController("Password or login do not match.", "Warning")
            }
        }
    }
    
    func showAlertController(_ message: String, _ title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func touchIDBtnPressed(_ sender: Any) {
        
        let reason = "Authenticate with Touch ID."
        
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
    
    @IBAction func deleteAccPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Caution!", message: "Are you sure you want to delete this account?", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAleatAction) -> Void in
            
            self.loginTF.text = ""
            self.passwordTF.text = ""
            
            UserDefaults.standard.removeObject(forKey: "login")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.set(false, forKey: "UserIsCreated")
            UserDefaults.standard.synchronize()
            
            DispatchQueue.main.async {
                self.title = "Register"
                self.loginBtn.setTitle("REGISTER", for: .normal)
                self.loginBtn.tag = 0
            }
            
            self.deleteAccBtn.isHidden = true
            self.showAlertController("This account has been successfully deleted.", "Congratulations")
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }

}

