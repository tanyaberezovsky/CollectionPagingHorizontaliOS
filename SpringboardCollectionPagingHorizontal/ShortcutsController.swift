//
//  ViewController.swift
//  SpringboardCollectionPagingHorizontal
//
//  Created by Tanya Berezovsky on 25/02/2019.
//  Copyright © 2019 Tanya Berezovsky. All rights reserved.
//

import UIKit

class ShortcutsController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    lazy var shortcutViewController: ShortcutsViewController = {
        return ShortcutsViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // shortcutViewController = ShortcutsViewController(viewModel: ShortcutsViewController.ViewModel(rawdata: ShortcutsModelControler().data, pageSize: containerView.frame.size))
        addContentController(shortcutViewController, toView: containerView)
    }
    
    func addContentController(_ chield: UIViewController, toView containerView: UIView) {
        // call before adding child view controller's view as subview
        addChild(chield)
        
        chield.view.frame = containerView.bounds
        containerView.addSubview(chield.view)
        
        // call before adding child view controller's view as subview
        chield.didMove(toParent: self)
    }
        var firstTimeRun = true
        override func viewDidLayoutSubviews() {
            if firstTimeRun {
                firstTimeRun = false
                shortcutViewController.viewModel = ShortcutsViewController.ViewModel(rawdata: ShortcutsModelControler().data, pageSize: containerView.frame.size)
                //self.loadDataFromViewModel()
            }
        }
}

struct Shortcuts {
    var cellValue: String
    var isHidden: Bool
}
// private var data: [Int] = Array(0..<10)
class ShortcutsModelControler {
    public var data = [Shortcuts]()
    
    init() {
        (0...34).forEach {
            data.append(Shortcuts(cellValue: "\($0)", isHidden: false))
            
        }
        
    }
    
}
