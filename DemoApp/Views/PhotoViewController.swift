//
//  PhotoViewController.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var viewModel: PhotoViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: URL(string: viewModel.url))
        titleLabel.text = viewModel.title
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
    }

    @IBAction func tapOnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
