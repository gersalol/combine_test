//
//  ImageViewModel.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation
import Combine
import UIKit.UIImage

class ImageViewModel {
	let id: String
	
	let image: AnyPublisher<UIImage?, Never>
	
	private var cancellables: Set<AnyCancellable> = []
	
	init(id: String) {
		self.id = id
		self.image = Deferred { return Just(id) }
			.flatMap({ image -> AnyPublisher<UIImage?, Never> in
			 return ApiService.shared.loadImage(id: id, width: 1366, height: 768)
		 })
		 .subscribe(on: ImageCellViewModel.backgroundWorkScheduler)
		 .receive(on: RunLoop.main)
		 .share()
		 .eraseToAnyPublisher()
	}
}
