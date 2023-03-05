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

	init(presenter: AddNoteOutputDelegate) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(noteText)
		setUpConstraints()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
		presenter?.viewDidLoad()
		noteText.delegate = self

    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.viewWillDisappear()
	}

	@objc private func doneButtonTapped() {
		guard let presenter = presenter else { return }
		presenter.doneButtonTapped()
	}


	private func setUpConstraints() {
		NSLayoutConstraint.activate(
	[
		noteText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
		noteText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		noteText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		noteText.leadingAnchor.constraint(equalTo: view.leadingAnchor)
	]
		)
	}
}

extension AddNoteViewController: AddNoteInputDelegate {
	func updateView(text: String) {
		noteText.text = text
	}
}

extension AddNoteViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		presenter?.textDidChange(text: textView.text)
	}
}

