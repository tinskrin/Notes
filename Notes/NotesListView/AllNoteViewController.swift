//
//  ViewController.swift
//  Notes
//
//  Created by Tinskrin on 28.02.2023.
//

import UIKit

protocol ViewInputDelegate: AnyObject {
	func updateView(notes: [Note])
}

protocol ViewOutputDelegate: AnyObject {
	func removeData(noteIndex: IndexPath)
	func numberOfItem() -> Int
	func viewDidLoad()
	func addNoteTapped()
	func selectNoteCnahge(note: Note)
	func updateSearchText(newSearchText: String)
}

final class AllNoteViewController: UIViewController {

	// MARK: - UI

	private let searchController = UISearchController(searchResultsController: nil)
	private var presenter: ViewOutputDelegate?
	private var notesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.isPagingEnabled = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let addNoteView: AddNoteView = {
		let addNoteView = AddNoteView()
		addNoteView.translatesAutoresizingMaskIntoConstraints = false
		return addNoteView
	}()

	private enum Section: CaseIterable {
		case text
	}
	private lazy var dataSource = { conffigureDataSource() }()

	// MARK: - init

	init(presenter: ViewOutputDelegate) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBar()
		setupView()
		setupConstraints()
		setupCollectionView()
		presenter?.viewDidLoad()
	}

	// MARK: - Configure

	private func setupCollectionView() {
		notesCollectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.reuseIdentifier)
		notesCollectionView.dataSource = dataSource
		notesCollectionView.delegate = self
		var config = UICollectionLayoutListConfiguration(appearance: .plain)
		config.trailingSwipeActionsConfigurationProvider = { indexpath in
			let action = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, completion in
				guard let presenter = self.presenter else {return}
				presenter.removeData(noteIndex: indexpath)
				self.addNoteView.configure(text: presenter.numberOfItem())
				completion(true)
			})
			return .init(actions: [action])
		}
		let layout = UICollectionViewCompositionalLayout.list(using: config)
		notesCollectionView.collectionViewLayout = layout
	}

	private func setupSearchBar () {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.placeholder = "Search"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	private func setupView() {
		addNoteView.noteDelegate = self
		view.backgroundColor = .systemBackground
		view.addSubview(notesCollectionView)
		view.addSubview(addNoteView)
	}

	private func conffigureDataSource() -> UICollectionViewDiffableDataSource<Section,Note> {
		let cellRegistration = UICollectionView.CellRegistration<NotesCollectionViewCell,Note> { cell, indexPath, item in
			cell.configure(note: item)
		}
		return UICollectionViewDiffableDataSource<Section,Note>(collectionView: notesCollectionView) { collectionView, indexPath, item in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
		}
	}

	private func setupConstraints() {
		let space: CGFloat = 20
		NSLayoutConstraint.activate(
			[
				notesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
				notesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
				notesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
				notesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

				addNoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				addNoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				addNoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				addNoteView.heightAnchor.constraint(equalToConstant: 79)
			]
		)
	}

}

// MARK: - ViewInputDelegate

extension AllNoteViewController: ViewInputDelegate {
	func updateView(notes: [Note]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
		snapshot.appendSections(Section.allCases)
		snapshot.appendItems(notes, toSection: .text)
		dataSource.apply(snapshot)
		addNoteView.configure(text: notes.count)
	}
}

// MARK: - UISearchResultsUpdating

extension AllNoteViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text else { return }
		presenter?.updateSearchText(newSearchText: searchText)
	}
}

// MARK: - UICollectionViewDelegate

extension AllNoteViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
		presenter?.selectNoteCnahge(note: note)
	}
}

// MARK: - AddNoteViewDelegate

extension AllNoteViewController: AddNoteViewDelegate {
	func addNoteButtonTapped() {
		presenter?.addNoteTapped()
	}
}
