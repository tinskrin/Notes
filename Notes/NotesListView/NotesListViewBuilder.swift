//
//  NotesListViewBuilder.swift
//  Notes
//
//  Created by Tinskrin on 03.03.2023.
//

import UIKit

protocol NotesListViewBuilderProtocol: AnyObject {
	func build() -> UIViewController
}

final class NotesListViewBuilder: NotesListViewBuilderProtocol {

	var storage: StorageProtocol

	init(storage: StorageProtocol) {
		self.storage = storage
	}

	// MARK: - NotesListViewBuilderProtocol

	func build() -> UIViewController {
		let presenter = Presenter(storage: storage)
		let viewController = ViewController(presenter: presenter)
		presenter.view = viewController
		return viewController
	}
}
