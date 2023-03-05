//
//  Note.swift
//  Notes
//
//  Created by Tinskrin on 01.03.2023.
//

import Foundation

protocol StorageProtocol: AnyObject {
	var notes: [Note] { get set }
}

struct Note: Hashable {
	var text: String
}

final class Storage: StorageProtocol {
	var notes: [Note] = [Note(text: "Hello"), Note(text: "World"), Note(text: "And"), Note(text: "Vlad")]
}

