//
//  AlbumsViewController.swift
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

class AlbumsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AlbumsViewModeling!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Albums.title

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AlbumViewModeling>>(configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumCollectionViewCell.self)
            cell.viewModel = item
            return cell

        })

        viewModel.albums.asObservable()
            .map { albums -> [SectionModel<String, AlbumViewModeling>] in
                return [SectionModel(model: "", items: albums)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.delegate = self

        collectionView.rx.modelSelected(AlbumViewModeling.self).asDriver()
            .drive(onNext: chooseAlbum)
            .disposed(by: disposeBag)

    }

    func chooseAlbum(_ album: AlbumViewModeling) {
        perform(segue: StoryboardSegue.Main.showAlbum, sender: album)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == StoryboardSegue.Main.showAlbum.rawValue,
            let viewModel: AlbumViewModeling = sender as? AlbumViewModeling,
            let viewController: AlbumViewController = segue.destination as? AlbumViewController else {
                return
        }

        viewController.viewModel = viewModel
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.bounds.size.width - 20.0 - 20.0) / 3.0
        return CGSize(width: size, height: size)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

class AlbumCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var imageView: UIImageView!
    var disposeBag = DisposeBag()
    var viewModel: AlbumViewModeling? {
        didSet {
            guard let viewModel = viewModel else { return }

            viewModel.photos.asDriver(onErrorJustReturn: [])
                .map { $0.first }
                .drive(onNext: { [weak self] (photoViewModel) in
                    guard let photoViewModel = photoViewModel else {
                        self?.imageView.image = nil
                        return
                    }
                    self?.imageView.kf.setImage(with: URL(string: photoViewModel.thumbnail)!)
                    self?.imageView.layer.borderColor = UIColor.black.cgColor
                    self?.imageView.layer.cornerRadius = 20
                    self?.imageView.clipsToBounds = true
                })
                .disposed(by: disposeBag)

        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageView.image = nil
    }
}
