//
//  AppBarWithUITableViewController.swift
//  YYUICatalog
//
//  Created by liuxc on 2021/11/17.
//

import UIKit
import YYUIKit

class AppBarWithUITableViewController: UITableViewController {
    
    let appBarViewController = YYUIAppBarViewController()
    var numberOfRows = 50

    deinit {
        appBarViewController.headerView.trackingScrollView = nil
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    override init(style: UITableView.Style) {
      super.init(style: style)
      commonInit()
    }

    func commonInit() {

      // Behavioral flags.
      appBarViewController.inferTopSafeAreaInsetFromViewController = true
      appBarViewController.headerView.minMaxHeightIncludesSafeArea = false

      self.addChild(appBarViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "aaa"
                
        // Allows us to avoid forwarding events, but means we can't enable shift behaviors.
        appBarViewController.headerView.observesTrackingScrollViewScrollEvents = true
        appBarViewController.headerView.backgroundColor = .white
      appBarViewController.showsHairline = true
      appBarViewController.hairlineColor = UIColor(hexString: "#cccccc")
        
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)
        appBarViewController.headerView.trackingScrollView = tableView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.textLabel?.text = "Cell #\(indexPath.item)"
      return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      tableView.beginUpdates()
      tableView.insertRows(at: [IndexPath(item: indexPath.item+1, section: 0)], with: .automatic)
      numberOfRows += 1
      tableView.endUpdates()
        
        self.navigationItem.title = "change title"
    }
}

extension AppBarWithUITableViewController {

  @objc class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["App Bar", "AppBar+UITableViewController"],
      "primaryDemo": false,
      "presentable": false,
    ]
  }

  @objc func catalogShouldHideNavigation() -> Bool {
    return true
  }
}
