//
//  TextInputDemoViewController.swift
//  YYUICatalog
//
//  Created by liuxc on 2021/12/1.
//

import YYUIKit
import SnapKit

class TextInputDemoViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.snp.makeConstraints({ $0.height.greaterThanOrEqualTo(50)})
        return searchBar
    }()
    
    lazy var searchBarExcutor: YYUISearchBarExecutor = {
        let executor = YYUISearchBarExecutor(searchBar: searchBar, delegate: nil)
        executor.wordLimit = 10
        return executor
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .yellow
        textField.placeholder = "UITextField"
        textField.snp.makeConstraints({ $0.height.equalTo(50) })
        return textField  
    }()

    lazy var textFieldExcutor: YYUITextFieldExecutor = {
        let executor = YYUITextFieldExecutor(textField: textField, delegate: nil)
        executor.wordLimit = 10
        return executor
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .yellow
        textView.isScrollEnabled = false
        textView.snp.makeConstraints({ $0.height.greaterThanOrEqualTo(50) })
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var textViewExcutor: YYUITextViewExecutor = {
        let executor = YYUITextViewExecutor(textView: textView, delegate: nil)
        executor.wordLimit = 10
        return executor
    }()
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTextInput()
    }
    
    func setupUI() {
        self.navigationItem.title = "TextInputDemo"
        self.view.backgroundColor = .white

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(textView)

        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(100)
        }
    }
    
    func setupTextInput() {
        self.textFieldExcutor.wordLimit = 10
        self.textFieldExcutor.emojiLimit = true

        self.textViewExcutor.wordLimit = 10
        self.textViewExcutor.emojiLimit = true

        self.searchBarExcutor.wordLimit = 10
        self.searchBarExcutor.emojiLimit = true
    }
    
}


extension TextInputDemoViewController {
    
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["TextInput", "TextInputDemo"],
            "primaryDemo": false,
            "presentable": false,
        ]
    }
    
    @objc func catalogShouldHideNavigation() -> Bool {
        return true
    }
}
