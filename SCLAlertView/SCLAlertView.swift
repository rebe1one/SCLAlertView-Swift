//
//  SCLAlertView.swift
//  SCLAlertView Example
//
//  Created by Viktor Radchenko on 6/5/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import Foundation
import UIKit

// Pop Up Styles
public enum SCLAlertViewStyle {
    case Success, Error, Notice, Warning, Info, Edit, Wait
    
    var defaultColorInt: UInt {
        switch self {
        case Success:
            return 0x22B573
        case Error:
            return 0xC1272D
        case Notice:
            return 0x727375
        case Warning:
            return 0xFFD110
        case Info:
            return 0x2866BF
        case Edit:
            return 0xA429FF
        case Wait:
            return 0xD62DA5
        }
        
    }

}

// Animation Styles
public enum SCLAnimationStyle {
    case NoAnimation, TopToBottom, BottomToTop, LeftToRight, RightToLeft
}

// Action Types
public enum SCLActionType {
    case None, Selector, Closure
}

// Button sub-class
public class SCLButton: UIButton {
    var actionType = SCLActionType.None
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    var customBackgroundColor:UIColor?
    var customTextColor:UIColor?
    var initialTitle:String!
    var showDurationStatus:Bool=false
    
    public init() {
        super.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
public class SCLAlertViewResponder {
    let alertview: SCLAlertView
    
    // Initialisation and Title/Subtitle/Close functions
    public init(alertview: SCLAlertView) {
        self.alertview = alertview
    }
    
    public func setTitle(title: String) {
        self.alertview.labelTitle.text = title
    }
    
    public func setSubTitle(subTitle: String) {
        self.alertview.viewText.text = subTitle
    }
    
    public func close() {
        self.alertview.hideView()
    }
    
    public func setDismissBlock(dismissBlock: DismissBlock) {
        self.alertview.dismissBlock = dismissBlock
    }
}

public typealias DismissBlock = () -> Void

public struct SCLAppearance {
    public var shadowOpacity: CGFloat = 0.7
    public var circleTopPosition: CGFloat = -12.0
    public var circleBackgroundTopPosition: CGFloat = -15.0
    public var circleHeightBackground: CGFloat = 100.0
    public var circleHeight: CGFloat = 70.0
    public var circleIconHeight: CGFloat = 60.0
    public var titleTop: CGFloat = 50.0
    public var textHeight: CGFloat = 90.0
    public var textFieldHeight: CGFloat = 45.0
    public var textViewHeight: CGFloat = 80.0
    public var buttonHeight: CGFloat = 45.0
    public var contentViewColor: UIColor = UIColor.whiteColor()
    public var contentViewBorderColor: UIColor = UIColor.clearColor()
    public var titleColor: UIColor = UIColorFromRGB(0x4D4D4D)
    public var titleBottomMargin: CGFloat = 14.0
    public var buttonSeparatorColor: UIColor = UIColor.whiteColor()
    
    // Icon Options
    public var circleIconImage: UIImage?
    public var circleIconBackgroundColor: UIColor?
    
    // Fonts
    public var titleFont: UIFont = UIFont.systemFontOfSize(20)
    public var textFont: UIFont = UIFont.systemFontOfSize(14)
    public var buttonFont: UIFont = UIFont.boldSystemFontOfSize(14)
    
    // Attributes
    public var titleAttributes: [String: AnyObject]?
    public var textAttributes: [String: AnyObject]?
    
    // Alignment
    public var titleAlignment: NSTextAlignment = .Center
    public var textAlignment: NSTextAlignment = .Center
    
    // Spacing
    public var padding: CGFloat = 25.0
    public var margin: CGFloat = 40.0
    
    // UI Options
    public var showCircularIcon: Bool = true
    public var shouldAutoDismiss: Bool = true // Set this false to 'Disable' Auto hideView when SCLButton is tapped
    public var contentViewCornerRadius : CGFloat = 5.0
    public var fieldCornerRadius : CGFloat = 3.0
    public var buttonCornerRadius : CGFloat = 3.0
    public var showDropShadow : Bool = true
    
    // Actions
    public var hideWhenBackgroundViewIsTapped: Bool = false
    
    public init() {
        
    }
    
    static var success: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Success.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfCheckmark
            return appearance
        }
    }
    
    static var notice: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Notice.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfNotice
            return appearance
        }
    }
    
    static var warning: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Warning.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfWarning
            return appearance
        }
    }
    
    static var error: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Error.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfCross
            return appearance
        }
    }
    
    static var info: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Info.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfInfo
            return appearance
        }
    }
    
    static var edit: SCLAppearance {
        get {
            var appearance = SCLAppearance()
            appearance.circleIconBackgroundColor = UIColorFromRGB(SCLAlertViewStyle.Edit.defaultColorInt)
            appearance.circleIconImage = SCLAlertViewStyleKit.imageOfEdit
            return appearance
        }
    }
    
}

// The Main Class
public class SCLAlertView: UIViewController {
    
    var appearance: SCLAppearance!
    
    // UI Colour
    var viewColor = UIColor()
    
