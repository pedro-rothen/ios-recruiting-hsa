//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Pedro on 25-07-24.
//

import UIKit
import Kingfisher
import Combine

class MovieDetailViewController: UIViewController {
    let contentScrollView = UIScrollView()
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16/9).isActive = true
        return imageView
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    var cancellables = Set<AnyCancellable>()

    let movie: Movie
    let getGenresByIdsUseCase: GetGenresByIdsUseCase

    init(movie: Movie, getGenresByIdsUseCase: GetGenresByIdsUseCase) {
        self.movie = movie
        self.getGenresByIdsUseCase = getGenresByIdsUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = UIView()
        view.backgroundColor = .white

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentScrollView)
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let scrollableContentView = UIView()
        scrollableContentView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(scrollableContentView)

        NSLayoutConstraint.activate([
            scrollableContentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            scrollableContentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            scrollableContentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor)
        ])

        let bottomConstraint = scrollableContentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
        scrollableContentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        let margin = 10.0
        contentStackView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(posterImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(releaseYearLabel)
        contentStackView.addArrangedSubview(genresLabel)
        contentStackView.addArrangedSubview(overviewLabel)
        scrollableContentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(movie: movie)
    }

    func bind(movie: Movie) {
        if let url = URL(string: Constants.MOVIEDBIMAGEURL + "\(movie.posterPath)") {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = movie.title
        releaseYearLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        getGenresByIdsUseCase
            .execute(ids: movie.genreIds)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [weak self] in
                let genres = $0.reduce("", { result, genre in
                    result + "\(genre.name), "
                }).dropLast(2)
                self?.genresLabel.text = String(genres)
            }.store(in: &cancellables)
    }
}
