//
//  MainViewModel.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
	
	@Published var imageList: [ImageModel] = []
	
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		ApiService.shared.load()
			.assign(to: \.imageList, on: self)
			.store(in: &cancellables)
	}
	
}
