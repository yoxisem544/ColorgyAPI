//
//  ColorgyRefreshCenter.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

enum RefreshTokenState {
	case Refreshing
	case NotRefreshing
}

enum RefreshTokenError: ErrorType {
	case NoRefreshToken
	case FailToParseResponse
	case NetworkError
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
	
	class func refreshAccessToken(failure: ((error: RefreshTokenError, AFError: AFError?) -> Void)?) {
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		guard let refreshToken = ColorgyRefreshCenter.sharedInstance().refreshToken else {
			failure?(error: RefreshTokenError.NoRefreshToken, AFError: nil)
			return
		}
		
		let parameters = [
			"grant_type": "refresh_token",
			// 應用程式ID application id, in colorgy server
			"client_id": "ad2d3492de7f83f0708b5b1db0ac7041f9179f78a168171013a4458959085ba4",
			"client_secret": "d9de77450d6365ca8bd6717bbf8502dfb4a088e50962258d5d94e7f7211596a3",
			"refresh_token": refreshToken
		]
		
		// lock
		ColorgyRefreshCenter.sharedInstance().lockWhenRefreshingToken()
		
		manager.POST("https://colorgy.io/oauth/token?", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			guard let response = response else {
				failure?(error: RefreshTokenError.FailToParseResponse, AFError: nil)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				return
			}
			// TODO: Success
			let json = JSON(response)
			print(json)
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				let aferror = AFError(operation: operation, error: error)
				failure?(error: RefreshTokenError.FailToParseResponse, AFError: aferror)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		})
	}
	
	private func lockWhenRefreshingToken() {
		self.refreshState = .Refreshing
	}
	
	private func unlockWhenFinishRefreshingToken() {
		self.refreshState = .NotRefreshing
	}
}