//
//  ViewController.swift
//  SCLAlertViewExample
//
//  Created by Viktor Radchenko on 6/6/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import UIKit
import SCLAlertView


let kSuccessTitle = "Congratulations"
let kErrorTitle = "Connection error"
let kNoticeTitle = "Notice"
let kWarningTitle = "Warning"
let kInfoTitle = "Info"
let kSubtitle = "You've just displayed this awesome Pop Up View"

let kDefaultAnimationDuration = 2.0

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSuccess(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.success, title: kSuccessTitle, subtitle: kSubtitle)
		alert.addButton("First Button", target:self, selector:#selector(ViewController.firstButton))
		alert.addButton("Second Button") {
			print("Second button tapped")
		}
        alert.present()
    }
    
    @IBAction func showError(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.error, title: "Hold On...", subtitle: "You have not saved your Submission yet. Please save the Submission before accessing the Responses list. Blah de blah de blah, blah. Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.")
        alert.addButton("Done") {
            print("Done button tapped")
        }
		alert.present()
    }
    
    @IBAction func showNotice(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.notice, title: kNoticeTitle, subtitle: kSubtitle)
        alert.addButton("Done") {
            print("Done button tapped")
        }
        alert.present()
    }
    
    @IBAction func showWarning(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.warning, title: kWarningTitle, subtitle: kSubtitle)
        alert.addButton("Done") {
            print("Done button tapped")
        }
        alert.present()
    }
    
    @IBAction func showInfo(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.info, title: kInfoTitle, subtitle: kSubtitle)
        alert.addButton("Done") {
            print("Done button tapped")
        }
        alert.present()
    }

	@IBAction func showEdit(sender: AnyObject) {
        let alert = SCLAlertView(appearance: SCLAppearance.edit, title: kInfoTitle, subtitle: kSubtitle)
		let txt = alert.addTextField("Enter your name")
        alert.addButton("Show Name") {
			print("Text value: \(txt.text)")
		}
        alert.present()
	}
    
    
    @IBAction func showCustomSubview(sender: AnyObject) {
        // Create custom Appearance Configuration
        let appearance = SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTitleBottomMargin: 42,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance, title: "Login", subtitle: "")
        
        // Creat the subview
        let subview = UIView(frame: CGRectMake(0,0,216,70))
        let x = (subview.frame.width - 180) / 2
        
        // Add textfield 1
        let textfield1 = UITextField(frame: CGRectMake(x,10,180,25))
        textfield1.layer.borderColor = UIColor.greenColor().CGColor
        textfield1.layer.borderWidth = 1.5
        textfield1.layer.cornerRadius = 5
        textfield1.placeholder = "Username"
        textfield1.textAlignment = NSTextAlignment.Center
        subview.addSubview(textfield1)
        
        // Add textfield 2
        let textfield2 = UITextField(frame: CGRectMake(x,textfield1.frame.maxY + 10,180,25))
        textfield2.secureTextEntry = true
        textfield2.layer.borderColor = UIColor.blueColor().CGColor
        textfield2.layer.borderWidth = 1.5
        textfield2.layer.cornerRadius = 5
        textfield1.layer.borderColor = UIColor.blueColor().CGColor
        textfield2.placeholder = "Password"
        textfield2.textAlignment = NSTextAlignment.Center
        subview.addSubview(textfield2)
        
        // Add the subview to the alert's UI property
        alert.customSubview = subview
        alert.addButton("Login") {
            print("Logged in")
        }
        
        // Add Button with Duration Status and custom Colors
        alert.addButton("Duration Button", backgroundColor: UIColor.brownColor(), textColor: UIColor.yellowColor(), showDurationStatus: true) {
            print("Duration Button tapped")
        }

        alert.present(duration: 10)
    }
    
    @IBAction func showCustomAlert(sender: AnyObject) {
        let icon = UIImage(named:"custom_icon.png")
        let color = UIColor.orangeColor()
        
        let appearance = SCLAppearance(
            kCircleIconBackgroundColor: color,
            kCircleIconImage: icon
        )
        
        let alert = SCLAlertView(appearance: appearance, title: "Custom Color", subtitle: "Custom Color")
        alert.addButton("First Button", target:self, selector:#selector(ViewController.firstButton))
        alert.addButton("Second Button") {
            print("Second button tapped")
        }
        
        alert.present()
    }
	
	func firstButton() {
		print("First button tapped")
	}
}
