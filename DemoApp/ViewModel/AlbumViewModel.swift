//
//  AlbumViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class AlbumViewModel: AlbumViewModeling {
    var loading: BehaviorSubject<Bool>
    var photos: BehaviorSubject<[PhotoViewModeling]>
    var title: String

    let provider = MoyaProvider<AlbumAPI>()
    let disposeBag = DisposeBag()

    init(_ album: Album) {
        title = album.title
        photos = BehaviorSubject(value: [])
        loading = BehaviorSubject(value: true)

        provider.rx.request(.getPhotos(album.id))
            .filterSuccessfulStatusAndRedirectCodes()
            .map([Photo].self)
            .debug("getPhotos(\(album.id))", trimOutput: false)
            .asDriver(onErrorJustReturn: [])
            .map { $0.map { PhotoViewModel($0) } }
            .do(onCompleted: { [weak self] in
                self?.loading.onNext(false)
            })
            .drive(onNext: { [weak self] (photos) in
                self?.photos.onNext(photos)
            })
            .disposed(by: disposeBag)
    }

}
