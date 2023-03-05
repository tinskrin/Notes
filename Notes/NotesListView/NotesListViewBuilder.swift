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
		let router = Router()
		let presenter = Presenter(storage: storage, router: router)
		let viewController = ViewController(presenter: presenter)
		router.view = viewController
		presenter.view = viewController
		return viewController
	}
}
