//
//  ViewController.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let loginButton = FBSDKLoginButton()
		loginButton.center = self.view.center
		loginButton.readPermissions = ["email"]
		self.view.addSubview(loginButton)
		let button = UIButton(type: UIButtonType.System)
		button.titleLabel?.text = "yo"
		button.frame.size = CGSize(width: 100, height: 100)
		button.backgroundColor = UIColor.greenColor()
		view.addSubview(button)
		button.addTarget(self, action: "yo", forControlEvents: UIControlEvents.TouchUpInside)
		
		print(ColorgyRefreshCenter.sharedInstance().refreshToken)
		
		ColorgyRefreshCenter.startBackgroundWorker()
	}
	
	func yo() {
//		ColorgyLogin.FacebookLogin({ (token) -> Void in
//			ColorgyLogin.loginToColorgyWithFacebookToken(token, success: { (result) -> Void in
//				print(ColorgyRefreshCenter.sharedInstance().refreshToken)
//				ColorgyRefreshCenter.refreshAccessToken({ () -> Void in
//					print(ColorgyRefreshCenter.sharedInstance().refreshToken)
//					}, failure: nil)
//				}, failure: nil)
//			}) { (error) -> Void in
//				
//		}
		
		print(ColorgyRefreshCenter.refreshTokenAliveTime())
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

