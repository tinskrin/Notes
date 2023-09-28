//
//  Note.swift
//  Notes
//
//  Created by Tinskrin on 01.03.2023.
//

import Foundation

struct Note: Hashable {
	var title: String
	var data: Date
	var id: UUID

	init(title: String, data: Date, id: UUID) {
		self.title = title
		self.data = data
		self.id = id
	}

	init(not: Not) {
		self.title = not.title
		self.data = not.date
		self.id = not.id
	}
}
