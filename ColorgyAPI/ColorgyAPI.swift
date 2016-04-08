//
//  ColorgyAPIHandler.swift
//  ColorgyAPIHandler
//
//  Created by David on 2015/8/22.
//  Copyright (c) 2015年 David. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

enum APIMeError: ErrorType {
	case FailToParseResult
	case NetworkError
	case NoAccessToken
	case InvalidURLString
}

final public class ColorgyAPI : NSObject {
	
	/// initializer
	override init() {
		super.init()
	}
	
	/// public access token getter
	private var accessToken: String? {
		get {
			return ColorgyRefreshCenter.sharedInstance().accessToken
		}
	}
	
	/// This depends on Refresh center
	/// Will lock if token is refreshing
	/// - returns: 
	///		- True: If token is available
	///		- False: Time out, no network might cause this problem
	private func allowAPIAccessing() -> Bool {
		
		var retryCounter = 5
		
		while retryCounter > 0 {
			// decrease counter
			retryCounter -= 1
			// wait for 3 seconds
			NSThread.sleepForTimeInterval(3.0)
			// check if available
			if ColorgyRefreshCenter.sharedInstance()
		}
		
		return false
	}
	
	// MARK: - User API
	// get me
	/// You can simply get Me API using this.
	///
	/// - returns: 
	///		- result: ColorgyAPIMeResult?, you can store it.
	///		- error: An error if you got one, then handle it.
	func me(success: ((result: ColorgyAPIMeResult) -> Void)?, failure: ((error: APIMeError, AFError: AFError?) -> Void)?) {
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		print("getting me API")
		
		guard let accesstoken = self.accessToken else {
			failure?(error: APIMeError.NoAccessToken, AFError: nil)
			return
		}
		let url = "https://colorgy.io:443/api/v1/me.json?access_token=\(accesstoken)"
		guard url.isValidURLString else {
			failure?(error: APIMeError.InvalidURLString, AFError: nil)
			return
		}
		
		// then start job
		manager.GET(url, parameters: nil, progress: nil,success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
			// will pass in a json, then generate a result
			guard let response = response else {
				failure?(error: APIMeError.FailToParseResult, AFError: nil)
				return
			}
			let json = JSON(response)
			guard let result = ColorgyAPIMeResult(json: json) else {
				failure?(error: APIMeError.FailToParseResult, AFError: nil)
				return
			}
			// store
			ColorgyUserInformation.saveAPIMeResult(result)
			// success
			success?(result: result)
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				// then handle response
				let aferror = AFError(operation: operation, error: error)
				failure?(error: APIMeError.NoAccessToken, AFError: aferror)
		})
	}
}