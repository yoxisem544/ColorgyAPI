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

public enum RefreshTokenState {
	case Refreshing
	case NotRefreshing
}

public enum RefreshingError: ErrorType {
	case NoRefreshToken
	case FailToParseResponse
	case NetworkError
}

final public class ColorgyRefreshCenter {
	
	class func sharedInstance() -> ColorgyRefreshCenter {
		
		struct Static {
			static let instance: ColorgyRefreshCenter = ColorgyRefreshCenter()
		}
		
		return Static.instance
	}
	
	var refreshToken: String? {
		return ColorgyUserInformation.sharedInstance().userRefreshToken
	}
	var accessToken: String? {
		return ColorgyUserInformation.sharedInstance().userAccessToken
	}
	private var refreshState: RefreshTokenState
	
	/// Public refresh state getter
	var currentRefreshState: RefreshTokenState {
		get {
			return refreshState
		}
	}
	
	init() {
		self.refreshState = RefreshTokenState.NotRefreshing
	}
	
	/// **Initialization**
	/// Call this during app setup
	public class func initialization() {
		// start monitoring
		AFNetworkReachabilityManager.sharedManager().startMonitoring()
	}
	
	public class func refreshAccessToken(success: (() -> Void)?, failure: ((error: RefreshingError, AFError: AFError?) -> Void)?) {
		
		// check network first
		let reachabilityManager = AFNetworkReachabilityManager.sharedManager()
		let networkStatus =
			(reachabilityManager.networkReachabilityStatus != .NotReachable
				|| reachabilityManager.networkReachabilityStatus != .Unknown)
		guard networkStatus else {
			failure?(error: RefreshingError.NetworkError, AFError: nil)
			return
		}
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		guard let refreshToken = ColorgyRefreshCenter.sharedInstance().refreshToken else {
			failure?(error: RefreshingError.NoRefreshToken, AFError: nil)
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
		ColorgyRefreshCenter.sharedInstance().lockWhileRefreshingToken()
		
		manager.POST("https://colorgy.io/oauth/token?", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			guard let response = response else {
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				return
			}
			// TODO: Success
			let json = JSON(response)
			guard let result = ColorgyLoginResult(json: json) else {
				failure?(error: RefreshingError.FailToParseResponse, AFError: nil)
				return
			}
			ColorgyUserInformation.saveLoginResult(result)
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
			success?()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				let aferror = AFError(operation: operation, error: error)
				failure?(error: RefreshingError.NetworkError, AFError: aferror)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		})
	}
	
	private func lockWhileRefreshingToken() {
		self.refreshState = .Refreshing
	}
	
	private func unlockWhenFinishRefreshingToken() {
		self.refreshState = .NotRefreshing
	}
	
	
}