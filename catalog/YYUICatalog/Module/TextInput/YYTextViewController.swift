//
//  YYTextViewController.swift
//  YYUICatalog
//
//  Created by liuxc on 2021/11/26.
//

import YYUIKit
import SnapKit

class YYTextViewController: UIViewController {
    
    lazy var textView: YYTextView = {
        let textView = YYTextView()
        textView.placeholderText = "placeholder"
        textView.backgroundColor = .yellow
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.title = "YYTextView"
        self.view.backgroundColor = .white
        print(UIApplication.safeAreaInsets())
                
                        
        self.view.addSubview(textView)
        self.textView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        YYUITips.show(withText: nil)
    }
}

extension YYTextViewController {
    
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["TextInput", "YYTextView"],
            "primaryDemo": false,
            "presentable": false,
        ]
    }
    
    @objc func catalogShouldHideNavigation() -> Bool {
        return true
    }
}
