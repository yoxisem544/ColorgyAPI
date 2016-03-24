//
//  StringExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/3/24.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension String {
	var isValidURLString: Bool {
		return (NSURL(string: self) != nil)
	}
}