//
//  ChildViewController.swift
//  LargeTitleBugDemo
//
//  Created by Stephen Goldberg on 9/17/21.
//

import UIKit

class ChildViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {

    var createButton: UIButton?
    var createButtonBarItem: ExtensionBarItem?
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchController()
        self.navigationItem.title = "Child View"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
        self.navigationItem.hidesSearchBarWhenScrolling = false;
        setupNewButton()
        createButtonBarItem?.onViewWillAppear(animated)
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

    func setupSearchController() {
        let lexSearchController = UISearchController()
        lexSearchController.delegate = self
        lexSearchController.searchBar.searchBarStyle = .minimal
        lexSearchController.searchBar.isTranslucent = false
        lexSearchController.searchBar.delegate = self
        navigationItem.searchController = lexSearchController
        
        self.searchBar = lexSearchController.searchBar;
        self.definesPresentationContext = true;
    }
    
    func setupNewButton() {
//        DispatchQueue.main.async { [self] in
            if createButton != nil {
                return
            }
            
            let createButton = UIButton(type: .system)
            NSLayoutConstraint.activate([
                                         createButton.widthAnchor.constraint(equalToConstant: 44.0),
                                         createButton.heightAnchor.constraint(equalToConstant: 33.0)
            ])

            createButton.setTitle("New", for: .normal)
            createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            createButton.accessibilityHint = "new"
            createButton.accessibilityLabel = "New object name button"
            createButton.alpha = 1
            let createButtonBarItem = ExtensionBarItem(itemView: createButton, viewController: self)
            self.createButton = createButton
            self.createButtonBarItem = createButtonBarItem
            createButtonBarItem.onViewWillLayoutSubviews()
            createButtonBarItem.onViewWillAppear(true)
 //       }
    }
}
