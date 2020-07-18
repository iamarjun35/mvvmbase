//
//  ViewController.swift
//  MoyaMvvmDemo
//
//  Created by IOS on 15/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class ViewController: BaseClass {
    
    @IBOutlet weak var btnImg: UIButton!
    @IBOutlet weak var txtFn: UITextField!
    @IBOutlet weak var txtLn: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    let viewModel = ViewModel(networking: APIProvider)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func callAPI(){
        
        viewModel.registerUserResponse = { success, message in
            
            if success{
                self.alertView(controller: self, title: Keys.title.rawValue, msg: message)
            }else{
                print(message)
            }
            
        }
        
        viewModel.callRegisterAPI(firstName: txtFn.text!, lastName: txtLn.text!, password: txtPass.text!, sex: "Male", email: txtEmail.text!, profile_pic: btnImg.currentImage ?? UIImage(), controller: self)
    }
    
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(signIn: txtEmail.text!)
        return value
    }
    
    @IBAction func changeImage(_ sender: Any) {
        openCameraAndPhotos(isEditImage: true, getImage: { (image, str) in
            
            self.btnImg.setImage(image, for: .normal)
            
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let value = Validate()
        switch value {
        case .success:
            
            self.callAPI()
            
        case .failure(_, let msg):
            
            self.alertView(controller: self, title: Keys.title.rawValue, msg: msg)
        }
    }
    

}

