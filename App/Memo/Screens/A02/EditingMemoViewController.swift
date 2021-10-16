//
//  EditingMemoViewController.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import SnapKit
import UIKit

/// A02 メモ編集画面
final class EditingMemoViewController: UIViewController {
    private lazy var bodyView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.backgroundColor = .systemBackground

        title = L10n.A02.title

        view.backgroundColor = .systemBackground
        view.addSubview(bodyView)

        bodyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        bodyView.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardDidShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        bodyView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame?.height ?? 0, right: 0)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        bodyView.contentInset = .zero
    }
}
