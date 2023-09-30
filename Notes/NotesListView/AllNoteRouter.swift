//
//  Router.swift
//  Notes
//
//  Created by Tinskrin on 05.03.2023.
//

import UIKit

protocol AllNoteRouterInput {
	func showAddNote(note: Note?, output: AddNoteOutput)
}

final class AllNoteRouter: AllNoteRouterInput {

	weak var view: UIViewController?

	func showAddNote(note: Note?,output: AddNoteOutput) {
		let presenter = AddNotePresenter(note: note)
		let addNoteView = AddNoteViewController(presenter: presenter)
		presenter.addNoteView = addNoteView
		presenter.output = output
		view?.navigationController?.pushViewController(addNoteView, animated: true)
	}
}
