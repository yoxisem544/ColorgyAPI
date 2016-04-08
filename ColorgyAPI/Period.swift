//
//  Period.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class Period: NSObject {
	
	public let day: Int
	public let period: Int
	public let location: String?
	
	public override var description: String {
		return "Period: {\n\tday -> \(day)\n\tperiod -> \(period)\n\tlocation -> \(location)\n}"
	}
	
	public init(day: Int, period: Int, location: String?) {
		self.day = day
		self.period = period
		self.location = location
		super.init()
	}
}