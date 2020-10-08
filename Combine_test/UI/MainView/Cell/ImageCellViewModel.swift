//
//  ImageCellViewModel.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation
import Combine
import UIKit.UIImage

class ImageCellViewModel {
	let id: String
	let title: String
	let poster: AnyPublisher<UIImage?, Never>
	
	static var backgroundWorkScheduler: OperationQueue = {
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 5
		operationQueue.qualityOfService = QualityOfService.userInitiated
		return operationQueue
	}()
	
	init(id: String, title: String) {
		self.id = id
		self.title = title
		self.poster = Deferred { return Just(id) }
		.flatMap({ poster -> AnyPublisher<UIImage?, Never> in
			return ApiService.shared.loadImage(id: id, width: 255, height: 255)
   		})
		.subscribe(on: ImageCellViewModel.backgroundWorkScheduler)
		.receive(on: RunLoop.main)
		.share()
		.eraseToAnyPublisher()
	}
}

extension ImageCellViewModel: Hashable {
	static func == (lhs: ImageCellViewModel, rhs: ImageCellViewModel) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
