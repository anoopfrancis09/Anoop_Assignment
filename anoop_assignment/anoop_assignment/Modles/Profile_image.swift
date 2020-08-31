//
//  Profile_image.swift
//  Instagram
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import Foundation
struct Profile_image : Codable {
	let small : String?
	let medium : String?
	let large : String?

	enum CodingKeys: String, CodingKey {

		case small = "small"
		case medium = "medium"
		case large = "large"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		small = try values.decodeIfPresent(String.self, forKey: .small)
		medium = try values.decodeIfPresent(String.self, forKey: .medium)
		large = try values.decodeIfPresent(String.self, forKey: .large)
	}

}