    // UI Options
    public var iconTintColor: UIColor?
    public var customSubview : UIView?
    

    
    // Members declaration
    var baseView = UIView()
    var labelTitle = UILabel()
    var viewText = UITextView()
    var contentView = UIView()
    var shadowView = UIView()
    var circleBG = UIView()
    var circleView = UIView()
    var circleIconView : UIView?
    var duration: NSTimeInterval!
    var durationStatusTimer: NSTimer!
    var durationTimer: NSTimer!
    var dismissBlock : DismissBlock?
    private var inputs = [UITextField]()
    private var input = [UITextView]()
    public var buttons = [SCLButton]()
    internal var buttonSeparators = [UIView]()
    private var selfReference: SCLAlertView?
    
    public var subtitle: String?
    
    public init(appearance: SCLAppearance? = nil, title: String? = nil, subtitle: String? = nil) {
        self.appearance = appearance ?? SCLAppearance()
        super.init(nibName:nil, bundle:nil)
        self.title = title
        self.subtitle = subtitle
        setup()
    }
    
    public init(style: SCLAlertViewStyle = .Success, title: String? = nil, subtitle: String? = nil) {
        switch style {
        case .Success:
            self.appearance = SCLAppearance.success
        case .Error:
            self.appearance = SCLAppearance.error
        case .Edit:
            self.appearance = SCLAppearance.edit
        case .Info:
            self.appearance = SCLAppearance.info
        case .Notice:
            self.appearance = SCLAppearance.notice
        case .Wait:
            self.appearance = SCLAppearance.success
        case .Warning:
            self.appearance = SCLAppearance.warning
        }
        super.init(nibName:nil, bundle:nil)
        self.title = title
        self.subtitle = subtitle
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    required public init() {
        appearance = SCLAppearance()
        super.init(nibName:nil, bundle:nil)
        setup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        appearance = SCLAppearance()
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    private var alertWidth: CGFloat {
        get {
            let screenWidth = UIScreen.mainScreen().bounds.width
            return screenWidth - (appearance.margin * 2)
        }
    }
    
    private func setTitleText() {
        if let title = title where !title.isEmpty {
            if let attributes = appearance.titleAttributes {
                self.labelTitle.attributedText = NSAttributedString(string: title, attributes: attributes)
            } else {
                self.labelTitle.text = title
            }
        }
    }
    
    private func setup() {
        // Set up main view
        view.frame = UIScreen.mainScreen().bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:appearance.shadowOpacity)
        view.addSubview(baseView)
        // Base View
        baseView.frame = view.frame
        if appearance.showDropShadow {
            shadowView.backgroundColor = UIColor.clearColor()
            baseView.addSubview(shadowView)
        }
        baseView.addSubview(contentView)
        // Content View
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(labelTitle)
        contentView.addSubview(viewText)
        // Circle View
        circleBG.frame = CGRect(x:0, y:0, width:appearance.circleHeightBackground, height:appearance.circleHeightBackground)
        circleBG.backgroundColor = UIColor.whiteColor()
        circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
        baseView.addSubview(circleBG)
        circleBG.addSubview(circleView)
        let x = (appearance.circleHeightBackground - appearance.circleHeight) / 2
        circleView.frame = CGRect(x:x, y:x, width:appearance.circleHeight, height:appearance.circleHeight)
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
        // Title
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = appearance.titleAlignment
        labelTitle.font = appearance.titleFont
        setTitleText()
        labelTitle.frame = CGRect(x: 0, y: 0, width: alertWidth - (appearance.padding * 2), height: CGFloat.max)
        labelTitle.sizeToFit()
        labelTitle.frame = CGRect(x: appearance.padding, y: appearance.titleTop, width: alertWidth - (appearance.padding * 2), height: labelTitle.frame.height)
        // View text
        viewText.editable = false
        viewText.textAlignment = appearance.textAlignment
        viewText.textContainerInset = UIEdgeInsetsZero
        viewText.textContainer.lineFragmentPadding = 0;
        viewText.font = appearance.textFont
        // Colours
        contentView.backgroundColor = appearance.contentViewColor
        viewText.backgroundColor = appearance.contentViewColor
        labelTitle.textColor = appearance.titleColor
        viewText.textColor = appearance.titleColor
        contentView.layer.borderColor = appearance.contentViewBorderColor.CGColor
        //Gesture Recognizer for tapping outside the textinput
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SCLAlertView.tapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        let sz = rv.frame.size
        
        // Set background frame
        view.frame.size = sz
        
        let totalHorizontalPadding = appearance.padding * 2
        
        // computing the right size to use for the textView
        let maxHeight = sz.height - 100 // max overall height
        var consumedHeight = CGFloat(0)
        consumedHeight += appearance.titleTop + labelTitle.frame.height + appearance.titleBottomMargin
        // space separating buttons from the content above + below
        consumedHeight += appearance.padding
        if buttons.count == 2 {
            consumedHeight += appearance.buttonHeight
        } else {
            consumedHeight += appearance.buttonHeight * CGFloat(buttons.count)
        }
        // total height of text fields
        consumedHeight += appearance.textFieldHeight * CGFloat(inputs.count)
        // height of text view
        consumedHeight += appearance.textViewHeight * CGFloat(input.count)
        let maxViewTextHeight = maxHeight - consumedHeight
        let viewTextWidth = alertWidth - totalHorizontalPadding
        var viewTextHeight = appearance.textHeight
        
        // Check if there is a custom subview and add it over the textview
        if let customSubview = customSubview {
            viewTextHeight = min(customSubview.frame.height, maxViewTextHeight)
            viewText.text = ""
            viewText.addSubview(customSubview)
        } else {
            // computing the right size to use for the textView
            let suggestedViewTextSize = viewText.sizeThatFits(CGSizeMake(viewTextWidth, CGFloat.max))
            viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)
            
            // scroll management
            if (suggestedViewTextSize.height > maxViewTextHeight) {
                viewText.scrollEnabled = true
            } else {
                viewText.scrollEnabled = false
            }
        }
        let titleOffset : CGFloat = appearance.showCircularIcon ? 0.0 : -12.0
        let windowHeight = consumedHeight + viewTextHeight + titleOffset
        // Set frames
        var x = (sz.width - alertWidth) / 2
        var y = (sz.height - windowHeight - (appearance.circleHeight / 8)) / 2 
        contentView.frame = CGRect(x:x, y:y, width:alertWidth, height:windowHeight)
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        if appearance.showDropShadow {
            shadowView.frame = contentView.frame
            shadowView.layer.cornerRadius = appearance.contentViewCornerRadius
        }
        y -= appearance.circleHeightBackground * 0.6
        x = (sz.width - appearance.circleHeightBackground) / 2
        circleBG.frame = CGRect(x:x, y:y+6, width:appearance.circleHeightBackground, height:appearance.circleHeightBackground)
        
        //adjust Title frame based on circularIcon show/hide flag
        labelTitle.frame = labelTitle.frame.offsetBy(dx: 0, dy: titleOffset)
        
        // Subtitle
        y = appearance.titleTop + labelTitle.frame.height + titleOffset + appearance.titleBottomMargin
        viewText.frame = CGRect(x: appearance.padding, y: y, width: alertWidth - totalHorizontalPadding, height: appearance.textHeight)
        viewText.frame = CGRect(x: appearance.padding, y: y, width: viewTextWidth, height: viewTextHeight)
        // Text fields
        y += viewTextHeight + appearance.padding
        for txt in inputs {
            txt.frame = CGRect(x: appearance.padding, y: y, width: alertWidth - totalHorizontalPadding, height: 30)
            txt.layer.cornerRadius = appearance.fieldCornerRadius
            y += appearance.textFieldHeight
        }
        for txt in input {
            txt.frame = CGRect(x: appearance.padding, y: y, width: alertWidth - totalHorizontalPadding, height: 70)
            //txt.layer.cornerRadius = fieldCornerRadius
            y += appearance.textViewHeight
        }
        // Buttons
        if buttons.count == 2 {
            let btn1 = buttons.first
            let btn2 = buttons.last
            
            let sep1 = buttonSeparators.first
            let sep2 = buttonSeparators.last
            
            let buttonWidth = alertWidth / 2
            
            sep1?.frame = CGRect(x: 0, y: y, width: alertWidth, height: 0.5)
            sep2?.frame = CGRect(x: buttonWidth, y: y, width: 0.5, height: appearance.buttonHeight)
            if let sep1 = sep1, sep2 = sep2 {
                contentView.bringSubviewToFront(sep1)
                contentView.bringSubviewToFront(sep2)
            }
            
            btn1?.frame = CGRect(x: 0, y: y, width: buttonWidth, height: appearance.buttonHeight)
            btn2?.frame = CGRect(x: buttonWidth, y: y, width: buttonWidth, height: appearance.buttonHeight)
            
            y += appearance.buttonHeight
        } else {
            for (index, btn) in buttons.enumerate() {
                let sep = buttonSeparators[index]
                sep.frame = CGRect(x: 0, y: y, width: alertWidth, height: 0.5)
                btn.frame = CGRect(x: 0, y: y, width: alertWidth, height: appearance.buttonHeight)
                y += appearance.buttonHeight
            }
        }
        
        if appearance.showDropShadow {
            let shadowPath = UIBezierPath(rect: shadowView.bounds)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowColor = UIColor.blackColor().CGColor
            shadowView.layer.shadowOffset = CGSizeMake(0.0, 20.0)
            shadowView.layer.shadowOpacity = 0.5
            shadowView.layer.shadowRadius = 20
            shadowView.layer.shadowPath = shadowPath.CGPath
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SCLAlertView.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SCLAlertView.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    override public func touchesEnded(touches:Set<UITouch>, withEvent event:UIEvent?) {
        if event?.touchesForView(view)?.count > 0 {
            view.endEditing(true)
        }
    }
    
    public func addTextField(title:String?=nil)->UITextField {
        // Add text field
        let txt = UITextField()
        txt.borderStyle = UITextBorderStyle.RoundedRect
        txt.font = appearance.textFont
        txt.autocapitalizationType = UITextAutocapitalizationType.Words
        txt.clearButtonMode = UITextFieldViewMode.WhileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        if title != nil {
            txt.placeholder = title!
        }
        contentView.addSubview(txt)
        inputs.append(txt)
        return txt
    }
    
    public func addTextView()->UITextView {
        // Add text view
        let txt = UITextView()
        // No placeholder with UITextView but you can use KMPlaceholderTextView library 
        txt.font = appearance.textFont
        //txt.autocapitalizationType = UITextAutocapitalizationType.Words
        //txt.clearButtonMode = UITextFieldViewMode.WhileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        contentView.addSubview(txt)
        input.append(txt)
        return txt
    }
    
    public func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool=false, action:()->Void)->SCLButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = SCLActionType.Closure
        btn.action = action
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapped(_:)), forControlEvents:.TouchUpInside)
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapDown(_:)), forControlEvents:[.TouchDown, .TouchDragEnter])
        btn.addTarget(self, action:#selector(SCLAlertView.buttonRelease(_:)), forControlEvents:[.TouchUpInside, .TouchUpOutside, .TouchCancel, .TouchDragOutside] )
        return btn
    }
    
    public func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool = false, target:AnyObject, selector:Selector)->SCLButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = SCLActionType.Selector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapped(_:)), forControlEvents:.TouchUpInside)
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapDown(_:)), forControlEvents:[.TouchDown, .TouchDragEnter])
        btn.addTarget(self, action:#selector(SCLAlertView.buttonRelease(_:)), forControlEvents:[.TouchUpInside, .TouchUpOutside, .TouchCancel, .TouchDragOutside] )
        return btn
    }
    
    private func addButton(title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool=false)->SCLButton {
        // Add button
        let btn = SCLButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.font = appearance.buttonFont
        btn.customBackgroundColor = backgroundColor
        btn.customTextColor = textColor
        btn.initialTitle = title
        btn.showDurationStatus = showDurationStatus
        contentView.addSubview(btn)
        buttons.append(btn)
        
        // add a button separator
        let sep = UIView()
        sep.backgroundColor = appearance.buttonSeparatorColor
        contentView.addSubview(sep)
        buttonSeparators.append(sep)
        
        return btn
    }
    
    func buttonTapped(btn:SCLButton) {
        if btn.actionType == SCLActionType.Closure {
            btn.action()
        } else if btn.actionType == SCLActionType.Selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to:btn.target, forEvent:nil)
        } else {
            print("Unknow action type for button")
        }
        
        if(self.view.alpha != 0.0 && appearance.shouldAutoDismiss){ hideView() }
    }
    
    
    func buttonTapDown(btn:SCLButton) {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        let pressBrightnessFactor = 0.85
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness * CGFloat(pressBrightnessFactor)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func buttonRelease(btn:SCLButton) {
        btn.backgroundColor = btn.customBackgroundColor ?? viewColor
    }
    
    var tmpContentViewFrameOrigin: CGPoint?
    var tmpCircleViewFrameOrigin: CGPoint?
    var keyboardHasBeenShown:Bool = false
    
    func keyboardWillShow(notification: NSNotification) {
        keyboardHasBeenShown = true
        
        guard let userInfo = notification.userInfo else {return}
        guard let endKeyBoardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.minY else {return}
        
        if tmpContentViewFrameOrigin == nil {
        tmpContentViewFrameOrigin = self.contentView.frame.origin
        }
        
        if tmpCircleViewFrameOrigin == nil {
        tmpCircleViewFrameOrigin = self.circleBG.frame.origin
        }
        
        var newContentViewFrameY = self.contentView.frame.maxY - endKeyBoardFrame
        if newContentViewFrameY < 0 {
            newContentViewFrameY = 0
        }
        let newBallViewFrameY = self.circleBG.frame.origin.y - newContentViewFrameY
        self.contentView.frame.origin.y -= newContentViewFrameY
        self.circleBG.frame.origin.y = newBallViewFrameY
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(keyboardHasBeenShown){//This could happen on the simulator (keyboard will be hidden)
            if(self.tmpContentViewFrameOrigin != nil){
                self.contentView.frame.origin.y = self.tmpContentViewFrameOrigin!.y
                self.tmpContentViewFrameOrigin = nil
            }
            if(self.tmpCircleViewFrameOrigin != nil){
                self.circleBG.frame.origin.y = self.tmpCircleViewFrameOrigin!.y
                self.tmpCircleViewFrameOrigin = nil
            }
            
            keyboardHasBeenShown = false
        }
    }
    
    //Dismiss keyboard when tapped outside textfield & close SCLAlertView when hideWhenBackgroundViewIsTapped
    func tapped(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if let tappedView = gestureRecognizer.view where tappedView.hitTest(gestureRecognizer.locationInView(tappedView), withEvent: nil) == baseView && appearance.hideWhenBackgroundViewIsTapped {
            
            hideView()
        }
    }
    
    // showTitle(view, title, subTitle, duration, style)
    public func present(duration duration: NSTimeInterval? = nil, animationStyle: SCLAnimationStyle = .TopToBottom) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        let iconImage = appearance.circleIconImage ?? SCLAlertViewStyleKit.imageOfCheckmark
        viewColor = appearance.circleIconBackgroundColor ?? UIColorFromRGB(0x22B573)
        
        // Title
        setTitleText()
        
        // Subtitle
        if let subtitle = subtitle where !subtitle.isEmpty {
            let attributes = appearance.textAttributes ?? [NSFontAttributeName:viewText.font ?? UIFont()]
            viewText.attributedText = NSAttributedString(string: subtitle, attributes: attributes)
            // Adjust text view size, if necessary
            let str = subtitle as NSString
            let sz = CGSize(width: alertWidth, height: 90)
            let r = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attributes, context:nil)
            let ht = ceil(r.size.height)
            if ht < appearance.textHeight {
                appearance.textHeight = ht
            }
        }
        
        //hidden/show circular view based on the ui option
        circleView.hidden = !appearance.showCircularIcon
        circleBG.hidden = !appearance.showCircularIcon
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if let iconTintColor = iconTintColor {
            circleIconView = UIImageView(image: iconImage.imageWithRenderingMode(.AlwaysTemplate))
            circleIconView?.tintColor = iconTintColor
        }
        else {
            circleIconView = UIImageView(image: iconImage)
        }
        circleView.addSubview(circleIconView!)
        let x = (appearance.circleHeight - appearance.circleIconHeight) / 2
        circleIconView!.frame = CGRectMake( x, x, appearance.circleIconHeight, appearance.circleIconHeight)
        circleIconView?.layer.cornerRadius = circleIconView!.bounds.height / 2
        circleIconView?.layer.masksToBounds = true
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.CGColor
        }
        
        for txt in input {
            txt.layer.borderColor = viewColor.CGColor
        }
        
        for btn in buttons {
            if let customBackgroundColor = btn.customBackgroundColor {
                // Custom BackgroundColor set
                btn.backgroundColor = customBackgroundColor
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.backgroundColor = viewColor
            }
            
            if let customTextColor = btn.customTextColor {
                // Custom TextColor set
                btn.setTitleColor(customTextColor, forState:UIControlState.Normal)
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
            }
        }
        
        // Adding duration
        if duration > 0 {
            self.duration = duration
            durationTimer?.invalidate()
            durationTimer = NSTimer.scheduledTimerWithTimeInterval(self.duration, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
            durationStatusTimer?.invalidate()
            durationStatusTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SCLAlertView.updateDurationStatus), userInfo: nil, repeats: true)
        }
        
        // Animate in the alert view
        self.showAnimation(animationStyle)
       
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    // Show animation in the alert view
    private func showAnimation(animationStyle: SCLAnimationStyle = .TopToBottom, animationStartOffset: CGFloat = -400.0, boundingAnimationOffset: CGFloat = 15.0, animationDuration: NSTimeInterval = 0.2) {
        
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        var animationStartOrigin = self.baseView.frame.origin
        var animationCenter : CGPoint = rv.center
        
        switch animationStyle {

        case .NoAnimation:
            self.view.alpha = 1.0
            return;
            
        case .TopToBottom:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y + animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y + boundingAnimationOffset)
            
        case .BottomToTop:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y - animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - boundingAnimationOffset)
            
        case .LeftToRight:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x + animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x + boundingAnimationOffset, y: animationCenter.y)
            
        case .RightToLeft:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x - animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x - boundingAnimationOffset, y: animationCenter.y)
        }

        self.baseView.frame.origin = animationStartOrigin
        UIView.animateWithDuration(animationDuration, animations: {
            self.view.alpha = 1.0
            self.baseView.center = animationCenter
            }, completion: { finished in
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.alpha = 1.0
                    self.baseView.center = rv.center
                })
        })
    }
    
    public func updateDurationStatus() {
        duration = duration.advancedBy(-1)
        for btn in buttons.filter({$0.showDurationStatus}) {
            let txt = "\(btn.initialTitle) (\(duration))"
            btn.setTitle(txt, forState: .Normal)
        }
    }
    
    // Close SCLAlertView
    public func hideView() {
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 0
            }, completion: { finished in
                
                //Stop durationTimer so alertView does not attempt to hide itself and fire it's dimiss block a second time when close button is tapped
                self.durationTimer?.invalidate()
                // Stop StatusTimer
                self.durationStatusTimer?.invalidate()
                
                if(self.dismissBlock != nil) {
                    // Call completion handler when the alert is dismissed
                    self.dismissBlock!()
                }
                
                // This is necessary for SCLAlertView to be de-initialized, preventing a strong reference cycle with the viewcontroller calling SCLAlertView.
                for button in self.buttons {
                    button.action = nil
                    button.target = nil
                    button.selector = nil
                }
                
                self.view.removeFromSuperview()
                self.selfReference = nil
        })
    }
    
    func checkCircleIconImage(circleIconImage: UIImage?, defaultImage: UIImage) -> UIImage {
        if let image = circleIconImage {
            return image
        } else {
            return defaultImage
        }
    }
}

