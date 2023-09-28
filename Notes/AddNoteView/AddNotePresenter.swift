//
//  AddNotePresenter.swift
//  Notes
//
//  Created by Tinskrin on 05.03.2023.
//

import Foundation

protocol AddNoteOutput: AnyObject {
	func noteWasChange(note: Note)
}

class AddNotePresenter {

	private var note: Note
	weak var addNoteView: AddNoteInputDelegate?
	weak var output: AddNoteOutput?

	init(note: Note?) {
		if let note = note {
			self.note = note
		} else {
			self.note = Note(title: "", data: .now, id: UUID())
		}
	}
}

// MARK: - AddNoteOutputDelegate

extension AddNotePresenter: AddNoteOutputDelegate {

	func textDidChange(text: String) {
		note.title = text
	}

	func viewWillDisappear() {
		output?.noteWasChange(note: note)
	}

	func viewDidLoad() {
		addNoteView?.updateView(text: note.title)
	}

	func doneButtonTapped() {
		output?.noteWasChange(note: note)
	}
}
