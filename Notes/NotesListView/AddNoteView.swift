//
//  AddNoteView.swift
//  Notes
//
//  Created by Tinskrin on 05.03.2023.
//

import Foundation
import UIKit

protocol AddNoteViewDelegate: AnyObject {
	func addNoteButtonTapped()
}

class AddNoteView: UIView {

	private let addNoteButton: UIButton = {
		let addNoteButton = UIButton()
		let addNoteImage = UIImage(named: "addNote")?.withTintColor(.systemBrown)
		addNoteButton.setImage(addNoteImage, for: .normal)
		addNoteButton.translatesAutoresizingMaskIntoConstraints = false
		return addNoteButton
	}()

	private let totalNotesLabel: UILabel = {
		let totalNotesLabel = UILabel()
		totalNotesLabel.textColor = .systemGray
		totalNotesLabel.translatesAutoresizingMaskIntoConstraints = false
		return totalNotesLabel
	}()

	weak var noteDelegate: AddNoteViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setUpConstraints()
		setupRecognizer()
		backgroundColor = .secondarySystemBackground
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(text: Int) {
		totalNotesLabel.text = "\(text) Notes"
	}

	private func setupRecognizer() {
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(addNoteButtonPressed))
		addNoteButton.addGestureRecognizer(recognizer)
	}
	@objc private func addNoteButtonPressed() {
		noteDelegate?.addNoteButtonTapped()
	}

	private func setupViews() {
		addSubview(addNoteButton)
		addSubview(totalNotesLabel)
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate(
			[
				addNoteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
				addNoteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
				addNoteButton.topAnchor.constraint(equalTo: topAnchor,constant: 15),
				addNoteButton.widthAnchor.constraint(equalToConstant: 25),

				totalNotesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
				totalNotesLabel.centerYAnchor.constraint(equalTo: addNoteButton.centerYAnchor),
		]
		)
	}
}
