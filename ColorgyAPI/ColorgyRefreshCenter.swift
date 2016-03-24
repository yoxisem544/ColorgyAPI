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

	class func sharedInstance() -> ColorgyRefreshCenter {
		
		struct Static {
			static let instance: ColorgyRefreshCenter = ColorgyRefreshCenter()
		}

		return Static.instance
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
	
	class func refreshAccessToken() {
		
	}
}