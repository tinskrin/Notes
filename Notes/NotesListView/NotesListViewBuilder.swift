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

	private var storage: IStorageManager

	// MARK: - Init

	init(storage: IStorageManager) {
		self.storage = storage
	}
	
	// MARK: - NotesListViewBuilderProtocol

	func build() -> UIViewController {
		let router = AllNoteRouter()
		let presenter = AllNotePresenter(storage: storage, router: router)
		let viewController = AllNoteViewController(presenter: presenter)
		router.view = viewController
		presenter.view = viewController
		return viewController
	}
}