// Helper function to convert from RGB to UIColor
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// ------------------------------------
// Icon drawing
// Code generated by PaintCode
// ------------------------------------

public class SCLAlertViewStyleKit : NSObject {
    
    // Cache
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var checkmartargets: [AnyObject]?
        static var imageOfCross: UIImage?
        static var crossTargets: [AnyObject]?
        static var imageOfNotice: UIImage?
        static var noticeTargets: [AnyObject]?
        static var imageOfWarning: UIImage?
        static var warningTargets: [AnyObject]?
        static var imageOfInfo: UIImage?
        static var infoTargets: [AnyObject]?
        static var imageOfEdit: UIImage?
        static var editTargets: [AnyObject]?
    }
    
    // Initialization
    /// swift 1.2 abolish func load
    //    override class func load() {
    //    }
    
    // Drawing Methods
    class func drawCheckmark() {
        // Checkmark Shape Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 63.08, y: 17))
        bezierPath.addLineToPoint(CGPoint(x: 70, y: 23.9))
        bezierPath.addLineToPoint(CGPoint(x: 30.77, y: 63))
        bezierPath.addLineToPoint(CGPoint(x: 10, y: 42.3))
        bezierPath.addLineToPoint(CGPoint(x: 16.92, y: 35.4))
        bezierPath.addLineToPoint(CGPoint(x: 30.77, y: 49.2))
        bezierPath.addLineToPoint(CGPoint(x: 63.08, y: 17))
        bezierPath.closePath()
        
        UIColor.whiteColor().setFill()
        bezierPath.fill()
    }
    
    class func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()
        crossShapePath.moveToPoint(CGPointMake(10, 70))
        crossShapePath.addLineToPoint(CGPointMake(70, 10))
        crossShapePath.moveToPoint(CGPointMake(10, 10))
        crossShapePath.addLineToPoint(CGPointMake(70, 70))
        crossShapePath.lineCapStyle = CGLineCap.Round;
        crossShapePath.lineJoinStyle = CGLineJoin.Round;
        UIColor.whiteColor().setStroke()
        crossShapePath.lineWidth = 14
        crossShapePath.stroke()
    }
    
    class func drawNotice() {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()
        noticeShapePath.moveToPoint(CGPointMake(72, 48.54))
        noticeShapePath.addLineToPoint(CGPointMake(72, 39.9))
        noticeShapePath.addCurveToPoint(CGPointMake(66.38, 34.01), controlPoint1: CGPointMake(72, 36.76), controlPoint2: CGPointMake(69.48, 34.01))
        noticeShapePath.addCurveToPoint(CGPointMake(61.53, 35.97), controlPoint1: CGPointMake(64.82, 34.01), controlPoint2: CGPointMake(62.69, 34.8))
        noticeShapePath.addCurveToPoint(CGPointMake(60.36, 35.78), controlPoint1: CGPointMake(61.33, 35.97), controlPoint2: CGPointMake(62.3, 35.78))
        noticeShapePath.addLineToPoint(CGPointMake(60.36, 33.22))
        noticeShapePath.addCurveToPoint(CGPointMake(54.16, 26.16), controlPoint1: CGPointMake(60.36, 29.3), controlPoint2: CGPointMake(57.65, 26.16))
        noticeShapePath.addCurveToPoint(CGPointMake(48.73, 29.89), controlPoint1: CGPointMake(51.64, 26.16), controlPoint2: CGPointMake(50.67, 27.73))
        noticeShapePath.addLineToPoint(CGPointMake(48.73, 28.71))
        noticeShapePath.addCurveToPoint(CGPointMake(43.49, 21.64), controlPoint1: CGPointMake(48.73, 24.78), controlPoint2: CGPointMake(46.98, 21.64))
        noticeShapePath.addCurveToPoint(CGPointMake(39.03, 25.37), controlPoint1: CGPointMake(40.97, 21.64), controlPoint2: CGPointMake(39.03, 23.01))
        noticeShapePath.addLineToPoint(CGPointMake(39.03, 9.07))
        noticeShapePath.addCurveToPoint(CGPointMake(32.24, 2), controlPoint1: CGPointMake(39.03, 5.14), controlPoint2: CGPointMake(35.73, 2))
        noticeShapePath.addCurveToPoint(CGPointMake(25.45, 9.07), controlPoint1: CGPointMake(28.56, 2), controlPoint2: CGPointMake(25.45, 5.14))
        noticeShapePath.addLineToPoint(CGPointMake(25.45, 41.47))
        noticeShapePath.addCurveToPoint(CGPointMake(24.29, 43.44), controlPoint1: CGPointMake(25.45, 42.45), controlPoint2: CGPointMake(24.68, 43.04))
        noticeShapePath.addCurveToPoint(CGPointMake(9.55, 43.04), controlPoint1: CGPointMake(16.73, 40.88), controlPoint2: CGPointMake(11.88, 40.69))
        noticeShapePath.addCurveToPoint(CGPointMake(8, 46.58), controlPoint1: CGPointMake(8.58, 43.83), controlPoint2: CGPointMake(8, 45.2))
        noticeShapePath.addCurveToPoint(CGPointMake(14.4, 55.81), controlPoint1: CGPointMake(8.19, 50.31), controlPoint2: CGPointMake(12.07, 53.84))
        noticeShapePath.addLineToPoint(CGPointMake(27.2, 69.56))
        noticeShapePath.addCurveToPoint(CGPointMake(42.91, 77.8), controlPoint1: CGPointMake(30.5, 74.47), controlPoint2: CGPointMake(35.73, 77.21))
        noticeShapePath.addCurveToPoint(CGPointMake(43.88, 77.8), controlPoint1: CGPointMake(43.3, 77.8), controlPoint2: CGPointMake(43.68, 77.8))
        noticeShapePath.addCurveToPoint(CGPointMake(47.18, 78), controlPoint1: CGPointMake(45.04, 77.8), controlPoint2: CGPointMake(46.01, 78))
        noticeShapePath.addLineToPoint(CGPointMake(48.34, 78))
        noticeShapePath.addLineToPoint(CGPointMake(48.34, 78))
        noticeShapePath.addCurveToPoint(CGPointMake(71.61, 52.08), controlPoint1: CGPointMake(56.48, 78), controlPoint2: CGPointMake(69.87, 75.05))
        noticeShapePath.addCurveToPoint(CGPointMake(72, 48.54), controlPoint1: CGPointMake(71.81, 51.29), controlPoint2: CGPointMake(72, 49.72))
        noticeShapePath.closePath()
        noticeShapePath.miterLimit = 4;
        
        UIColor.whiteColor().setFill()
        noticeShapePath.fill()
    }
    
    class func drawWarning() {
        // Color Declarations
        let greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.000)
        
        // Warning Group
        // Warning Circle Drawing
        let warningCirclePath = UIBezierPath()
        warningCirclePath.moveToPoint(CGPointMake(40.94, 63.39))
        warningCirclePath.addCurveToPoint(CGPointMake(36.03, 65.55), controlPoint1: CGPointMake(39.06, 63.39), controlPoint2: CGPointMake(37.36, 64.18))
        warningCirclePath.addCurveToPoint(CGPointMake(34.14, 70.45), controlPoint1: CGPointMake(34.9, 66.92), controlPoint2: CGPointMake(34.14, 68.49))
        warningCirclePath.addCurveToPoint(CGPointMake(36.22, 75.54), controlPoint1: CGPointMake(34.14, 72.41), controlPoint2: CGPointMake(34.9, 74.17))
        warningCirclePath.addCurveToPoint(CGPointMake(40.94, 77.5), controlPoint1: CGPointMake(37.54, 76.91), controlPoint2: CGPointMake(39.06, 77.5))
        warningCirclePath.addCurveToPoint(CGPointMake(45.86, 75.35), controlPoint1: CGPointMake(42.83, 77.5), controlPoint2: CGPointMake(44.53, 76.72))
        warningCirclePath.addCurveToPoint(CGPointMake(47.93, 70.45), controlPoint1: CGPointMake(47.18, 74.17), controlPoint2: CGPointMake(47.93, 72.41))
        warningCirclePath.addCurveToPoint(CGPointMake(45.86, 65.35), controlPoint1: CGPointMake(47.93, 68.49), controlPoint2: CGPointMake(47.18, 66.72))
        warningCirclePath.addCurveToPoint(CGPointMake(40.94, 63.39), controlPoint1: CGPointMake(44.53, 64.18), controlPoint2: CGPointMake(42.83, 63.39))
        warningCirclePath.closePath()
        warningCirclePath.miterLimit = 4;
        
        greyColor.setFill()
        warningCirclePath.fill()
        
        
        // Warning Shape Drawing
        let warningShapePath = UIBezierPath()
        warningShapePath.moveToPoint(CGPointMake(46.23, 4.26))
        warningShapePath.addCurveToPoint(CGPointMake(40.94, 2.5), controlPoint1: CGPointMake(44.91, 3.09), controlPoint2: CGPointMake(43.02, 2.5))
        warningShapePath.addCurveToPoint(CGPointMake(34.71, 4.26), controlPoint1: CGPointMake(38.68, 2.5), controlPoint2: CGPointMake(36.03, 3.09))
        warningShapePath.addCurveToPoint(CGPointMake(31.5, 8.77), controlPoint1: CGPointMake(33.01, 5.44), controlPoint2: CGPointMake(31.5, 7.01))
        warningShapePath.addLineToPoint(CGPointMake(31.5, 19.36))
        warningShapePath.addLineToPoint(CGPointMake(34.71, 54.44))
        warningShapePath.addCurveToPoint(CGPointMake(40.38, 58.16), controlPoint1: CGPointMake(34.9, 56.2), controlPoint2: CGPointMake(36.41, 58.16))
        warningShapePath.addCurveToPoint(CGPointMake(45.67, 54.44), controlPoint1: CGPointMake(44.34, 58.16), controlPoint2: CGPointMake(45.67, 56.01))
        warningShapePath.addLineToPoint(CGPointMake(48.5, 19.36))
        warningShapePath.addLineToPoint(CGPointMake(48.5, 8.77))
        warningShapePath.addCurveToPoint(CGPointMake(46.23, 4.26), controlPoint1: CGPointMake(48.5, 7.01), controlPoint2: CGPointMake(47.74, 5.44))
        warningShapePath.closePath()
        warningShapePath.miterLimit = 4;
        
        greyColor.setFill()
        warningShapePath.fill()
    }
    
    class func drawInfo() {
        // Color Declarations
        let color0 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        // Info Shape Drawing
        let infoShapePath = UIBezierPath()
        infoShapePath.moveToPoint(CGPointMake(45.66, 15.96))
        infoShapePath.addCurveToPoint(CGPointMake(45.66, 5.22), controlPoint1: CGPointMake(48.78, 12.99), controlPoint2: CGPointMake(48.78, 8.19))
        infoShapePath.addCurveToPoint(CGPointMake(34.34, 5.22), controlPoint1: CGPointMake(42.53, 2.26), controlPoint2: CGPointMake(37.47, 2.26))
        infoShapePath.addCurveToPoint(CGPointMake(34.34, 15.96), controlPoint1: CGPointMake(31.22, 8.19), controlPoint2: CGPointMake(31.22, 12.99))
        infoShapePath.addCurveToPoint(CGPointMake(45.66, 15.96), controlPoint1: CGPointMake(37.47, 18.92), controlPoint2: CGPointMake(42.53, 18.92))
        infoShapePath.closePath()
        infoShapePath.moveToPoint(CGPointMake(48, 69.41))
        infoShapePath.addCurveToPoint(CGPointMake(40, 77), controlPoint1: CGPointMake(48, 73.58), controlPoint2: CGPointMake(44.4, 77))
        infoShapePath.addLineToPoint(CGPointMake(40, 77))
        infoShapePath.addCurveToPoint(CGPointMake(32, 69.41), controlPoint1: CGPointMake(35.6, 77), controlPoint2: CGPointMake(32, 73.58))
        infoShapePath.addLineToPoint(CGPointMake(32, 35.26))
        infoShapePath.addCurveToPoint(CGPointMake(40, 27.67), controlPoint1: CGPointMake(32, 31.08), controlPoint2: CGPointMake(35.6, 27.67))
        infoShapePath.addLineToPoint(CGPointMake(40, 27.67))
        infoShapePath.addCurveToPoint(CGPointMake(48, 35.26), controlPoint1: CGPointMake(44.4, 27.67), controlPoint2: CGPointMake(48, 31.08))
        infoShapePath.addLineToPoint(CGPointMake(48, 69.41))
        infoShapePath.closePath()
        color0.setFill()
        infoShapePath.fill()
    }
    
    class func drawEdit() {
        // Color Declarations
        let color = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        
        // Edit shape Drawing
        let editPathPath = UIBezierPath()
        editPathPath.moveToPoint(CGPointMake(71, 2.7))
        editPathPath.addCurveToPoint(CGPointMake(71.9, 15.2), controlPoint1: CGPointMake(74.7, 5.9), controlPoint2: CGPointMake(75.1, 11.6))
        editPathPath.addLineToPoint(CGPointMake(64.5, 23.7))
        editPathPath.addLineToPoint(CGPointMake(49.9, 11.1))
        editPathPath.addLineToPoint(CGPointMake(57.3, 2.6))
        editPathPath.addCurveToPoint(CGPointMake(69.7, 1.7), controlPoint1: CGPointMake(60.4, -1.1), controlPoint2: CGPointMake(66.1, -1.5))
        editPathPath.addLineToPoint(CGPointMake(71, 2.7))
        editPathPath.addLineToPoint(CGPointMake(71, 2.7))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPointMake(47.8, 13.5))
        editPathPath.addLineToPoint(CGPointMake(13.4, 53.1))
        editPathPath.addLineToPoint(CGPointMake(15.7, 55.1))
        editPathPath.addLineToPoint(CGPointMake(50.1, 15.5))
        editPathPath.addLineToPoint(CGPointMake(47.8, 13.5))
        editPathPath.addLineToPoint(CGPointMake(47.8, 13.5))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPointMake(17.7, 56.7))
        editPathPath.addLineToPoint(CGPointMake(23.8, 62.2))
        editPathPath.addLineToPoint(CGPointMake(58.2, 22.6))
        editPathPath.addLineToPoint(CGPointMake(52, 17.1))
        editPathPath.addLineToPoint(CGPointMake(17.7, 56.7))
        editPathPath.addLineToPoint(CGPointMake(17.7, 56.7))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPointMake(25.8, 63.8))
        editPathPath.addLineToPoint(CGPointMake(60.1, 24.2))
        editPathPath.addLineToPoint(CGPointMake(62.3, 26.1))
        editPathPath.addLineToPoint(CGPointMake(28.1, 65.7))
        editPathPath.addLineToPoint(CGPointMake(25.8, 63.8))
        editPathPath.addLineToPoint(CGPointMake(25.8, 63.8))
        editPathPath.closePath()
        editPathPath.moveToPoint(CGPointMake(25.9, 68.1))
        editPathPath.addLineToPoint(CGPointMake(4.2, 79.5))
        editPathPath.addLineToPoint(CGPointMake(11.3, 55.5))
        editPathPath.addLineToPoint(CGPointMake(25.9, 68.1))
        editPathPath.closePath()
        editPathPath.miterLimit = 4;
        editPathPath.usesEvenOddFillRule = true;
        color.setFill()
        editPathPath.fill()
    }
    
    // Generated Images
    public class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawCheckmark()
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    public class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawCross()
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    public class var imageOfNotice: UIImage {
        if (Cache.imageOfNotice != nil) {
            return Cache.imageOfNotice!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawNotice()
        Cache.imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfNotice!
    }
    
    public class var imageOfWarning: UIImage {
        if (Cache.imageOfWarning != nil) {
            return Cache.imageOfWarning!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawWarning()
        Cache.imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfWarning!
    }
    
    public class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawInfo()
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
    
    public class var imageOfEdit: UIImage {
        if (Cache.imageOfEdit != nil) {
            return Cache.imageOfEdit!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
        SCLAlertViewStyleKit.drawEdit()
        Cache.imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfEdit!
    }
}
