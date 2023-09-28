//
//  NotesCollectionViewCell.swift
//  Notes
//
//  Created by Tinskrin on 03.03.2023.
//

import UIKit

final class NotesCollectionViewCell: UICollectionViewCell {

	static let reuseIdentifier = String(describing: NotesCollectionViewCell.self)

	//MARK: - UI

	private let noteLabel: UILabel = {
		let noteLabel = UILabel()
		noteLabel.translatesAutoresizingMaskIntoConstraints = false
		noteLabel.font = UIFont(name: "ArialMT ", size: 20)
		noteLabel.numberOfLines = 1
		noteLabel.textColor = .black
		return noteLabel
	}()

	private let dateLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont(name: "ArialMT", size: 10)
		titleLabel.textColor = .lightGray
		return titleLabel
	}()

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Configure

	func configure(note: Note) {
		noteLabel.text = note.title
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yy"
		let date = note.data
		dateLabel.text = dateFormatter.string(from: date)
	}

	// MARK: - Private

	private func setupView() {
		contentView.addSubview(noteLabel)
		contentView.addSubview(dateLabel)
	}

	private func setupConstraints() {
		let margins: CGFloat = 8
		NSLayoutConstraint.activate(
			[
				noteLabel.topAnchor.constraint(equalTo: topAnchor, constant: margins),
				noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
				noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

				dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 5),
				dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
				dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
				dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
			]
		)
	}
}
