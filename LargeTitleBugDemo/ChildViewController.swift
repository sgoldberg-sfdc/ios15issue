//
//  ChildViewController.swift
//  LargeTitleBugDemo
//
//  Created by Stephen Goldberg on 9/17/21.
//

import UIKit

class ChildViewController: UIViewController {

    var createButton: UIButton?
    var createButtonBarItem: ExtensionBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Child View"
        setupNewButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createButtonBarItem?.onViewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createButtonBarItem?.onViewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        createButtonBarItem?.onViewWillDisappear(animated)
        createButton?.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupNewButton() {
        if createButton != nil {
            return
        }
        
        let createButton = UIButton(type: .system)
        NSLayoutConstraint.activate([
                                     createButton.widthAnchor.constraint(equalToConstant: 44.0),
                                     createButton.heightAnchor.constraint(equalToConstant: 33.0)
        ])

        createButton.setTitle("New", for: .normal)
        //    self.createButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
        createButtonBarItem = ExtensionBarItem(itemView: createButton, viewController: self)
        createButtonBarItem?.onViewWillLayoutSubviews()
        createButtonBarItem?.onViewWillAppear(true)
        self.createButton = createButton
    }
}
