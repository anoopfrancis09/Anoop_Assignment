//
//  Links.swift
//  Instagram
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
struct Links : Codable {
	let selfString : String?
	let html : String?
	let download : String?

	enum CodingKeys: String, CodingKey {

		case selfString = "self"
		case html = "html"
		case download = "download"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		selfString = try values.decodeIfPresent(String.self, forKey: .selfString)
		html = try values.decodeIfPresent(String.self, forKey: .html)
		download = try values.decodeIfPresent(String.self, forKey: .download)
	}

}
