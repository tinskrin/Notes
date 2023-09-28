//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Tinskrin on 05.03.2023.
//

import UIKit

protocol AddNoteInputDelegate: AnyObject {
	func updateView(text: String)
}

protocol AddNoteOutputDelegate: AnyObject {
	func viewDidLoad()
	func doneButtonTapped()
	func textDidChange(text: String)
	func viewWillDisappear()
}

class AddNoteViewController: UIViewController {

	private var noteText: UITextView = {
		let noteText = UITextView()
		noteText.tintColor = .systemBrown
		noteText.translatesAutoresizingMaskIntoConstraints = false
		return noteText
	}()
	private var presenter: AddNoteOutputDelegate?

	// MARK: - Init

	init(presenter: AddNoteOutputDelegate) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		setupConstraints()
		presenter?.viewDidLoad()
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.viewWillDisappear()
	}

	@objc private func doneButtonTapped() {
		guard let presenter = presenter else { return }
		presenter.doneButtonTapped()
		noteText.resignFirstResponder()
	}

	private func setupView() {
		view.backgroundColor = .systemBackground
		view.addSubview(noteText)
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
		noteText.delegate = self
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				noteText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				noteText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				noteText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
				noteText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
			]
		)
	}
}

// MARK: - AddNoteInputDelegate

extension AddNoteViewController: AddNoteInputDelegate {
	func updateView(text: String) {
		noteText.text = text
	}
}

// MARK: - UITextViewDelegate

extension AddNoteViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		presenter?.textDidChange(text: textView.text)
	}
}

