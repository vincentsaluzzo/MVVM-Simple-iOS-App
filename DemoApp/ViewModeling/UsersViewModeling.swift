//
//  UsersViewModeling.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import RxSwift

protocol UsersViewModeling {
    var isLoading: BehaviorSubject<Bool> { get }
    var users: BehaviorSubject<[UserViewModeling]> { get }
}
