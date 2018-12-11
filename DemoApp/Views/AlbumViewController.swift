//
//  AlbumViewController.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class AlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AlbumViewModeling!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PhotoViewModeling>>(configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCollectionViewCell.self)
            cell.viewModel = item
            return cell

        })

        viewModel.photos.asObservable()
            .debug("bite")
            .map { photos -> [SectionModel<String, PhotoViewModeling>] in
                return [SectionModel(model: "", items: photos)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.delegate = self

        collectionView.rx.modelSelected(PhotoViewModeling.self)
            .asDriver()
            .drive(onNext: selectPhoto)
            .disposed(by: disposeBag)
    }

    func selectPhoto(_ photo: PhotoViewModeling) {
        perform(segue: StoryboardSegue.Main.showPhoto, sender: photo)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == StoryboardSegue.Main.showPhoto.rawValue,
            let viewModel: PhotoViewModeling = sender as? PhotoViewModeling,
            let viewController: PhotoViewController = segue.destination as? PhotoViewController else {
            return
        }

        viewController.viewModel = viewModel

    }
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.bounds.size.width - 3.0) / 4.0
        return CGSize(width: size, height: size)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

class PhotoCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var imageView: UIImageView!
    var disposeBag = DisposeBag()
    var viewModel: PhotoViewModeling? {
        didSet {
            guard let viewModel = viewModel else { return }
            imageView.kf.setImage(with: URL(string: viewModel.url)!)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageView.image = nil
    }
}
