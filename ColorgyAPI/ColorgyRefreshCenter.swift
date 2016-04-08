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
	case NetworkUnavailable
	case TokenStillRefreshing
}

final public class ColorgyRefreshCenter {
	
	// MARK: - init
	
	/// **Singleton** of ColorgyRefreshCenter
	/// 
	/// Will get the only instance of refresh center
	class func sharedInstance() -> ColorgyRefreshCenter {
		
		struct Static {
			static let instance: ColorgyRefreshCenter = ColorgyRefreshCenter()
		}
		
		return Static.instance
	}
	
	private init() {
		self.refreshState = RefreshTokenState.NotRefreshing
	}
	
	/// **Initialization**
	/// Call this during app setup
	public class func initialization() {
		// start monitoring
		AFNetworkReachabilityManager.sharedManager().startMonitoring()
	}
	
	// MARK: - Public Getter
	/// Used to get a new access token from server
	var refreshToken: String? {
		return ColorgyUserInformation.sharedInstance().userRefreshToken
	}
	
	/// Used to get a access to server, retrieve some data
	var accessToken: String? {
		return ColorgyUserInformation.sharedInstance().userAccessToken
	}
	
	/// Public refresh state getter
	var currentRefreshState: RefreshTokenState {
		get {
			return refreshState
		}
	}
	
	// MARK: - Refreshing State
	/// Refresh Center's currnet refresh state
	private var refreshState: RefreshTokenState
	
	
	
	
	// MARK: - Reachability
	/// **Reachability**
	///
	/// Check network first before firing any api request
	///
	/// - returns: Bool - network availability
	private class func networkAvailable() -> Bool {
		let reachabilityManager = AFNetworkReachabilityManager.sharedManager()
		
		// get current status
		let networkStatus =
			(reachabilityManager.networkReachabilityStatus != .NotReachable
				|| reachabilityManager.networkReachabilityStatus != .Unknown)
		
		return networkStatus
	}
	
	/// Call this method to refresh current access token
	///
	/// This method will get called once. After calling this method, it will automatically lock itself.
	/// Firing two request will cause refresh token to get wrong.
	/// A refresh token can be use **only once**.
	public class func refreshAccessToken(success: (() -> Void)?, failure: ((error: RefreshingError, AFError: AFError?) -> Void)?) {
		
		// check network first
		guard networkAvailable() else {
			failure?(error: RefreshingError.NetworkUnavailable, AFError: nil)
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
		
		// check if not refreshing
		guard ColorgyRefreshCenter.sharedInstance().currentRefreshState == .NotRefreshing else {
			failure?(error: RefreshingError.TokenStillRefreshing, AFError: nil)
			return
		}
		
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
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
				return
			}
			ColorgyUserInformation.saveLoginResult(result)
			ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
			success?()
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				let aferror = AFError(operation: operation, error: error)
				failure?(error: RefreshingError.NetworkUnavailable, AFError: aferror)
				ColorgyRefreshCenter.sharedInstance().unlockWhenFinishRefreshingToken()
		})
	}
	
	// MARK: - State Handler
	/// Change current refresh state
	private func lockWhileRefreshingToken() {
		self.refreshState = .Refreshing
	}
	
	/// Change current refresh state
	private func unlockWhenFinishRefreshingToken() {
		self.refreshState = .NotRefreshing
	}
	
	
}