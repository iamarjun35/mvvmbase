//
//  UserDetails.swift


import UIKit
import SwiftyJSON

class UserDetails: NSObject {

    static var shared = UserDetails()
    
    var name: String = ""
    var id: String = ""
    var token: String = ""
    var profile_pic: String = ""
    var first_user_login: String = ""
    var isSeenHome = "0"
    var isSeenCreatePlan = "0"
    var isSeenProfile = "0"
    var is_updated = "0"
    
    init(json: JSON) {
        super.init()
        self.name = json["first_name"].stringValue
        self.id = json["user_id"].stringValue
        self.token = json["user_token"].stringValue
        self.profile_pic = json["profile_img"].stringValue
        self.first_user_login = json["is_first_login"].stringValue
        self.is_updated = json["is_updated"].stringValue
        
        if self.first_user_login == "1"{
            self.isSeenHome = "1"
            self.isSeenCreatePlan = "1"
            self.isSeenProfile = "1"
        }
    }
    
    override init() {
        super.init()
        
        self.load()
    }
    
    func save() {
        UserDefaults.standard.set(self.name, forKey: "userName")
        UserDefaults.standard.set(self.id, forKey: "userId")
        UserDefaults.standard.set(self.token, forKey: "planUserToken")
        UserDefaults.standard.set(self.profile_pic, forKey: "profile_pic")
//        UserDefaults.standard.set(self.first_user_login, forKey: "first_user_login")
    }
    
    func load() {
        self.name = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.id = UserDefaults.standard.string(forKey: "userId") ?? ""
        self.token = UserDefaults.standard.string(forKey: "planUserToken") ?? ""
        self.profile_pic = UserDefaults.standard.string(forKey: "profile_pic") ?? ""
 //       self.first_user_login = UserDefaults.standard.string(forKey: "first_user_login") ?? ""
    }
    
    func isLogin() -> Bool {
//        if token.trimSpace().length() == 0 || is_updated == "0"{
//            return false
//        }
        if token.trimSpace().length() == 0{
            return false
        }
        return true
    }
    
    func logout() {
        UIApplication.shared.unregisterForRemoteNotifications()
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }

        token = ""
        self.load()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        let navVC = UINavigationController(rootViewController: loginVC)
//        navVC.isNavigationBarHidden = true
//        KAppDelegate.window?.rootViewController = navVC
    }
    
}
