//
//  NetworkService.swift
//  MoyaDemo
//
//  Created by IOS on 14/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import MoyaSugar

public let mainBaseURL = "http://codobux.in/Indenn/public/api/"

enum APIEndpoint: SugarTargetType {
    
    case registerUser(firstName:String,lastName:String,password:String,sex:String,email:String,profile_pic:UIImage)
    case getVehicleModelByMakeId(bookingID:String)
    case uploadPhoto(email:String,arrPhoto: [UIImage])
    case deletePhoto(photoId: Int)
    
    var multipartBody: [MultipartFormData]? {
        
        switch self {
        case .uploadPhoto(_ , let arrPhoto):
            var form = [MultipartFormData]()
            for (index,element) in arrPhoto.enumerated() {
                if let data = element.jpegData(compressionQuality: 1.0) {
                    form.append(MultipartFormData(provider: .data(data), name: "image[\(index)]", fileName: "photo\(index).jpg", mimeType:"image/jpeg"))
                }
            }
            return form
        case .registerUser(let fn, let ln, let password, let sex, let email, let image):
            let firstName = MultipartFormData(provider: .data(fn.data(using: .utf8)!), name: AppKey.firstName)
            let lastName = MultipartFormData(provider: .data(ln.data(using: .utf8)!), name: AppKey.lastName)
            let email = MultipartFormData(provider: .data(email.data(using: .utf8)!), name: AppKey.email)
            let password = MultipartFormData(provider: .data(password.data(using: .utf8)!), name: AppKey.password)
            let sex = MultipartFormData(provider: .data(sex.data(using: .utf8)!), name: AppKey.sex)
            
            let imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
            let imgUpload = MultipartFormData(provider: .data(imgData), name: AppKey.profile_picture, fileName: "photo.jpg", mimeType:"image/jpeg")
            
            return [firstName, lastName, email, password, sex, imgUpload]
//            return  [ NameS,priceS] + form
//            let authParams = ["apikey": Marvel.publicKey, "ts": ts, "hash": hash]
//            return .requestParameters(parameters: ["format": "comic",
//                         "formatType": "comic",
//                         "orderBy": "-onsaleDate",
//                         "dateDescriptor": "lastWeek",
//                         "limit": 50] + authParams,
//            encoding: URLEncoding.default)
        default:
            return []
        }
        
    }
    
    var route: Route {
        switch self {
            
        case .getVehicleModelByMakeId:
            return .post("getVehicleModelByMakeId")
        case .uploadPhoto:
            return .post("uploadPhoto")
        case .deletePhoto:
            return .post("deletePhoto")
        case .registerUser:
            return .post("register-user/details")
        }
    }
    
    var baseURL: URL {
        return URL(string: mainBaseURL)!
    }
    
    var parameters: Parameters? {
        
        switch self {

        case .getVehicleModelByMakeId(bookingID: let bookingID):
            return JSONEncoding() => [
                "make_id": bookingID
            ]
        case .uploadPhoto(photo: _):
            return JSONEncoding() => [:]
        case .deletePhoto(photoId: _):
            return JSONEncoding() => [:]
        case .registerUser:
            return JSONEncoding() => [:]
        }
    }
    
    var task: Task {
        switch self {
        case .uploadPhoto:
            return .uploadMultipart(multipartBody!)
        case .registerUser:
            if let pm = self.parameters{
                print("Parameters: \(pm.values)")
            }
            return .uploadMultipart(multipartBody!)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Accept": "application/json"
        ]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}


private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? ""
    } catch {
        if JSONSerialization.isValidJSONObject(data) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
}

let configuration = NetworkLoggerPlugin.Configuration(
    formatter: NetworkLoggerPlugin.Configuration.Formatter(
        requestData: JSONResponseDataFormatter,
        responseData: JSONResponseDataFormatter
    ),
    logOptions: .verbose
)

let APIProvider = MoyaSugarProvider<APIEndpoint>(plugins: [NetworkLoggerPlugin(configuration: configuration)])
