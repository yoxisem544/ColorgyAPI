//
//  ColorgyUserInformation.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

struct LoginResultKeys {
	static let created_at = "LoginResultKeys created_at"
	static let scope = "LoginResultKeys scope"
	static let token_type = "LoginResultKeys token_type"
	static let access_token = "LoginResultKeys access_token"
	static let expires_in = "LoginResultKeys expires_in"
	static let refresh_token = "LoginResultKeys refresh_token"
}

class ColorgyUserInformation {
	
	class func sharedInstance() -> ColorgyUserInformation {
		
		struct Static {
			static let instance: ColorgyUserInformation = ColorgyUserInformation()
		}
		
		return Static.instance
	}
	
	func saveLoginResult(result: ColorgyLoginResult) {
		let ud = NSUserDefaults.standardUserDefaults()
		ud.setObject(result.created_at, forKey: LoginResultKeys.created_at)
		ud.setObject(result.scope, forKey: LoginResultKeys.scope)
		ud.setObject(result.token_type, forKey: LoginResultKeys.token_type)
		ud.setObject(result.access_token, forKey: LoginResultKeys.access_token)
		ud.setObject(result.expires_in, forKey: LoginResultKeys.expires_in)
		ud.setObject(result.refresh_token, forKey: LoginResultKeys.refresh_token)
		ud.synchronize()
	}
	
	
}
