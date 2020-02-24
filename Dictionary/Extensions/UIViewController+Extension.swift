//
//  UIViewController+Extension.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 17/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func setupNavBarPlusIcon(delegate: AddWordsDelegate) {
        let color = UIColor.white
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "plus")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black
        let tapGesture = CustomTapGestureRecognizer(target: self,
                                                    action: #selector(tapSelector(sender:)))
        tapGesture.ourCustomValue = delegate
                
        button.addGestureRecognizer(tapGesture)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    func setNavBackButton(delegate: UIGestureRecognizerDelegate){
        let backButton = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: navigationController,
                                            action: #selector(UINavigationController.popViewController(animated:)))
           backButton.tintColor = UIColor.black
           navigationItem.leftBarButtonItem = backButton
           navigationController?.interactivePopGestureRecognizer?.delegate = delegate
    }
    
    @objc func goToAddWordScreen(){
        let story = UIStoryboard(name: "Main", bundle: nil)
                   let addWordViewController = story.instantiateViewController(withIdentifier: "AddWordViewController") as! AddWordViewController
            self.navigationController?.pushViewController(addWordViewController, animated: true)
    }
    
    @objc
    func tapSelector(sender: CustomTapGestureRecognizer) {
           let story = UIStoryboard(name: "Main", bundle: nil)
                       let addWordViewController = story.instantiateViewController(withIdentifier: "AddWordViewController") as! AddWordViewController
                addWordViewController.addWordsDelegate = sender.ourCustomValue
                self.navigationController?.pushViewController(addWordViewController, animated: true)
    }
    
    func setupNavBarTitle(title: String) {
           let screenSize: CGRect = UIScreen.main.bounds
           let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 60))
           myView.backgroundColor = .white
           self.view.addSubview(myView)
           
           let titleLabel = PaddingLabel(withInsets: 8, 8, 30, 18)
           titleLabel.frame = CGRect(x: 28, y: 8, width: UIScreen.main.bounds.size.width-28, height: 30)
           titleLabel.font = UIFont(name: "Avenir-Black", size: 35)
           titleLabel.textColor = UIColor.black
           self.view.addSubview(titleLabel)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.text = title
       }
    
}

class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var ourCustomValue: AddWordsDelegate?
}
