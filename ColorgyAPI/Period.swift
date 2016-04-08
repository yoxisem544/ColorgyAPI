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
		if location == "" {
			self.location = "無上課地點"
		} else {
			self.location = location
		}
		super.init()
	}
	
	public convenience init?(day: Int?, period: Int?, location: String?) {
		guard day != nil else { return nil }
		guard period != nil else { return nil }
		
		self.init(day: day!, period: period!, location: location)
	}
	
	public class func generatePeriods(days: [Int?], periods: [Int?], locations: [String?]) -> [Period] {
		
		// initialize cache
		var periodArray = [Period]()
		
		// 3 arrays must be the same length
		guard days.count == periods.count && days.count == locations.count else { return periodArray }
		
		for index in 0..<days.endIndex {
			if let p = Period(day: days[index], period: periods[index], location: locations[index]) {
				periodArray.append(p)
			}
		}
		
		return periodArray
	}
}