//
//  ImageModel.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation

struct ImageModel: Codable {
	let id: String
	let author: String
	let width: Int
	let height: Int
	let url: String
	let download_url: String
}
