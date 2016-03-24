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

class ColorgyAPI : NSObject {
	
	// MARK: - User API
	// get me
	/// You can simply get Me API using this.
	///
	/// :returns: result: ColorgyAPIMeResult?, you can store it.
	/// :returns: error: An error if you got one, then handle it.
	class func me(completionHandler: (result: ColorgyAPIMeResult) -> Void, failure: ((error: APIMeError, AFError: AFError?) -> Void)?) {
		
		let manager = AFHTTPSessionManager(baseURL: nil)
		manager.requestSerializer = AFJSONRequestSerializer()
		manager.responseSerializer = AFJSONResponseSerializer()
		
		print("getting me API")
		
		guard let accesstoken = ColorgyUserInformation.sharedInstance().userAccessToken else {
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
			// into background
			//                        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
			let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
			dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
				// then handle response
				print("me API successfully get")
				// will pass in a json, then generate a result
				guard let response = response else {
					failure?(error: APIMeError.FailToParseResult, AFError: nil)
					return
				}
				let json = JSON(response)
				print("ME get!")
				if let result = ColorgyAPIMeResult(json: json) {
					print(result)
					// store
					UserSetting.storeAPIMeResult(result: result)
					// return to main queue
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						completionHandler(result: result)
					})
				} else {
					// return to main queue
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						failure()
					})
				}

			})
			}, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
				// then handle response
				print("fail to get me API")
				let aferror = AFError(operation: operation, error: error)
				failure?(error: APIMeError.NoAccessToken, AFError: aferror)
		})
	}
}