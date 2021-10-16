//
//  EditingMemoViewController.swift
//  Memo
//
//  Created by oe on 2021/10/16.
//

import Combine
import MemoCore
import SnapKit
import UIKit

/// A02 メモ編集画面
final class EditingMemoViewController: UIViewController, UITextViewDelegate {
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        return textView
    }()

    private lazy var deleteButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonDidTouchUpInside))
    }()

    private lazy var saveButton: UIBarButtonItem = {
        UIBarButtonItem(title: L10n.A02.saveButtonTitle, style: .plain, target: self, action: #selector(saveButtonDidTouchUpInside))
    }()

    private let viewModel: EditingMemoViewModel

    private var cancellables = Set<AnyCancellable>()

    init(memo: Memo?) {
        guard let viewModel = AppDelegate.assembler.resolver.resolve(EditingMemoViewModel.self, argument: memo) else {
            fatalError("failed to resolve EditingMemoViewModel.")
        }

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.A02.title

        navigationItem.rightBarButtonItems = [deleteButton, saveButton]

        view.backgroundColor = .systemBackground
        view.addSubview(bodyTextView)

        bodyTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        bodyTextView.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        viewModel.body
            .sink { [weak self] body in
                self?.bind(body: body)
            }
            .store(in: &cancellables)

        viewModel.destination
            .sink { [weak self] destination in
                self?.transitionTo(destination: destination)
            }
            .store(in: &cancellables)

        viewModel.isDeleteButtonEnabled
            .sink { [weak self] isEnabled in
                self?.deleteButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }

    // MARK: UITextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        viewModel.textViewDidChange(text: textView.text)
    }

    @objc func deleteButtonDidTouchUpInside() {
        viewModel.deleteButtonDidTouchUpInside()
    }

    @objc func saveButtonDidTouchUpInside() {
        viewModel.saveButtonDidTouchUpInside()
    }

    @objc private func keyboardDidShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        bodyTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame?.height ?? 0, right: 0)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        bodyTextView.contentInset = .zero
    }

    private func bind(body: String) {
        if bodyTextView.text != body {
            bodyTextView.text = body
        }
    }

    private func transitionTo(destination: EditingMemoDestination) {
        switch destination {
        case .pop:
            navigationController?.popViewController(animated: true)
        }
    }
}
