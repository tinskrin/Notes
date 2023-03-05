//
//  NotesCollectionViewCell.swift
//  Notes
//
//  Created by Tinskrin on 03.03.2023.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {


	private let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
		titleLabel.textColor = .white
		return titleLabel
	}()

	private let noteLabel: UILabel = {
		let noteLabel = UILabel()
		noteLabel.translatesAutoresizingMaskIntoConstraints = false
		noteLabel.font = UIFont(name: "ArialMT ", size: 20)
		noteLabel.textColor = .lightGray
		return noteLabel
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(note: String) {
		noteLabel.text = note
	}

	private func setupView() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(noteLabel)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				titleLabel.topAnchor.constraint(equalTo: topAnchor),
				titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
				titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

				noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
				noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
				noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
				noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			]
		)
	}
}
