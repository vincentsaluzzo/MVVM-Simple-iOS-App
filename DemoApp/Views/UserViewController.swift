//
//  UserViewController.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable

class UserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var disposeBag = DisposeBag()
    var viewModel: UserViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.name

        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(configureCell: { [weak self] (_, collectionView, indexPath, item) -> UICollectionViewCell in
            guard let `self` = self else { fatalError() }
            switch item {
            case .profileImage(let image):
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UserProfileImageCollectionViewCell.self)
                cell.imageView.kf.setImage(with: URL(string: image)!)
                return cell

            case .actionButtons:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UserActionButtonsCollectionViewCell.self)
                cell.albumButton.addTarget(self, action: #selector(self.tapOnAlbums), for: .touchUpInside)
                cell.todosButton.addTarget(self, action: #selector(self.tapOnTodos), for: .touchUpInside)
                return cell

            case .post(let post):
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UserPostCollectionViewCell.self)
                cell.viewModel = post
                return cell
            }
        })

        viewModel.posts.asObservable()
            .map { [weak self] posts -> [Section] in
                guard let `self` = self else { return [] }

                var section = [Item]()
                section += [.profileImage(self.viewModel.profileImage)]
                section += [.actionButtons]

                section += posts.map { .post($0) }

                return [Section(header: "", items: section)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.loadNextPosts()

        collectionView.delegate = self

        collectionView.rx.modelSelected(Item.self)
            .asDriver()
            .drive(onNext: { [weak self] (item) in
                guard case .post(let postViewModel) = item else { return }
                self?.showComment(postViewModel)
            })
            .disposed(by: disposeBag)
    }

    func showComment(_ post: PostViewModeling) {
        perform(segue: StoryboardSegue.Main.showComments, sender: post.commentViewModel)
    }

    @objc func tapOnAlbums() {
        perform(segue: StoryboardSegue.Main.showAlbums, sender: nil)
    }

    @objc func tapOnTodos() {
        presentAlert(withTitle: L10n.Alert.AvailableLater.title, message: L10n.Alert.AvailableLater.message)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Main.showAlbums.rawValue,
            let viewController: AlbumsViewController = segue.destination as? AlbumsViewController {
                viewController.viewModel = self.viewModel.albumsViewModel
        } else if segue.identifier == StoryboardSegue.Main.showComments.rawValue,
            let viewModel = sender as? CommentsViewModeling,
            let viewController: CommentsViewController = segue.destination as? CommentsViewController {
            viewController.viewModel = viewModel
        }
    }
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item: Item = try? collectionView.rx.model(at: indexPath) else { return .zero }

        switch item {
        case .profileImage: return CGSize(width: collectionView.bounds.width, height: 400)
        case .actionButtons: return CGSize(width: collectionView.bounds.width, height: 70)
        case .post: return CGSize(width: collectionView.bounds.width - 50, height: 200)
        }
    }
}

extension UserViewController {
    struct Section {
        var header: String
        var items: [Item]
    }

    enum Item {
        case profileImage(String)
        case actionButtons
        case post(PostViewModeling)
    }
}

extension UserViewController.Section: SectionModelType {
    typealias Item = UserViewController.Item

    init(original: UserViewController.Section, items: [Item]) {
        self = original
        self.items = items
    }
}

class UserProfileImageCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var imageView: UIImageView!
}

class UserActionButtonsCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var todosButton: UIButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        albumButton.removeTarget(nil, action: nil, for: .allEvents)
        todosButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}

class UserPostCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    var disposeBag = DisposeBag()
    var viewModel: PostViewModeling? {
        didSet {
            designCell()
            guard let viewModel = viewModel else { return }
            titleLabel.text = "“ \(viewModel.title)"
            bodyLabel.text = viewModel.body
            viewModel.commentNumber.asDriver(onErrorJustReturn: 0)
                .map { commentNumber -> String in
                    if let commentNumber = commentNumber {
                        return L10n.User.Post.Comment.number(commentNumber)
                    } else {
                        return L10n.User.Post.Comment.loading
                    }
                }
                .drive(commentButton.rx.title())
                .disposed(by: disposeBag)
        }
    }

    func designCell() {
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        titleLabel.text = nil
        bodyLabel.text = nil
        commentButton.setTitle("", for: .normal)
    }
}
