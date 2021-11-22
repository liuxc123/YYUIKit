//
//  BottomSheetShapedExample.swift
//  YYUICatalog
//
//  Created by liuxc on 2021/11/22.
//

import UIKit
import YYUIKit

class BottomSheetShapedExample: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.title = "BottomSheetShaped"
        self.view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let viewController = BottomSheetDummyCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        viewController.view.backgroundColor = UIColor.yellow
        viewController.title = "Shaped bottom sheet example"
        
        let container = YYUIAppBarContainerViewController(contentViewController: viewController)
        container.appBarViewController.headerView.trackingScrollView = viewController.collectionView;
        container.preferredContentSize = CGSize(width: 500, height: 200)
        container.isTopLayoutGuideAdjustmentEnabled = true
        
        container.appBarViewController.headerView.backgroundColor = .blue
        container.appBarViewController.navigationBar.backgroundColor = .blue
        container.appBarViewController.navigationBar.tintColor = .white
        container.appBarViewController.navigationBar.barTintColor = .blue
        container.appBarViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let bottomSheet = YYUIBottomSheetController(contentViewController: container)
        bottomSheet.trackingScrollView = viewController.collectionView
        bottomSheet.dismissOnDraggingDownSheet = false
        
        let shapeGenerator = YYUIRectangleShapeGenerator()
        let cornerTreatment = YYUIRoundedCornerTreatment(radius: 16)
        shapeGenerator.topLeftCorner = cornerTreatment
        shapeGenerator.topRightCorner = cornerTreatment
        bottomSheet.setShapeGenerator(shapeGenerator, for: .preferred)
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
}

extension BottomSheetShapedExample {
    
    @objc class func catalogMetadata() -> [String: Any] {
        return [
            "breadcrumbs": ["Bottom Sheet", "BottomSheetShaped"],
            "primaryDemo": false,
            "presentable": false,
        ]
    }
    
    @objc func catalogShouldHideNavigation() -> Bool {
        return true
    }
}

class BottomSheetDummyCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.collectionView.backgroundColor = .white
        self.collectionView.isAccessibilityElement = true
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumInteritemSpacing = 0;
        layout?.minimumLineSpacing = 0;
        layout?.itemSize = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = UIColor(white: (CGFloat(indexPath.row % 2) * 0.2 + 0.8), alpha: 1.0)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}
