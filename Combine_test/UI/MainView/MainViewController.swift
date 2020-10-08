//
//  ViewController.swift
//  Combine_test
//
//  Created by Герман Кононец on 08.10.2020.
//

import Combine
import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet weak var navigationBar: UINavigationBar!
	
	private let viewModel = MainViewModel()
	private var cancellables: Set<AnyCancellable> = []
	private let selection = PassthroughSubject<String, Never>()
	private lazy var dataSource = makeDataSource()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = dataSource
		bind()
		setupNavigationBar()
	}

	private func setupNavigationBar() {
		navigationBar.items?.first?.rightBarButtonItem = UIBarButtonItem(title: "text", style: .done, target: self, action: #selector(action))
	}
	
	private func bind() {
		cancellables.forEach { $0.cancel() }
		cancellables.removeAll()
		
		viewModel.$imageList
			.sink(receiveValue: {[unowned self] list in
				self.render(list)
			}).store(in: &cancellables)
		selection
			.sink(receiveValue: {[unowned self] id in
				let storyBoard = UIStoryboard(name: "Main", bundle:nil)
				if let imageVC = storyBoard.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
					imageVC.viewModel = ImageViewModel(id: id)
					self.present(imageVC, animated: true, completion: nil)
				}
			})
			.store(in: &cancellables)
	}
	
	private func render(_ imageList: [ImageModel]) {
		let imageViewModels = imageList.map { ImageCellViewModel(id: $0.id, title: $0.author)}
		DispatchQueue.main.async {
			var snapshot = NSDiffableDataSourceSnapshot<Section, ImageCellViewModel>()
			snapshot.appendSections(Section.allCases)
			snapshot.appendItems(imageViewModels, toSection: .image)
			self.dataSource.apply(snapshot, animatingDifferences: true)
		}
	
	}
	
	@objc func action(sender: UIBarButtonItem) {
		let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		if let textVC = storyBoard.instantiateViewController(withIdentifier: "TextViewController") as? TextViewController {
			self.present(textVC, animated: true, completion: nil)
		}
	}

}

extension MainViewController: UITableViewDelegate {
	enum Section: CaseIterable {
		case image
	}

	func makeDataSource() -> UITableViewDiffableDataSource<Section, ImageCellViewModel> {
		return UITableViewDiffableDataSource(
			tableView: tableView,
			cellProvider: {  tableView, indexPath, imageViewModel in
				guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCellView") as? ImageCellView else {
					assertionFailure("Failed to dequeue \(ImageCellViewModel.self)!")
					return UITableViewCell()
				}
				cell.accessibilityIdentifier = "ImageCellView"
				cell.bind(to: imageViewModel)
				return cell
			}
		)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let snapshot = dataSource.snapshot()
		selection.send(snapshot.itemIdentifiers[indexPath.row].id)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


