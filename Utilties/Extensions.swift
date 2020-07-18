//
//  Extensions.swift
//  Amazon
//
//  Created by AJ on 15/09/17.
//  Copyright © 2017 AJ. All rights reserved.
//

import Foundation
import UIKit
//import SDWebImage
import AlamofireImage
import NVActivityIndicatorView
import CoreLocation

//extension UILabel{
//    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = text
//        label.sizeToFit()
//        return label.frame.height
//    }
//}

extension UIButton {
    /// 0 => .ScaleToFill
    /// 1 => .ScaleAspectFit
    /// 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIView.ContentMode(rawValue: newValue),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }
}

extension UICollectionViewCell{
    func addShadowToView(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.0
    }
}

extension UITableViewCell{
    func addShadowToView(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.0
    }
}

extension UIViewController{
    func addShadowToView(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.0
    }
}

extension UIImageView{
    
    func setAlamofireImageWithAnimation(imageString : String?,animation:UIImageView.ImageTransition,placeholderImage:UIImage){
        if let urlStr = imageString{
            if let url = URL(string: urlStr){
                self.af_setImage(
                    withURL: url,
                    placeholderImage: placeholderImage,
                    imageTransition: animation
                )
            }
        }
    }
    
    func setAlamofireImageWithRadiusandAnimation(with imageString:String?,radius:CGFloat,animation:UIImageView.ImageTransition){
        let placeholderImage = UIImage(named: "place_holder")
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.frame.size,
            radius: radius
        )
        if let urlStr = imageString{
            if let url = URL(string: urlStr){
                self.af_setImage(
                    withURL: url,
                    placeholderImage: placeholderImage,
                    filter: filter,
                    imageTransition: animation
                )
            }
        }
    }
    
    func setAlamofireImage(string : String?, placeholderImage : UIImage){
        if let urlStr = string{
            if let url = URL(string: urlStr){
                self.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
    }
    
}

extension UIView {
    func blur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func unBlur() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}

extension UIButton{
    
    func setAlamofireImage(string : String?){
        if let urlStr = string{
            if let url = URL(string: urlStr){
                self.af_setImage(for: .normal, url: url)
            }
        }
    }

}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIScrollView {
    func scrollToBottom1(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}

extension UIApplication {
    class func topViewController() -> UIViewController? {
        var topVC = shared.keyWindow!.rootViewController
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let nav = topVC as? UINavigationController {
                topVC = nav.visibleViewController
            } else if let tab = topVC as? UITabBarController {
                topVC = tab.selectedViewController
            }else {
                break
            }
        }
        return topVC
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    func darker() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    func lighter() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        
        return UIColor()
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension UIViewController {
    
    func hideNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tabBarHidden(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tabBarShow(){
        self.tabBarController?.tabBar.isHidden = false
    }
    func alertView(controller:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showHudd(){
        //        SVProgressHUD.show()
        //        SVProgressHUD.setDefaultMaskType(.clear)
        //        let size = CGSize(width: 50, height: 50)
        //        let bgColor = UIColor.black.withAlphaComponent(0.35)
        //        let activityData = ActivityData(size: size, message: "", messageFont: nil, messageSpacing: nil, type: .ballScaleRippleMultiple, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: bgColor, textColor: nil)
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        let size = CGSize(width: 50, height: 50)
        let bgColor = UIColor.black.withAlphaComponent(0.5)
        let activityData = ActivityData(size: size, message: "", messageFont: nil, messageSpacing: nil, type: .orbit, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: bgColor, textColor: .white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    func hideHudd(){
        //        SVProgressHUD.dismiss()
        //        SVProgressHUD.setDefaultMaskType(.none)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }
    
    func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func dimiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTableView(_ tblViw : UITableView, estimatedHeight : CGFloat){
        tblViw.estimatedRowHeight = estimatedHeight
        tblViw.rowHeight = UITableView.automaticDimension
    }
    
//    func showAlertAndPopVC(message: String){
//
//        let alert = UIAlertController(title: KAlertTitle, message: message, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: KOk, style: .default, handler: { (action) in
//            self.popVC()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showAlertAndDismissVC(message: String){
//
//        let alert = UIAlertController(title: KAlertTitle, message: message, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: KOk, style: .default, handler: { (action) in
//            self.dismiss(animated: true, completion: nil)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showErrorAlert(message: String){
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showSuccessAlert(message: String){
//        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showUnderDevAlert(){
//        let alert = UIAlertController(title: KAlertTitle, message: "Under Development", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func changeDateFormatString(fromString:String, fromFormat:String, toFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        guard let newDate = dateFormatter.date(from: fromString) else { return "" }
        dateFormatter.dateFormat = toFormat
        let strDate = dateFormatter.string(from: newDate)
        return strDate
    }
    
    func hideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func showAlertWithAction(alertTitle:String, message: String, action1Title:String, completion: ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action1Title, style: .cancel, handler: completion))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTwoActions(alertTitle:String, message: String, action1Title:String, action1Style: UIAlertAction.Style ,action2Title: String ,completion1: ((UIAlertAction) -> Void)? = nil,completion2 :((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action1Title, style: action1Style, handler: completion1))
        alert.addAction(UIAlertAction(title: action2Title, style: .default, handler: completion2))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithKeyboard(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler))
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollToTop(animated: Bool) {
        if let tv = self as? UITableViewController {
            tv.tableView.setContentOffset(CGPoint.zero, animated: animated)
        } else if let cv = self as? UICollectionViewController{
            cv.collectionView?.setContentOffset(CGPoint.zero, animated: animated)
        } else {
            for v in view.subviews {
                if let sv = v as? UIScrollView {
                    sv.setContentOffset(CGPoint.zero, animated: animated)
                }
            }
        }
    }
    
    func getNewDateFormat(fromFormat:String,fromString:String,toFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = fromFormat
        guard let dateString = dateFormatter.date(from: fromString) else { return "" }
        dateFormatter.dateFormat = toFormat
        let newDate = dateFormatter.string(from: dateString)
        return newDate
    }
    
    func timestampToDate(fromFormat:String,unixtimeInterval:String,toFormat:String) -> String{
        let date = Date(timeIntervalSince1970: unixtimeInterval.toDouble() ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = toFormat //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
//    func sendTokenMultipart() -> [String:String]{
//        var header : [String:String] = [:]
//        if UserDetails.shared.isLogin(){
//            header = ["Authorization":"Bearer \(UserDetails.shared.token)","Content-Type":"application/json"]
//        }
//        return header
//    }
    
    func getAttributedString(boldText:String,italicText:String) -> NSMutableAttributedString{
        
        let attributsBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]
        let attributsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        var attributedString = NSMutableAttributedString(string: italicText, attributes:attributsNormal)
        let boldStringPart = NSMutableAttributedString(string: boldText, attributes:attributsBold)
        attributedString.append(boldStringPart)
        
        return attributedString
    }
    
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    
    func checkDistance(userCoords:CLLocationCoordinate2D,planCoords:CLLocationCoordinate2D) -> String{
        let currentLocation = CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude)
        let destinationLocation = CLLocation(latitude: planCoords.latitude, longitude: planCoords.longitude)
        let distance = currentLocation.distance(from: destinationLocation) / 1000
        let formattedDistance = (String(format: "%.01f km distance", distance))
        return formattedDistance
    }
    
    
}

extension UIView {
    
    /// Load view from nib. Note: Nib name must be equal to the class name.
    ///
    /// - parameter view:    The name of the nib file, which need not include the .nib extension
    /// - parameter owner:   The object to assign as the nib’s File's Owner object
    /// - parameter options: options
    ///
    /// - returns: view
    class func loadFromNibAndClass<T : UIView>(_ view: T.Type, owner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T? {
        
        let name = String(describing: view.self)
        
        guard let nib = Bundle.main.loadNibNamed(name, owner: owner, options: options) else { return nil }
        
        return nib.first as? T
    }
    
    class func loadFromNib(named name: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Date {
    static var currentTimeStamp: Int{
        return Int(Date().timeIntervalSince1970)
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension Double {
    /// Convert `Double` to `Decimal`, rounding it to `scale` decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places to round to. Defaults to `0`.
    ///   - mode:  The preferred rounding mode. Defaults to `.plain`.
    /// - Returns: The rounded `Decimal` value.
    
    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var decimalValue = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, scale, mode)
        return result
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }
    
    func toURL() -> URL?{
        return URL(string: self)
    }
}


extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Date {
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds"
        } else {
            return "a moment"
        }
    }
    
    func getShortElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + "y" :
                "\(year)" + "y"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + "m" :
                "\(month)" + "m"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + "d" :
                "\(day)" + "d"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + "h" :
                "\(hour)" + "h"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + "m" :
                "\(minute)" + "m"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + "s" :
                "\(second)" + "s"
        } else {
            return "a moment ago"
        }
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day,.minute]
        self.maximumUnitCount = 4
        self.unitsStyle = .short
        return self.string(from: fromDate, to: toDate)
    }
}

extension UIView {
    func toImage(frame:CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        drawHierarchy(in:frame , afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func bordered(lineWidth: CGFloat, strokeColor: UIColor = UIColor.white){
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func rounded(insets: UIEdgeInsets = .zero){
        let path = UIBezierPath.init(roundedRect: self.bounds.inset(by: insets), cornerRadius: self.frame.width/2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func withRadius(insets: UIEdgeInsets = .zero, radius:CGFloat){
        let path = UIBezierPath.init(roundedRect: self.bounds.inset(by: insets), cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView {
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }

}

extension UIScrollView {
    func screenshot() -> UIImage? {
        // begin image context
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        // save the orginal offset & frame
        let savedContentOffset = contentOffset
        let savedFrame = frame
        // end ctx, restore offset & frame before returning
        defer {
            UIGraphicsEndImageContext()
            contentOffset = savedContentOffset
            frame = savedFrame
        }
        // change the offset & frame so as to include all content
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}



/// Slice image into array of tiles
///
/// - Parameters:
///   - image: The original image.
///   - howMany: How many rows/columns to slice the image up into.
///
/// - Returns: An array of images.
///
/// - Note: The order of the images that are returned will correspond
///         to the `imageOrientation` of the image. If the image's
///         `imageOrientation` is not `.up`, take care interpreting
///         the order in which the tiled images are returned.




extension String {
    
    func validateURL() -> Bool {
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: self)
        return result
    }
    
    
    public func isCompletelyEmpty() -> Bool{
        if self.trimSpace().length() != 0{
            return false
        }else{
            return true
        }
    }
    
    public func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public func isValidEmail() -> Bool {
        let stricterFilterString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: self)
    }
    
//    public func isValidPassword() -> Bool {
//        let passwordRegex = "^{6,}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
//    }
    
    func isValidPassword() -> Bool {
        //        ^                         Start anchor
        //        (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
        //        (?=.*[!@#$&*])            Ensure string has one special case letter.
        //        (?=.*[0-9].*[0-9])        Ensure string has two digits.
        //        (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
        //        .{8}                      Ensure string is of length 8.
        //        $                         End anchor.
//        let passwordFormat = "^(?=.*[A-Z])(?=.*[.!@#$&*])(?=.*[0-9]).{8,20}$"
        let passwordFormat = "^(?=.*[A-Z])(?=.*[0-9]).{8,20}$"
        //(example: Mukesh123.)
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    public func validatePhoneNumber() -> String {
        var phoneNumber = self.replacingOccurrences(of: "-", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
        return phoneNumber
    }
    
    public func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func length() -> Int {
        return self.count
    }
    
    func heightForWithFont(_ width: CGFloat, _ insets: UIEdgeInsets) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width + insets.left + insets.right, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helventica", size: 15.0)
        label.text = self
        
        label.sizeToFit()
        return label.frame.height + insets.top + insets.bottom
    }
    
    func utf8String(_ plusForSpace: Bool=false) -> String {
        var encoded = ""
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        if let encode = addingPercentEncoding(withAllowedCharacters:allowed as CharacterSet) {
            if plusForSpace {
                encoded = encode.replacingOccurrences(of: " ", with: "+")
            }
        }
        return encoded
    }
    
    func appendBaseURL()->String{
        return self
    }
}

extension UIImage {
    
    func cropped() -> UIImage? {
        let cropRect = CGRect(x: 0, y: 0, width: 44 * scale, height: 44 * scale)
        
        guard let croppedCGImage = cgImage?.cropping(to: cropRect) else { return nil }
        
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

    }
    
}

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension Date {
     func changeDaysBy(days : Int) -> Date {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)!
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var startOfDayExt: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    static func generateDatesArrayBetweenTwoDates(startDate: Date, endDate: Date) -> [Date] {
        var datesArray: [Date] = [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        while startDate <= endDate {
            let tempDate = self.dateFormatter().string(from: startDate)
            datesArray.append(self.dateFormatter().date(from: tempDate) ?? Date())
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return datesArray
    }
    
    //CHANGE FORMAT LATER
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    
}

extension UIViewController {
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    private func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
    }
}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
extension UITextField {
    func addLeftViewWithImage(image: UIImage?) {
        if let leftImg = image {
            let imgView = UIImageView.init(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
            imgView.image = leftImg
            imgView.contentMode = .scaleAspectFit
            self.leftViewMode = .always
            self.leftView = imgView
            
        }
    }
    
    func addRightViewWithImage(image: UIImage?) {
        if let rightImg = image {
            let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
            imgView.image = rightImg
            imgView.contentMode = .scaleAspectFit
            self.rightViewMode = .always
            self.rightView = imgView
        }
    }
    
}

extension String {
    func convertToInternationalFormat() -> String {
        let isMoreThanTenDigit = self.count > 10
        _ = self.startIndex
        var newstr = ""
        if isMoreThanTenDigit {
            newstr = "\(self.dropFirst(self.count - 10))"
        }
        else if self.count == 10{
            newstr = "\(self)"
        }
        else {
            return "number has only \(self.count) digits"
        }
        if  newstr.count == 10 {
            let internationalString = "\(newstr.dropLast(7))-\(newstr.dropLast(4).dropFirst(3))-\(newstr.dropFirst(6))"
            newstr = internationalString
        }
        return newstr
    }
}
class UILabelPadded: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 2, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}
extension UITableView{
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(_ animated: Bool = false) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
}

class Header: UICollectionViewCell  {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let dateLabel: UILabel = {
        let title = UILabel()
        title.text = "Today"
        title.textColor = .gray
        title.backgroundColor = .black
        title.font = UIFont(name: "Montserrat", size: 17)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setupHeaderViews()   {
        addSubview(dateLabel)
        
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//extension UIImageView {
//    
//    func setImageFor(with imageURL: URL?) {
//        
//        let completionBlock: SDExternalCompletionBlock = { (tempImage, error, cacheType, imageURL) in
//            if let downLoadedImage = tempImage {
//                if cacheType == .none {
//                    self.alpha = 0
//                    UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: { () -> Void in
//                        self.image = downLoadedImage
//                        self.alpha = 1
//                    }, completion: nil)
//                }
//            }
//        }
//        
//        self.cancelImageRequest()
//        let placeholderImage = UIImage(named: "place_holder")
//        self.sd_setImage(with: imageURL, placeholderImage: placeholderImage, progress: nil, completed: completionBlock)
//        
//    }
//    
//    
//    func cancelImageRequest() {
//        self.sd_cancelCurrentImageLoad()
//    }
//    
//    //    func imageFromMemory(for url: URL) -> UIImage? {
//    //        let manager = SDWebImageManager.shared
//    //        let key: String = manager.cacheKey(for: url)!
//    //        return manager.imageCache.
//    //    }
//    
//    class Cache{
//        
//        
//        
//        class func clearAllCache() {
//            SDWebImageManager.shared.imageCache.clear(with: .all, completion: nil)
//        }
//    }
//    
//    func mirrorImage(orientation: UIImage.Orientation) {
//        if let cgImage = self.image?.cgImage, let scale = self.image?.scale {
//            let image: UIImage = UIImage.init(cgImage: cgImage, scale: scale, orientation: orientation)
//            self.image = image
//        }
//    }
//    
//    class func download(from url: URL, completionHandler: ((UIImage?) -> Void)? = nil) {
//        
//        URLSession.shared.dataTask(with: url) { (data, response, _) in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data,
//                let image = UIImage(data: data)
//                else {
//                    completionHandler?(nil)
//                    return
//            }
//            
//            DispatchQueue.main.async {
//                completionHandler?(image)
//            }
//            }.resume()
//    }
//    
//}

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}

extension UISwitch {
    
    func set(offTint color: UIColor ) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}

extension UITextField{
    public var isNull: Bool    {
        if let t = self.text {
            return t.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
        }
        return false
    }
}

extension String {
    func characterAtIndex(_ index: Int) -> Character {
        return self[exist:self.index(self.startIndex, offsetBy: index)] ?? Character("")
    }
}

extension Date{
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension Date {
    
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        //        return self*0.62137
        return self*800
    }
    
    func inKilometers() -> CLLocationDistance {
        //        return self/1000
        return self*1000
    }
}

extension String {
    func replace(_ with: String, at index: Int) -> String {
        var modifiedString = String()
        for (i, char) in self.enumerated() {
            modifiedString += String((i == index) ? with : String(char))
        }
        return modifiedString
    }
}

public extension UIColor {
    
    
    static let newBar = UIColor(hex: 0x4B0082)
    
    static let bar = UIColor(hex: 0x4E221A)
    
    static let logoStart = UIColor(hex: 0x7B44FA)
    static let logoEnd = UIColor(hex: 0xED0A97)
    
    static let facebook = UIColor(hex: 0x3b5998)
    static let google = UIColor(hex: 0xEA4335)
    
    static let tabSelectedColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let tabBackColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension String {

    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]

        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }

        return false
    }
    
    public func isVideo() -> Bool {
        // Add here your image formats.
        let videoFormats = ["mp4", "mov", "wmv", "heic"]

        if let ext = self.getExtension() {
            return videoFormats.contains(ext)
        }

        return false
    }

    public func getExtension() -> String? {
       let ext = (self as NSString).pathExtension

       if ext.isEmpty {
           return nil
       }

       return ext
    }

    public func isURL() -> Bool {
       return URL(string: self) != nil
    }

}

