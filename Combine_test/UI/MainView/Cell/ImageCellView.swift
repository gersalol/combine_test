//
//  ImageTableCell.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import UIKit
import Combine

class ImageCellView: UITableViewCell {
	
	@IBOutlet weak var imageOutlet: UIImageView!
	@IBOutlet weak var labelOutlet: UILabel!
	private var cancellable: AnyCancellable?
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cancelImageLoading()
	}

	func bind(to viewModel: ImageCellViewModel) {
		cancelImageLoading()
		labelOutlet.text = viewModel.title
		cancellable = viewModel.poster.sink { [unowned self] image in self.showImage(image: image) }
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
