//
//  Presenter.swift
//  Notes
//
//  Created by Tinskrin on 01.03.2023.
//

import Foundation

final class Presenter {

	weak var view: ViewInputDelegate?

	var storage: StorageProtocol

	init(storage: StorageProtocol) {
		self.storage = storage
	}

	private func updateList() {
		guard let view = view else { return }
		view.updateView(notes: storage.notes)
	}
}


extension Presenter: ViewOutputDelegate {
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

}
