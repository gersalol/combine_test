//
//  TextViewController.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import UIKit
import Combine

class TextViewController: UIViewController {
	
	@IBOutlet weak var textFieldOutelt: UITextField!
	
	private let viewModel = TextViewModel()
	private var cancellables: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bind()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		viewModel.save(text: textFieldOutelt.text ?? "")
		super.viewWillDisappear(animated)
	}
	
	private func bind() {
		cancellables.forEach { $0.cancel() }
		cancellables.removeAll()
		
		viewModel.$text
			.sink(receiveValue: {[unowned self] text in
				self.textFieldOutelt.text = text
			}).store(in: &cancellables)
	}
}
