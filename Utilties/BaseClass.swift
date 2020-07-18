//
//  BaseClass.swift
//  TrophyCaseApp
//
//  Created by Khushboo on 7/20/17.
//  Copyright © 2017 Khushboo. All rights reserved.
//
import UIKit
import CoreLocation
import Photos
import SafariServices
import AVFoundation
import CoreImage
import MobileCoreServices
import TOCropViewController

class BaseClass: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var isEditedImage : Bool = false
    var completionHandler: ((UIImage,String)->Void)? = nil
    var completionHandlerVideo: ((UIImage,NSURL)->Void)? = nil
    var failureHandler: ((String)->Void)? = nil
    
    
    //Image to base64 String
    func convertImageToString(image: UIImage) -> String {
        if let imageData = image.pngData(){
            return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        }
        return ""
    }
    
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
    
    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    
    func checkCustomFontName(){
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = image.pngData()
        case .jpeg(let compression): imageData = image.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // ////print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func passwordValidationAlphaNumeric(testStr:String) -> Bool {
        
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!#$%&'()*+,-./:;<=>?@^_`{|}~\"])[A-Za-z\\d!#$%&'()*+,-./:;<=>?@^_`{|}~\"]{6,15}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    public func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureAction(){
        self.view.endEditing(true)
    }
    
    func addRightPaddingToTxtfield(_ textField : UITextField){
        textField.rightViewMode = .always
        let imageView = UIImageView(image: UIImage(named: "drop_arrow"))
        imageView.frame = CGRect(x: 0, y: 0, width: (imageView.image?.size.width)! + 20.0, height: (imageView.image?.size.height)!)
        imageView.contentMode = .center
        textField.rightView = imageView
    }

    
    
    
    func shareNote(desc:String,controller:UIViewController){
        let activityViewController = UIActivityViewController(activityItems:[desc],applicationActivities:nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        controller.present(activityViewController,animated: true,completion: nil)
    }
    
    //MARK: Validation Check For Phone Number
    func validatePhonNo(phoneNo: String)-> Bool
    {
        
        var hasChar: Bool
        
        if (phoneNo.count >= 5 && phoneNo.count <= 15 )
        {
            hasChar = true
        }
        else
        {
            hasChar = false
        }
        var hasNumb: Bool
        
        let badCharacters = CharacterSet.decimalDigits.inverted
        if phoneNo.rangeOfCharacter(from: badCharacters) == nil
        {
            
            hasNumb = true
        }
        else {
            
            hasNumb = false
        }
        
        
        if (!hasChar || !hasNumb )
        {
            return false
        }
        else
        {
            return true
        }
        
        
    }
    
    func passwordCheck(testStr:String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        if testStr.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        else
        {
            return false
        }
    }
    
    // for open camera for photos
    func camera ()
    {
        if checkPermissionOfCamera() == false{
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
//            picker.allowsEditing = isEditedImage
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            //  picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            present(picker, animated: true, completion: nil)
        }
    }
    
    // for open camera for videos
    func cameraVideo ()
    {
        if checkPermissionOfCamera() == false{
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            
            let picker = UIImagePickerController()
            picker.allowsEditing = isEditedImage
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = 10.0
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .video
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    // for access of videos
    func videos ()
    {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = isEditedImage
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
    
    
    
    // for access of photos
    func photos ()
    {
        let picker = UIImagePickerController()
//        picker.allowsEditing = isEditedImage
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]
        present(picker, animated: true, completion: nil)
    }
    
    //CheckPermitionIf camera Permition Off
    func checkPermissionOfCamera() -> Bool
    {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            // CommonMethodsClass.showAlertViewOnWindow(titleStr: "Keys.ErrorTitle.rawValue", messageStr: "This app does not have access to your camera", okBtnTitleStr: "OK")
            print("dsjhfgjhds")
            return false
        case .authorized: break
        case .restricted: break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                } else {
                    
                    //  self.dismiss(animated:true, completion: nil)
                    
                }
            }
        }
        return true
    }
    
    //action sheet for take photo
    func openCameraAndPhotos (isEditImage:Bool , getImage:@escaping (UIImage,String) -> (),failure : @escaping (String) -> ()) {
        
        completionHandler=getImage
        failureHandler = failure
        isEditedImage = isEditImage
        let alert = UIAlertController(title: "Please Select", message: "", preferredStyle:UIScreen.main.bounds.size.width <= 450.0 ? UIAlertController.Style.actionSheet : UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.camera()
        }))
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { action in
            self.photos()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.failureHandler!("userCancelled")
        }))
        
        // alert.view.tintColor = UIColor.AppColorGreen
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //action sheet for take video
    func openCameraAndVideos (getVideo:@escaping (UIImage,NSURL) -> (),failure : @escaping (String) -> ()) {
        
        completionHandlerVideo = getVideo
        failureHandler = failure
//        isEditedImage = isEditVideo
        let alert = UIAlertController(title: "Please Select", message: "", preferredStyle:UIScreen.main.bounds.size.width <= 450.0 ? UIAlertController.Style.actionSheet : UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.cameraVideo()
        }))
        alert.addAction(UIAlertAction(title: "Videos", style: .default, handler: { action in
            self.videos()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.failureHandler!("userCancelled")
        }))
        // alert.view.tintColor = UIColor.AppColorGreen
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - didFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /////
        
        
        let mediaType = info[.mediaType] as! NSString
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            
            
            guard let image = self.thumbnailForVideoAtURL(url:info[.mediaURL] as! NSURL)else { return }
            
            
            completionHandlerVideo!(image,info[.mediaURL] as! NSURL)
            
        }
        
        /////
        if(isEditedImage==true){
            if let image = info[.originalImage]{
                let chosenImage = image as! UIImage //2
                let cropViewController = TOCropViewController(croppingStyle: .default, image: chosenImage)
                cropViewController.delegate = self
                cropViewController.aspectRatioPreset = .presetSquare
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.toolbar.resetButtonHidden = false
                cropViewController.toolbar.clampButtonHidden = true
                cropViewController.toolbar.rotateClockwiseButtonHidden = false
                cropViewController.toolbar.rotateCounterclockwiseButtonHidden = false
                cropViewController.customAspectRatio = CGSize.init(width: 1, height: 1)
                DispatchQueue.main.async {
                    self.present(cropViewController, animated: true, completion: nil)
                }
//                completionHandler!(chosenImage,"assert.JPG")
            }
        
        }
        else{
            if let image = info[.originalImage]{
                let chosenImage = image as! UIImage //2
                completionHandler!(chosenImage,"assert.JPG")
            }
        }
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    func timeSince(from: Date, numericDates: Bool) -> String {
        
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates == true {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates == true {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates == true {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates == true {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates == true {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) min ago"
        } else if components.minute! >= 1 {
            if numericDates == true {
                result = "1 min ago"
            } else {
                result = "A min ago"
            }
        } else if components.second! >= 3 {
            //            result = "\(components.second!) sec ago"
            result = "Just now"
        } else {
            result = "Just now"
        }
        
        return result
    }
    
    func openSFSafariViewURL(url:String) {
        if let url = URL(string: url){
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }else{
            
        }
        
    }

    
}

extension BaseClass : TOCropViewControllerDelegate{
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        completionHandler!(image,"assert.JPG")
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

class SafeAreaFixTabBar: UITabBar {
    
    var oldSafeAreaInsets = UIEdgeInsets.zero
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        if oldSafeAreaInsets != safeAreaInsets {
            oldSafeAreaInsets = safeAreaInsets
            
            invalidateIntrinsicContentSize()
            superview?.setNeedsLayout()
            superview?.layoutSubviews()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90) {
                size.height += bottomInset
            }
        }
        return size
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var tmp = newValue
            if let superview = superview, tmp.maxY !=
                superview.frame.height {
                tmp.origin.y = superview.frame.height - tmp.height
            }
            
            super.frame = tmp
        }
    }
    
}

extension BaseClass : SFSafariViewControllerDelegate{
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

final class SwipeNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
}

// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
