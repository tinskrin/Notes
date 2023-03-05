//
//  ViewController.swift
//  Notes
//
//  Created by Tinskrin on 28.02.2023.
//

import UIKit

protocol ViewInputDelegate: AnyObject {
	func setUpInitialState()
	func setUpData()
	func displayData()
	func updateView(notes: [Note])
}

protocol ViewOutputDelegate: AnyObject {
	func getData(noteIndex: Int) -> String
	func removeData(noteIndex: IndexPath)
	func numberOfItem() -> Int
	func viewDidLoad()
	func addNoteTapped()
	func selectNoteCnahge(noteIndex: Int)
}


final class ViewController: UIViewController {

//	private var testData = []

	private let searchController = UISearchController(searchResultsController: nil)
	private var presenter: ViewOutputDelegate?
	private var notesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.isPagingEnabled = true
//		view.backgroundColor = .purple
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let addNoteView: AddNoteView = {
		let addNoteView = AddNoteView()
		addNoteView.translatesAutoresizingMaskIntoConstraints = false
		return addNoteView
	}()

	private let reuseIdentifier = "NoteCell"

	private enum Section: CaseIterable {
		case text
	}

	private lazy var dataSource = { conffigureDataSource() }()

	init(presenter: ViewOutputDelegate) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBar()
		view.backgroundColor = .systemBackground
		setupView()
		setupConstraints()
		setupCollectionView()
		presenter?.viewDidLoad()
		addNoteView.noteDelegate = self
		
	}

	private func setupCollectionView() {
		notesCollectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		notesCollectionView.dataSource = dataSource
//		notesCollectionView.dataSource = self
		notesCollectionView.delegate = self
		var config = UICollectionLayoutListConfiguration(appearance: .plain)
		config.trailingSwipeActionsConfigurationProvider = { indexpath in
			let action = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, completion in
				guard let presenter = self.presenter else {return}
				presenter.removeData(noteIndex: indexpath)
//				self.updateList()
//				self.addNoteView.configure(text: presenter.getAllData().count)
				completion(true)
			})
			return .init(actions: [action])
		}
		let layout = UICollectionViewCompositionalLayout.list(using: config)
		notesCollectionView.collectionViewLayout = layout

	}

	private func setupSearchBar () {
		searchController.searchResultsUpdater = self // сам класс является получателем инфы об изменении текста в поисковой строке
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.placeholder = "Search"
		navigationItem.searchController = searchController // встраиваю строку поиска в навигейшен бар
		definesPresentationContext = true
	}

	private func setupView() {
		view.addSubview(notesCollectionView)
		view.addSubview(addNoteView)
//		view.addSubview(addNoteButton)
	}



	private func conffigureDataSource() -> UICollectionViewDiffableDataSource<Section,Note> {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Note> { cell, indexPath, item in
			var config = cell.defaultContentConfiguration()
			config.text = item.text
			cell.contentConfiguration = config
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
				addNoteView.heightAnchor.constraint(equalToConstant: view.frame.height / 10)

			]
		)
	}

}


extension ViewController: ViewInputDelegate {
	func updateView(notes: [Note]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
		snapshot.appendSections(Section.allCases)
		snapshot.appendItems(notes, toSection: .text)
		dataSource.apply(snapshot)
		addNoteView.configure(text: notes.count)
	}

	func setUpInitialState() {

	}

	func setUpData() {
//		self.testdata = tesdata
	}

	func displayData() {
		
	}
	
}

extension ViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
	}

}

extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.selectNoteCnahge(noteIndex: indexPath.row)
	}
}

extension ViewController: AddNoteViewDelegate {
	func addNoteButtonTapped() {
		presenter?.addNoteTapped()
	}
}
