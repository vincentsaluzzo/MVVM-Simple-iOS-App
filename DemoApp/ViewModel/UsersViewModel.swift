//
//  UsersViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import Moya

class UsersViewModel: UsersViewModeling {
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var users: BehaviorSubject<[UserViewModeling]> = BehaviorSubject(value: [])

    let provider = MoyaProvider<UserAPI>()
    let disposeBag = DisposeBag()
    init() {
        provider.rx.request(UserAPI.getUsers)
            .filterSuccessfulStatusCodes()
            .map([User].self)
            .debug("getUsers", trimOutput: false)
            .subscribe({ [weak self] (element) in
                switch element {
                case .success(let users):
                    self?.users.onNext(users.map({ UserViewModel($0) }))
                    self?.isLoading.onNext(false)
                case .error:
                    self?.isLoading.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
