//
//  TextViewModel.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation
import Combine

class TextViewModel {
	
	@Published var text = ""
	
	var subscriber: AnyCancellable?
	
	init() {
		subscriber =  UserDefaults.standard
			.publisher(for: \.text)
			.assign(to: \.text, on: self)
	}
	
	func save(text: String){
		UserDefaults.standard.set(text, forKey: "value")
	}

}

extension UserDefaults {
	@objc dynamic var text: String {
		return string(forKey: "value") ?? ""
	}
}
