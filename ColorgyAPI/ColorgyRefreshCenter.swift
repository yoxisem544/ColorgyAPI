//
//  ColorgyRefreshCenter.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

enum RefreshTokenState {
	case Refreshing
	case NotRefreshing
}

class ColorgyRefreshCenter {
	
//	class var sharedInstance: ColorgyRefreshCenter {
//		
//		struct Static {
//			static var onceToken: dispatch_once_t = 0
//			static var instance: ColorgyRefreshCenter? = nil
//		}
//		
//		dispatch_once(&Static.onceToken) { () -> Void in
//			Static.instance = ColorgyRefreshCenter()
//		}
//		
//		return Static.instance!
//	}
//	
	class func sharedInstance() -> ColorgyRefreshCenter {
		
		struct Static {
			static var onceToken: dispatch_once_t = 0
			static var instance: ColorgyRefreshCenter? = nil
		}
		
		dispatch_once(&Static.onceToken) { () -> Void in
			Static.instance = ColorgyRefreshCenter()
		}
		
		return Static.instance!
	}
	
	var refreshToken: String?
	var accessToken: String?
	private var refreshState: RefreshTokenState
	
	struct StorageKeys {
		static let accessToken = "This is key for access token"
		static let refreshToken = "This is key for refresh token"
	}
	
	init() {
		let ud = NSUserDefaults.standardUserDefaults()
		self.accessToken = ud.objectForKey(StorageKeys.accessToken) as? String
		self.refreshToken = ud.objectForKey(StorageKeys.refreshToken) as? String
		self.refreshState = RefreshTokenState.NotRefreshing
	}
	
	
}