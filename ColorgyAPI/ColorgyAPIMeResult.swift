//
//  ColorgyAPIMeResult.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

private struct APIResult {
	struct Me {
		// all result key of me api is here
		static let id = "id"
		static let uuid = "uuid"
		static let username = "username"
		static let name = "name"
		static let avatar_url = "avatar_url"
		static let cover_photo_url = "cover_photo_url"
		static let _type = "_type"
		static let organization = "organization"
		static let department = "department"
		static let possible_organization_code = "possible_organization_code"
		static let possible_department_code = "possible_department_code"
		//--------------new data----------------
		static let email = "email"
		static let fbemail = "fbemail"
	}
}

/// You can easily use this to handle with result from Me API.
class ColorgyAPIMeResult : CustomStringConvertible {
	
	var id: Int
	var uuid: String
	var username: String?
	var name: String?
	var avatar_url: String?
	var cover_photo_url: String?
	var _type: String?
	var organization: String?
	var department: String?
	var possible_organization_code: String?
	var possible_department_code: String?
	//--------------new data----------------
	var email: String?
	var fbemail: String?
	
	var description: String { return "ColorgyAPIMeResult: {\n\tid => \(id)\n\tuuid => \(uuid)\n\tusername => \(username)\n\tname => \(name)\n\tavatar_url => \(avatar_url)\n\tcover_photo_url => \(cover_photo_url)\n\t_type => \(_type)\n\torganization => \(organization)\n\tdepartment => \(department)\n\tpossible_organization_code => \(possible_organization_code)\n\tpossible_department_code => \(possible_department_code)\n\temail => \(email)\n\tfbemail => \(fbemail)\n}" }
	
	func isUserRegisteredTheirSchool() -> Bool {
		if (self.possible_organization_code == nil || self.possible_department_code == nil) {
			return false
		}
		return true
	}
	
	init?(json: JSON) {
		// failable initializer must have all properties initialized before returning nil
		self.id = -1
		self.uuid = ""
	
		// necessary part
		guard let id = json[APIResult.Me.id].int else { return nil }
		self.id = id
		guard let uuid = json[APIResult.Me.uuid].string else { return nil }
		self.uuid = uuid
		// optional part
		self.username = json[APIResult.Me.username].string
		self.name = json[APIResult.Me.name].string
		self.avatar_url = json[APIResult.Me.avatar_url].string
		self.cover_photo_url = json[APIResult.Me.cover_photo_url].string
		self._type = json[APIResult.Me._type].string
		self.organization = json[APIResult.Me.organization].string
		self.department = json[APIResult.Me.department].string
		self.possible_organization_code = json[APIResult.Me.possible_organization_code].string
		self.possible_department_code = json[APIResult.Me.possible_department_code].string
		self.email = json[APIResult.Me.email].string
		self.fbemail = json[APIResult.Me.fbemail].string
	}
}

class ColorgyAPIUserResult : CustomStringConvertible {
	
	var id: Int
	var uuid: String
	var username: String?
	var name: String?
	var avatar_url: String?
	var cover_photo_url: String?
	var _type: String?
	var organization: String?
	var department: String?
	var possible_organization_code: String?
	var possible_department_code: String?
	
	var description: String { return "ColorgyAPIUserResult: {\n\tid => \(id)\n\tuuid => \(uuid)\n\tusername => \(username)\n\tname => \(name)\n\tavatar_url => \(avatar_url)\n\tcover_photo_url => \(cover_photo_url)\n\t_type => \(_type)\n\torganization => \(organization)\n\tdepartment => \(department)\n\tpossible_organization_code => \(possible_organization_code)\n\tpossible_department_code => \(possible_department_code)\n}" }
	
	init?(json: JSON) {
		// failable initializer must have all properties initialized before returning nil
		self.id = -1
		self.uuid = ""
		
		// necessary part
		guard let id = json[APIResult.Me.id].int else { return nil }
		self.id = id
		guard let uuid = json[APIResult.Me.uuid].string else { return nil }
		self.uuid = uuid
		// optional part
		self.username = json[APIResult.Me.username].string
		self.name = json[APIResult.Me.name].string
		self.avatar_url = json[APIResult.Me.avatar_url].string
		self.cover_photo_url = json[APIResult.Me.cover_photo_url].string
		self._type = json[APIResult.Me._type].string
		self.organization = json[APIResult.Me.organization].string
		self.department = json[APIResult.Me.department].string
		self.possible_organization_code = json[APIResult.Me.possible_organization_code].string
		self.possible_department_code = json[APIResult.Me.possible_department_code].string
	}
}