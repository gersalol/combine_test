//
//  ApiService.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Foundation
import Combine
import UIKit.UIImage

final class ApiService {
	
	static let shared = ApiService()
	
	func load() -> AnyPublisher<[ImageModel], Never> {
		return URLSession.shared.dataTaskPublisher(for: ApiConstants.listImageUrl)
			.map { $0.data }
			.decode(type: [ImageModel].self, decoder: JSONDecoder())
			.catch { error in Just([])}
			.eraseToAnyPublisher()
	}
	
	func loadImage(id: String, width: Int, height: Int) -> AnyPublisher<UIImage?, Never> {
		guard let url = buildImageUrl(id: id, width: width, height: height) else {
			return Just(nil)
				.eraseToAnyPublisher()
		}
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { (data, response) -> UIImage? in return UIImage(data: data) }
			.catch { error in return Just(nil) }
			.print("Image loading \(url):")
			.eraseToAnyPublisher()
	}
	
	private func buildImageUrl(id: String, width: Int, height: Int) -> URL? {
		return ApiConstants.baseUrl.appendingPathComponent("id")
			.appendingPathComponent(id)
			.appendingPathComponent(String(width))
			.appendingPathComponent(String(height))
	}
}
