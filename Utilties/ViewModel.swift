//
//  ViewModel.swift
//  MoyaDemo
//
//  Created by IOS on 15/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import MoyaSugar
import SwiftyJSON
import ObjectMapper

class ViewModel{
    
    let network : MoyaSugarProvider<APIEndpoint>
//    var getVehicleMakeResponse : ((Bool, String, [GetVehicleMakeData]?) -> Void)? = nil
    var registerUserResponse : ((Bool, String) -> Void)? = nil
    
    init(networking: MoyaSugarProvider<APIEndpoint>) {
      self.network = networking
    }
    
    func callRegisterAPI(firstName:String,lastName:String,password:String,sex:String,email:String,profile_pic:UIImage,controller:UIViewController){
        controller.showHudd()
        network.request(.registerUser(firstName: firstName, lastName: lastName, password: password, sex: sex, email: email, profile_pic: profile_pic)) { [weak self] result in
            controller.hideHudd()
            var success = true
            var message = "Unable to fetch from GitHub"
            
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = moyaResponse.statusCode
                let msg = json["message"].stringValue
                message = msg
                print(msg)
                if code == 200{
                    
                }else{
                    success = false
                }
            case let .failure(error):
                guard let description = error.errorDescription else {
                    break
                }
                message = description
                success = false
                
            }
            self?.registerUserResponse?(success,message)
        }
    }
    
//    func callgetVehicleMake(){
//        network.request(.getVehicleMake) { [weak self] result in
//            var success = true
//            var message = "Unable to fetch from GitHub"
//            var arrVehicleMake: [GetVehicleMakeData]? = nil
//            switch result {
//            case let .success(moyaResponse):
//                let data = moyaResponse.data
//                let json = JSON(data)
//                let code = moyaResponse.statusCode
//                let msg = json["message"].stringValue
//                message = msg
//                print(msg)
//                if code == 200{
//                    let respo = try? JSONSerialization.jsonObject(with: data, options: [])
//                    let responseModel = Mapper<GetVehicleMakeBase>().map(JSONObject: respo)
//                    if let data = responseModel?.data{
//                        arrVehicleMake = data
//                    }else{
//                        success = false
//                    }
//                    
//                }
//            case let .failure(error):
//                guard let description = error.errorDescription else {
//                  break
//                }
//                message = description
//                success = false
//                
//            }
//            self?.getVehicleMakeResponse?(success,message,arrVehicleMake)
//        }
//    }
    
    
    
}

