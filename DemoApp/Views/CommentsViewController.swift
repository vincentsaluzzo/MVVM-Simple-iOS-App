//
//  CommentsViewController.swift
//  DemoApp
//
//  Created by Vincent Saluzzo on 10/12/2018.
//  Copyright © 2018 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources

class CommentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!

    @IBOutlet weak var commentFixedToTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentFixedToSuperviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentFixedToBottomConstraint: NSLayoutConstraint!
    var viewModel: CommentsViewModeling!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDidChangeFrame(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CommentViewModeling>>(configureCell: { (_, tableView, _, comment) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
            cell?.textLabel?.text = L10n.Comment.say(comment.from)
            cell?.detailTextLabel?.text = comment.body
            return cell!
        })

        viewModel.comments.asObservable()
            .map({ comments -> [SectionModel<String, CommentViewModeling>] in
                return [SectionModel(model: "", items: comments)]
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }

    @objc func keyBoardDidChangeFrame(notification: Notification) {
        //handle dismiss of keyboard here
        guard let value = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let y = value.cgRectValue.origin.y
        let height = view.bounds.size.height
        var constraint = -(height - y)

        if constraint != 0 {
            constraint += view.safeAreaInsets.bottom
        }

        commentFixedToBottomConstraint.constant = constraint

    }

    @IBAction func tapOnSend(_ sender: Any) {
        guard let text = commentTextView.text, text.isEmpty == false else {
            return presentAlert(withTitle: L10n.Comment.EmptyMessage.title, message: L10n.Comment.EmptyMessage.body)
        }
        viewModel.postComment(body: text).asObservable()
            .subscribe(onNext: { [weak self] () in
                self?.presentAlert(withTitle: L10n.Comment.CommentPosted.title, message: L10n.Comment.CommentPosted.body)
                self?.commentTextView.resignFirstResponder()
                self?.commentTextView.text = nil
                self?.viewModel.reloadComments()
            }, onError: { [weak self] (_) in
                self?.presentAlert(withTitle: L10n.Comment.ErrorMessage.title, message: L10n.Comment.ErrorMessage.body)
            })
            .disposed(by: disposeBag)
    }
}
