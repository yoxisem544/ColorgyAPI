//
//  AFError.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/23.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class AFError: NSObject {
	
	var statusCode: Int?
	var responseBody: String?
	
	override public var description: String { return "AFError:{\n\tstatusCode: \(statusCode)\n\tresponseBody: \(responseBody)\n" }
	
	init(operation: NSURLSessionDataTask?, error: NSError) {
		self.statusCode = AFNetworkingErrorParser.statusCode(operation)
		self.responseBody = AFNetworkingErrorParser.responseBody(error)
	}
}