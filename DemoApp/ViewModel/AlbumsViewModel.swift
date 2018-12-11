//
//  AlbumsViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class AlbumsViewModel: AlbumsViewModeling {
    var loading: BehaviorSubject<Bool>
    var albums: BehaviorSubject<[AlbumViewModeling]>

    let disposeBag = DisposeBag()
    let provider = MoyaProvider<UserAPI>()

    init(_ user: User) {
        loading = BehaviorSubject(value: true)
        albums = BehaviorSubject(value: [])

        provider.rx.request(.getAlbums(user.id))
            .filterSuccessfulStatusCodes()
            .map([Album].self)
            .debug("getAlbums(\(user.id))", trimOutput: false)
            .asDriver(onErrorJustReturn: [])
            .map { $0.map { AlbumViewModel($0) } }
            .do(onCompleted: { [weak self] in
                self?.loading.onNext(false)
            })
            .drive(onNext: { [weak self] (albums) in
                self?.albums.onNext(albums)
            })
            .disposed(by: disposeBag)
    }
}
