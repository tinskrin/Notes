//
//  Presenter.swift
//  Notes
//
//  Created by Tinskrin on 01.03.2023.
//

import Foundation

final class AllNotePresenter {

	weak var view: ViewInputDelegate?
	private var storage: IStorageManager
	private let router: AllNoteRouterInput
	private var viewModel: [Note] = []
	private var searchText: String = ""

	init(storage: IStorageManager, router: AllNoteRouterInput) {
		self.storage = storage
		self.router = router
	}

	// MARK: - Private

	private func updateList() {
		guard let view = view else { return }
		viewModel = convertData()
		viewModel.sort(by: {$0.data > $1.data})
		let filteredViewModel = viewModel.filter { note in
			return note.title.lowercased().contains(searchText.lowercased()) || searchText.isEmpty
		}
		view.updateView(notes: filteredViewModel)
	}

	private func convertData() -> [Note] {
		let data = storage.getData()
		var note: [Note] = []
		for datum in data {
			note.append(Note(not: datum))
		}
		return note
	}
}

// MARK: - ViewOutputDelegate

extension AllNotePresenter: ViewOutputDelegate {
	func selectNoteCnahge(noteIndex: Int) {
		router.showAddNote(note: viewModel[noteIndex], output: self)
	}

	func viewDidLoad() {
		updateList()
	}
	
	func removeData(noteIndex: IndexPath) {
		storage.deleteNote(noteId: viewModel[noteIndex.row].id)
		updateList()
	}

	func numberOfItem() -> Int {
		viewModel.count
	}

	func addNoteTapped() {
		router.showAddNote(note: nil, output: self)
	}

	func updateSearchText(newSearchText: String) {
		searchText = newSearchText
		updateList()
	}
}

// MARK: - AddNoteOutput

extension AllNotePresenter: AddNoteOutput {
	func noteWasChange(note: Note) {
		storage.updateNote(noteId: note.id, title: note.title)
		updateList()
	}
}
