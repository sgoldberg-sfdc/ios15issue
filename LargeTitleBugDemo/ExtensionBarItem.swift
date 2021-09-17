//
//  ExtensionBarItem.swift
//  Chatter
//
//  Created by Stephen Goldberg on 9/17/21.
//  Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func truncateNavTitle() -> String {
        let maxLength = 13
        if self.utf8.count > maxLength {
            return utf8SubString(from: 0, to: maxLength - 1) + "..."
        }
        return self
    }
        
    func utf8SubString(from: Int, to: Int) -> String {
        let utf8String = self.utf8
        let startIndex = utf8String.startIndex
        let endIndex = utf8String.index(startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
    
}

/* This to place an UIView below the right bar buttom items of a navigation bar.
 Only supported when:
 - navigation bar is using large title
 - navigation bar is does not shrink on scroll up
 - all onView… functions are called, respectively to the viewController provided
 */
final class ExtensionBarItem: NSObject {
    
    private var backConstraint: NSLayoutConstraint?
    private var inPlaceConstraint: NSLayoutConstraint?
    private let itemView: UIView
    private weak var viewController: UIViewController?
    private let sidePadding = CGFloat(-(16 + 4))
    private let topPadding = CGFloat(8 + 48)
    
    @objc
    init(itemView: UIView, viewController: UIViewController) {
        itemView.alpha = 0
        self.itemView = itemView
        self.viewController = viewController
    }
    
    deinit {
        itemView.removeFromSuperview()
    }
    
    @objc
    func onViewWillLayoutSubviews() {
        
        guard let vcView = viewController?.view,
            let navBar = viewController?.navigationController?.navigationBar,
            itemView.superview == nil else {
            return
        }
        navBar.addSubview(itemView)
        if let title = viewController?.navigationItem.title {
            viewController?.navigationItem.title = title.truncateNavTitle()
        }
        itemView.clipsToBounds = true
        itemView.translatesAutoresizingMaskIntoConstraints = false
        backConstraint = itemView.trailingAnchor.constraint(equalTo: vcView.trailingAnchor, constant: sidePadding)
        inPlaceConstraint = itemView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: sidePadding)
        if let inPlaceConstraint = inPlaceConstraint {
            NSLayoutConstraint.activate([
                inPlaceConstraint,
                itemView.topAnchor.constraint(equalTo: navBar.topAnchor, constant: topPadding)])
        }
    }
    
    @objc
    func onViewWillAppear(_ animated: Bool) {
        let animation = { [weak self] in
            self?.itemView.alpha = 1
        }
        if let tc = viewController?.transitionCoordinator, animated {
            tc.animate(alongsideTransition: { _ in
                animation()
            })
        } else {
            animation()
        }
    }
    
    @objc
    func onViewWillDisappear(_ animated: Bool) {
        guard let vc = viewController, vc.presentedViewController == nil else {
            return
        }
        
        let animation = { [weak self] in
            self?.itemView.alpha = 0
        }
        let reverseAnimation = { [weak self] in
            self?.itemView.alpha = 1
        }
        if let tc = vc.transitionCoordinator, animated {
            tc.animate(alongsideTransition: { _ in
                animation()
            }, completion: { ctx in
                // An interactive pop gesture (slide to go back) leaving *from* this viewController,
                // can be cancelled, if that happens, the animation needs to be reversed.
                if ctx.isCancelled, ctx.viewController(forKey: .from) == vc {
                    reverseAnimation()
                }
            })
        } else {
            animation()
        }
        
        if let viewControllersInNav = vc.navigationController?.viewControllers {
            // This ViewController is being popped.
            let count = viewControllersInNav.count
            if !viewControllersInNav.contains(vc) {
                inPlaceConstraint?.isActive = false
                backConstraint?.isActive = true
            }
            // There's a ViewController being pushed onto this one.
            else if count > 1 && viewControllersInNav[count - 2] == vc {
                inPlaceConstraint?.isActive = true
                backConstraint?.isActive = false
            }
        }
    }
}

