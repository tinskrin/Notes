//
//  CoreDataManager.swift
//  Notes
//
//  Created by Tinskrin on 26.09.2023.
//

import Foundation
import CoreData

protocol IStorageManager: AnyObject {
	func getData() -> [Not]
	func updateNote(noteId: UUID, title: String)
	func deleteNote(noteId: UUID)
}

class CoreDataManager {

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Notes")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	private lazy var viewContext: NSManagedObjectContext = {
		return persistentContainer.viewContext
	}()

	// MARK: - Core Data Saving support

	private func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			try? context.save()
		}
	}

	private func addedNewNot(with title: String, id: UUID) {
		let note = Not(context: viewContext)
		note.title = title
		note.date = Date.now
		note.id = id
		saveContext()
	}
}

// MARK: - IStorageManager

extension CoreDataManager: IStorageManager {

	func getData() -> [Not] {
		let fetchRequest: NSFetchRequest<Not> = Not.fetchRequest()
			let context = persistentContainer.viewContext
		let notes = try? context.fetch(fetchRequest)
		return notes ?? []
	}

	func updateNote(noteId: UUID, title: String) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Not")
		fetchRequest.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)

		if let notes = try? viewContext.fetch(fetchRequest) as? [Not] {
			if let oneNote = notes.first {
				if oneNote.title != title {
					oneNote.title = title
					oneNote.date = Date.now
					if oneNote.title.isEmpty {
						deleteNote(noteId: noteId)
					}
					saveContext()
				}
			} else {
				if !title.isEmpty {
					addedNewNot(with: title, id: noteId)
				}
			}
		}
	}

	func deleteNote(noteId: UUID) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Not")
		fetchRequest.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
		if let notes = try? viewContext.fetch(fetchRequest) as? [Not] {
			guard let noteToDelete = notes.first else { return }
			viewContext.delete(noteToDelete)
			saveContext()
		}
	}
}
