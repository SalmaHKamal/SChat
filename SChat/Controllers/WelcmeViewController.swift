//
//  WelcmeViewController.swift
//  SChat
//
//  Created by Salma Hassan on 3/29/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit
import ProgressHUD

private let segueId = "goToProfile"

class WelcmeViewController: UIViewController {
    
    // MARK: - properties
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        dismissKeyboard()
        guard let email = emailTxtField.text , email != "" ,
            let password = passwordTxtField.text , password != "" else {
                ProgressHUD.showError("Email && Password !!")
                return
        }
        
        ProgressHUD.show("login ...")
        logUserIn(email: email, pass: password)
    }
    @IBAction func RegisterPressed(_ sender: Any) {
        dismissKeyboard()
        guard let email = emailTxtField.text , email != "" ,
            let password = passwordTxtField.text , password != "" ,
            let confirmPass = confirmPasswordTxtField.text , confirmPass != "" ,
        confirmPass == password else {
                ProgressHUD.showError("Email && Password && ConfirmPass!!")
                return
        }
        
        ProgressHUD.show("Register ....")
        registerUser(email: email, pass: password)
    }
    
}

// MARK: - Helper Methods
extension WelcmeViewController {
    func logUserIn(email: String , pass: String){
        FUser.loginUserWith(email: email, password: pass) { (error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }else {
                self.openApp()
            }
        }
    }
    
    func openApp(){
        print("open app")
        ProgressHUD.dismiss()
        dismissKeyboard()
        resetTextFileds()
    }
    
    func registerUser(email: String , pass: String) {
        performSegue(withIdentifier: segueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let vc = segue.destination as? FinishRegisterViewController {
                vc.email = emailTxtField.text
                vc.password = passwordTxtField.text
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(false)
    }
    
    func resetTextFileds() {
        UITextField.reset(textFields: emailTxtField , passwordTxtField , confirmPasswordTxtField)
    }
}
