//
//  ImageViewController.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import UIKit
import Combine

class ImageViewController: UIViewController {
	
	@IBOutlet weak var imageOutlet: UIImageView!
	
	var viewModel: ImageViewModel?
	
	private var cancellable: AnyCancellable?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bind()
	}

	func bind() {
		cancelImageLoading()
		cancellable = viewModel?.image.sink { [unowned self] image in self.showImage(image: image) }
	}

	private func showImage(image: UIImage?) {
		cancelImageLoading()
		UIView.transition(with: self.imageOutlet,
		duration: 0.3,
		options: [.curveEaseOut, .transitionCrossDissolve],
		animations: {
			self.imageOutlet?.image = image
		})
	}

	private func cancelImageLoading() {
		imageOutlet?.image = nil
		cancellable?.cancel()
	}
}
