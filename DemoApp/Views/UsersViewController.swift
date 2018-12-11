//
//  UsersViewController.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class UsersViewController: UIViewController {

    enum Mode {
        case grid
        case list
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modeSwitchingButton: UIBarButtonItem!

    var viewModel: UsersViewModeling!
    var disposeBag = DisposeBag()
    var gridMode = BehaviorSubject(value: Mode.list)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Users.title

        viewModel.isLoading.asObservable()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { (loading) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            })
            .disposed(by: disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, UserViewModeling>>(configureCell: { (_, collectionView, indexPath, user) -> UICollectionViewCell in

            let cell = { () -> UserCollectionViewCell in
                switch (try? self.gridMode.value()) ?? .list {
                // swiftlint:disable force_cast
                case .grid : return collectionView.dequeueReusableCell(withReuseIdentifier: "UserCellMini", for: indexPath) as! UserCollectionViewCell
                case .list: return collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCollectionViewCell
                // swiftlint:enable force_cast
                }
            }()

            cell.viewModel = user
            return cell
        })

        viewModel.users.asObservable()
            .map { users -> [SectionModel<String, UserViewModeling>] in
                return [SectionModel(model: "", items: users)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.delegate = self

        gridMode.asDriver(onErrorJustReturn: .list)
            .drive(onNext: { [weak self] mode in
                switch mode {
                case .grid: self?.modeSwitchingButton.image = #imageLiteral(resourceName: "format-list-bulleted.png")
                case .list: self?.modeSwitchingButton.image = #imageLiteral(resourceName: "view-grid.png")
                }
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        modeSwitchingButton.rx.tap.asDriver()
            .map { ((try? self.gridMode.value()) ?? .list) == .grid ? .list : .grid }
            .drive(self.gridMode)
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(UserViewModeling.self)
            .asDriver()
            .drive(onNext: { [weak self] (user) in
                self?.showUser(user)
            })
            .disposed(by: disposeBag)
    }

    func showUser(_ user: UserViewModeling) {
        perform(segue: StoryboardSegue.Main.showUser, sender: user)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userViewController = segue.destination as? UserViewController,
            let userViewModel = sender as? UserViewModeling,
            segue.identifier == StoryboardSegue.Main.showUser.rawValue else {
            return
        }
        userViewController.viewModel = userViewModel
    }
}

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?

    var viewModel: UserViewModeling? {
        didSet {
            guard let viewModel = viewModel else { return }
            nameLabel?.text = viewModel.name
            emailLabel?.text = viewModel.email
            if let url = URL(string: viewModel.profileImage) {
                profileImageView.kf.setImage(with: url)
                profileImageView.layer.borderColor = UIColor.black.cgColor
                profileImageView.layer.cornerRadius = 8
                profileImageView.clipsToBounds = true
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel?.text = nil
        emailLabel?.text = nil
        profileImageView.image = nil
    }
}

extension UsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let mode = try? self.gridMode.value() else { return .zero }
        switch mode {
        case .grid:
            let size = (collectionView.bounds.size.width - 20.0 - 20.0) / 3.0
            return CGSize(width: size,
                          height: size)
        case .list:
            return CGSize(width: collectionView.bounds.size.width - 20,
                          height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
