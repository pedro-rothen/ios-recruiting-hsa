//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Pedro on 25-07-24.
//

import UIKit
import Kingfisher

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

    let movie: Movie
    let getGenresUseCase: GetGenresUseCase

    init(movie: Movie, getGenresUseCase: GetGenresUseCase) {
        self.movie = movie
        self.getGenresUseCase = getGenresUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = UIView()
        
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
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(posterImageView)
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

        if let url = URL(string: Constants.MOVIEDBIMAGEURL + "\(movie.posterPath)") {
            posterImageView.kf.setImage(with: url)
        }
    }
}
