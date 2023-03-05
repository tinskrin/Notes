//
//  Presenter.swift
//  Notes
//
//  Created by Tinskrin on 01.03.2023.
//

import Foundation

final class Presenter {

	weak var view: ViewInputDelegate?

	let storage: StorageProtocol
	let router: RouterInput

	init(storage: StorageProtocol, router: RouterInput) {
		self.storage = storage
		self.router = router

	}

	private func updateList() {
		guard let view = view else { return }
		view.updateView(notes: storage.notes)
	}
}


extension Presenter: ViewOutputDelegate {
	func selectNoteCnahge(noteIndex: Int) {
		router.showAddNote(note: storage.notes[noteIndex], output: self)
	}

	func viewDidLoad() {
		updateList()
	}

	func getData(noteIndex: Int) -> String {
		storage.notes[noteIndex].text
	}

	func removeData(noteIndex: IndexPath) {
		storage.notes.remove(at: noteIndex.row)
		updateList()
	}

	func numberOfItem() -> Int {
		storage.notes.count
	}

	func addNoteTapped() {
		router.showAddNote(note: nil, output: self)
	}
}

extension Presenter: AddNoteOutput {
	func noteWasChange(note: Note) {
		print(note)
	}
}
