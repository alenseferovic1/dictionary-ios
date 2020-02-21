//
//  AddWordViewController.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 16/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit
import Hashtags

protocol AddWordsDelegate {
    func addWords(word: String, synonyms: [String])
}


class AddWordViewController: UIViewController, HashtagViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
    
    struct Constants {
        static let minCharsForInput = 3
        static let maxCharsForInput = 30
    }
    
    @IBOutlet weak var addWordsWrapper: UIView!
    @IBOutlet weak var addTagButton: UIButton!
    
    @IBOutlet weak var addWordsButton: UIButton!
    
    var heightConstraint: NSLayoutConstraint?
    
    var addWordsDelegate: AddWordsDelegate?
    
    
    @IBOutlet weak var addNewWordButton: UIButton!
    
    let addSynonymField = MyMultilineTextField(placeholder: "Enter new synonym")
    let addWordField = MyMultilineTextField(placeholder: "Enter new word")
    
    var addedTags = [String]()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemOrange
        return v
    }()
    
    lazy var hashtags: HashtagView = {
        let hashtags = HashtagView(frame: CGRect(x: 0, y: 0, width: 0, height: 70.0))
        hashtags.cornerRadius = 5.0
        hashtags.tagCornerRadius = 5.0
        hashtags.backgroundColor = UIColor.clear
        hashtags.tagBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        hashtags.tagTextColor = UIColor.black
        return hashtags
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBackButton(delegate: self)
        setupContentView()
        
        addWordsWrapper.addSubview(addWordField)
        setupConstrainsForField(view: addWordField, equalView: addWordsWrapper, topAnchorConstant: 20.0, leadingAnchorConstant: 20.0, traillingAnchorConstant: -20.0)
        addWordsWrapper.addSubview(addSynonymField)
        setupConstrainsForField(view: addSynonymField, equalView: addWordField, topAnchorConstant: 70.0, leadingAnchorConstant: 20.0, traillingAnchorConstant: -130.0)
    }
    
    
    @IBAction func addNewWordsAction(_ sender: Any) {
        var synonyms = [String]()
        
        for tag in hashtags.hashtags{
            synonyms.append(tag.text)
        }
        
        addWordsDelegate?.addWords(word: addWordField.text!, synonyms: synonyms)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupConstrainsForField(view: UIView, equalView: UIView, topAnchorConstant: CGFloat, leadingAnchorConstant: CGFloat, traillingAnchorConstant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: addWordsWrapper.leadingAnchor, constant: leadingAnchorConstant).isActive = true
        view.trailingAnchor.constraint(equalTo: addWordsWrapper.trailingAnchor, constant: traillingAnchorConstant).isActive = true
        view.topAnchor.constraint(equalTo: equalView.topAnchor, constant: topAnchorConstant).isActive = true
    }
    
    @IBAction func addSynonym(_ sender: Any) {
        let hashtag = HashTag(word: addSynonymField.text!, withHashSymbol: false, isRemovable: true)
        if addSynonymField.text != "" && !addedTags.contains(addSynonymField.text!){
            
            addedTags.append(addSynonymField.text!)
            hashtags.addTag(tag: hashtag)
        }else{
            let alert = UIAlertController(title: "Duplicate synonym", message: "Synonym already exists.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        scrollView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        scrollView.contentSize = CGSize(width: 100, height: hashtags.frame.size.height - 10)
        addSynonymField.text = ""
    }
    
    func setupContentView() {
        addTagButton.layer.cornerRadius = 5
        addWordsButton.layer.cornerRadius = 5
        addWordsWrapper.clipsToBounds = true
        addWordsWrapper.layer.cornerRadius = 20
        addWordsWrapper.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.hashtags.delegate = self
        self.scrollView.delegate = self
        
        self.addWordsWrapper.addSubview(scrollView)
        self.scrollView.addSubview(self.hashtags)
        
        scrollView.leftAnchor.constraint(equalTo: addWordsWrapper.leftAnchor, constant: 20.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: addWordsWrapper.topAnchor, constant: 155.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: addWordsWrapper.rightAnchor, constant: -20.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: addWordsWrapper.bottomAnchor, constant: -70.0).isActive = true
        
        self.hashtags.translatesAutoresizingMaskIntoConstraints = false
        self.hashtags.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        self.hashtags.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240.0).isActive = true
        
        self.heightConstraint = self.hashtags.heightAnchor.constraint(equalToConstant: 50.0)
        self.heightConstraint?.isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if text.count >= Constants.minCharsForInput {
            let hashtag = HashTag(word: textField.text!, withHashSymbol: false, isRemovable: true)
            hashtags.addTag(tag: hashtag)
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= Constants.maxCharsForInput
    }
    
    @objc
    func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.count >= Constants.minCharsForInput {
            self.addTagButton.isEnabled = true
        } else {
            self.addTagButton.isEnabled = false
        }
    }
    
    func hashtagRemoved(hashtag: HashTag) {
        print("Item has removed")
    }
    
    func viewShouldResizeTo(size: CGSize) {
        guard let constraint = self.heightConstraint else {
            return
        }
        constraint.constant = size.height
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            
            let hashtag = HashTag(word: "", withHashSymbol: false, isRemovable: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {         self.hashtags.addTag(tag: hashtag)
                self.hashtags.removeTag(tag: hashtag)
            }
        }
    }
}
