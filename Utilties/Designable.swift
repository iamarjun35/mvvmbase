//
//  Designable.swift



import UIKit

/// A simple UIView subclass which renders a configurable drop-shadow. The view itself is
/// transparent and only shows the drop-shadow. The drop-shadow draws the same size as the frame of
/// the view, and can take an optional corner radius into account when calculating the effect.

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 2.0
    @IBInspectable var bottomInset: CGFloat = 2.0
    @IBInspectable var leftInset: CGFloat = 2.0
    @IBInspectable var rightInset: CGFloat = 2.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
}

class NavigationShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 2
        self.layer.shadowRadius = 2.0
    }
    
}

class CircularShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = 32.5
        
        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
    }
    
}

class NewShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.5
    }
    
}

class CornerShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
    
}

class SwitchButtonView: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
//        self.roundCorners(topLeft: 20, topRight: 0, bottomLeft: 20, bottomRight: 0)
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.clipsToBounds = true
    }
    
}

class SwitchButtonView2: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
    }
    
}

class MessagesImageView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
    }
    
}

class NotificationCornerView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
    }
    
}

class FixedShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = 12
        
        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
    }
    
}

class ImageShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = 12
        
        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
    }
    
}

class CustomPlaceholder : UITextField{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.autocapitalizationType = .sentences
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
        }
    }
}

class CollectionShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // corner radius
        self.layer.cornerRadius = 6
        
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2.0
    }
    
}

class EmptyLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.text = "-"
    }
    
}

@IBDesignable
class ShadowView: UIView {
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }
    
    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var leftBorderWidth: CGFloat {
        
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = UIColor(cgColor: layer.borderColor!)
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var rightBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: bounds.width, y: 0.0, width: newValue, height: bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
        }
    }
    @IBInspectable var bottomBorderWidth: CGFloat {
        get {
            return 0.0   // Just to satisfy property
        }
        set {
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            line.tag = 110
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.4, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
            
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}

extension UIBezierPath {
    
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != 0 {
            path.move(to: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }
        
        if topRightRadius != 0 {
            path.addLine(to: CGPoint(x: topRight.x - topRightRadius, y: topRight.y))
            path.addArc(tangent1End: topRight, tangent2End: CGPoint(x: topRight.x, y: topRight.y + topRightRadius), radius: topRightRadius)
        }
        else {
            path.addLine(to: topRight)
        }
        
        if bottomRightRadius != 0 {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius))
            path.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bottomRight.x - bottomRightRadius, y: bottomRight.y), radius: bottomRightRadius)
        }
        else {
            path.addLine(to: bottomRight)
        }
        
        if bottomLeftRadius != 0 {
            path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y))
            path.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius), radius: bottomLeftRadius)
        }
        else {
            path.addLine(to: bottomLeft)
        }
        
        if topLeftRadius != 0 {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius))
            path.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y), radius: topLeftRadius)
        }
        else {
            path.addLine(to: topLeft)
        }
        
        path.closeSubpath()
        cgPath = path
    }
}



@IBDesignable
open class VariableCornerRadiusView: UIView  {
    
    private func applyRadiusMaskFor() {
        let path = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    @IBInspectable
    open var topLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var topRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var bottomLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    open var bottomRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        applyRadiusMaskFor()
    }
}
