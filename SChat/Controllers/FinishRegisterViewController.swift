//
//  FinishRegisterViewController.swift
//  SChat
//
//  Created by Salma Hassan on 3/29/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit
import ProgressHUD

class FinishRegisterViewController: UIViewController {

    @IBOutlet weak var phoneTextFiled: UITextField!
    @IBOutlet weak var cityTextFiled: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var email: String!
    var password: String!
    var avatarImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(email , password)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissKeyboard()
        resetTextFileds()
        dismiss(animated: true, completion: nil)
    }
    fileprivate func register(_ firstName: String ,_ lastName: String ,_ country: String ,_ city: String ,_ phone: String) {
        FUser.registerUserWith(email: email, password: password , firstName:  firstName , lastName: lastName) { (error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }else {
                let dictionary = [kFIRSTNAME : firstName ,
                                  kLASTNAME : lastName ,
                                  kFULLNAME: firstName + lastName,
                                  kCOUNTRY: country,
                                  kCITY:city,
                                  kPHONE:phone]
                self.finishRegisteration(with: dictionary)
            }
        }
    }
    
    func finishRegisteration(with dictionary: [String:Any]){
        var dic = dictionary
        guard let avatar = avatarImageView else {
            
            imageFromInitials(firstName: dictionary[kFIRSTNAME] as? String, lastName: dictionary[kLASTNAME] as? String) { (image) in
                
                let imageData = image.jpegData(compressionQuality: 0.7)
                let imageDataString = imageData?.base64EncodedData(options: Data.Base64EncodingOptions.init(rawValue: 0))
                dic[kAVATAR] = imageDataString
                self.saveToFirestore(dictionary: dic)
            }
            
            return }
        
        let imageData = avatar.image?.jpegData(compressionQuality: 0.7)
        let imageDataString = imageData?.base64EncodedData(options: Data.Base64EncodingOptions.init(rawValue: 0))
        dic[kAVATAR] = imageDataString
        self.saveToFirestore(dictionary: dic)
        
    }
    
    func saveToFirestore(dictionary : [String: Any]){
        updateCurrentUserInFirestore(withValues: dictionary) { (error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }else {
                self.openApp()
            }
        }
    }
    
    func openApp(){
        let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: StoryboardControllersIds.homeViewId)
        present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        resetTextFileds()
        
        guard let firstName = nameTextFiled.text , !firstName.isEmpty ,
            let lastName = surnameTextField.text , !lastName.isEmpty ,
            let country = countryTextField.text , !country.isEmpty ,
            let city = cityTextFiled.text , !city.isEmpty,
            let phone = phoneTextFiled.text , !phone.isEmpty else {
            
                ProgressHUD.showError("All Fields are required ")
                return
        }
        
        ProgressHUD.show("Registering ...")
        register(firstName,lastName,country, city,phone)
    }
    
    // MARK: - Helper Methods
    func dismissKeyboard() {
        view.endEditing(false)
    }
    
    func resetTextFileds() {
        UITextField.reset(textFields: nameTextFiled , surnameTextField , countryTextField , cityTextFiled , phoneTextFiled)
    }
}


