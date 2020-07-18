//
//  Validations.swift
//  MoyaMvvmDemo
//
//  Created by IOS on 15/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation

enum Valid{
    case success
    case failure(Alerts,String)
}

class Validation: NSObject {

static let shared = Validation()

    func validate(signIn email : String?) -> Valid {
        
        if email?.isEmpty == true{
            return errorMsg(str: .validateEmail)
        }
        
        
        return .success
    }
    
    
    func errorMsg(str : Alerts) -> Valid{
        return .failure(.Error,str.get())
    }
}



enum Alerts : String {
    
    case validateEmail = "Enter Email."
    case Error = "Mirage"
    case ValidateFirstName = "Enter First Name."
    
    
    func get() -> String{
        switch self {
        default:
            return self.rawValue
        }
    }
}

enum Keys : String{
    
//    case googleApiKey = "AIzaSyA3tHSj3MTl1MDjSLg48tSKQ9vP5-5nBTs"
  case googleApiKey = "AIzaSyDLWwio7FrkRq-fqnkcmZDPlEZWnzshjKc"
    case statusCode = "statusCode"
    case message = "message"
    case msgDescription
    case Success
    case title = "Demo"
    case ok = "Ok"
}
