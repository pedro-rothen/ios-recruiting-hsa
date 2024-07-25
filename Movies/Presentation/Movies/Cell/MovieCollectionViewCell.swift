//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Pedro on 24-07-24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    weak var delegate: MovieCollectionViewCellDelegate?

    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let toggleFavoriteButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        toggleFavoriteButton.tintColor = .yellow
        toggleFavoriteButton.addTarget(
            self,
            action: #selector(toggleFavoriteButtonTapped),
            for: .touchUpInside
        )
        let detailStack = UIStackView(arrangedSubviews: [
            titleLabel,
            toggleFavoriteButton
        ])
        detailStack.axis = .horizontal
        detailStack.backgroundColor = .gray
        let stackView = UIStackView(arrangedSubviews: [
            posterImageView,
            detailStack
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let margin = 10.0
        stackView.layoutMargins = UIEdgeInsets(
            top: margin,
            left: margin,
            bottom: margin,
            right: margin
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        // stackView.backgroundColor = [UIColor.red, UIColor.blue, UIColor.green].randomElement()
    }

    @objc
    func toggleFavoriteButtonTapped() {
        delegate?.toggleFavorite(for: self)
    }

    func bindFavoriteIcon(isFavorite: Bool) {
        toggleFavoriteButton.setImage(
            UIImage(systemName: isFavorite ? "heart.fill" : "heart"),
            for: .normal
        )
    }
}

protocol MovieCollectionViewCellDelegate: AnyObject {
    func toggleFavorite(for cell: MovieCollectionViewCell)
}
