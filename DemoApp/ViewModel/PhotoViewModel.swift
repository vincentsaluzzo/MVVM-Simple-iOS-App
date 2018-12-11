//
//  PhotoViewModel.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation

class PhotoViewModel: PhotoViewModeling {
    var thumbnail: String
    var url: String
    var title: String

    init(_ photo: Photo) {
        thumbnail = photo.thumbnailUrl
        url = photo.url
        title = photo.title
    }

}
