//
//  User.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 07/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
}

extension User {
    struct Company: Codable {
        var name: String
        var catchPhrase: String?
        var bs: String?
    }
}

extension User {
    struct Address: Codable {
        var street: String?
        var suite: String?
        var city: String?
        var zipCode: String?
    }
}

extension User.Address {
    struct Geolocation: Codable {
        var latitude: String
        var longitude: String

        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}
