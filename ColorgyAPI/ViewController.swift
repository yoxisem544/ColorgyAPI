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
import SwiftyJSON

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
		
		let button2 = UIButton(type: UIButtonType.System)
		button2.titleLabel?.text = "yo"
		button2.frame.size = CGSize(width: 100, height: 100)
		button2.backgroundColor = UIColor.grayColor()
		button2.frame.origin.x = 100
		view.addSubview(button2)
		button2.addTarget(self, action: #selector(b2), forControlEvents: UIControlEvents.TouchUpInside)
		
		let button3 = UIButton(type: UIButtonType.System)
		button3.titleLabel?.text = "yo"
		button3.frame.size = CGSize(width: 100, height: 100)
		button3.backgroundColor = UIColor.blueColor()
		button3.frame.origin.x = 200
		view.addSubview(button3)
		button3.addTarget(self, action: #selector(b3), forControlEvents: UIControlEvents.TouchUpInside)
		
		print(ColorgyRefreshCenter.sharedInstance().refreshToken)
		
		ColorgyRefreshCenter.startBackgroundWorker()
	}
	
	func b3() {
		let api = ColorgyAPI()
		api.me({ (result) in
			print(result)
			}) { (error, AFError) in
				print(error)
				print(AFError)
		}
	}
	
	func b2() {
		ColorgyRefreshCenter.sharedInstance().yo()
		print(ColorgyRefreshCenter.sharedInstance().currentRefreshState)
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

