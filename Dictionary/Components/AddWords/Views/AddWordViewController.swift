//
//  AddWordViewController.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 19/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit
import Hashtags

protocol AddWordsDelegate {
    func addWords(word: String, synonyms: [String], wordSearchDelegate: WordSearchDelegate)
}

class AddWordViewController: UIViewController, HashtagViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, WordSearchDelegate {

    @IBOutlet weak var addWordsWrapper: UIView!
    
    @IBOutlet weak var addTagButton: UIButton!
    
    @IBOutlet weak var addWordsButton: UIButton!
    
    @IBOutlet weak var addNewWordButton: UIButton!
    
    private var heightConstraint: NSLayoutConstraint?
    
    var addWordsDelegate: AddWordsDelegate?
    
    private let addSynonymField = MyMultilineTextField(placeholder: NSLocalizedString("enter_synonym", comment: ""))
    private let addWordField = MyMultilineTextField(placeholder: NSLocalizedString("enter_word", comment: ""))
    
    private var addedTags = [String]()
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemOrange
        return v
    }()
    // synoynms wrapper view
    lazy var tags: HashtagView = {
        let tags = HashtagView(frame: CGRect(x: 0, y: 0, width: 0, height: Constants.hashTagViewHeight))
        tags.cornerRadius = CGFloat(Constants.cornerButtonRadius)
        tags.tagCornerRadius = CGFloat(Constants.cornerButtonRadius)
        tags.backgroundColor = UIColor.clear
        tags.tagBackgroundColor = UIColor.gray.withAlphaComponent(CGFloat(Constants.alphaSynonymsWraperBackgroundColor))
        tags.tagTextColor = UIColor.black
        return tags
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBackButton(delegate: self)
        setupContentView()
        
        // add material design components programatically
        addWordsWrapper.addSubview(addWordField)
        setupConstrainsForField(view: addWordField, equalView: addWordsWrapper, topAnchorConstant: 20.0, leadingAnchorConstant: 20.0, traillingAnchorConstant: -20.0)
        addWordsWrapper.addSubview(addSynonymField)
        setupConstrainsForField(view: addSynonymField, equalView: addWordField, topAnchorConstant: 70.0, leadingAnchorConstant: 20.0, traillingAnchorConstant: -130.0)
    }
    
    
    @IBAction func addNewWordsAction(_ sender: Any) {
        var synonyms = [String]()
        
        for tag in tags.hashtags{
            synonyms.append(tag.text)
        }
        
        addWordsDelegate?.addWords(word: addWordField.text!, synonyms: synonyms, wordSearchDelegate: self)
    }
    
    private func setupConstrainsForField(view: UIView, equalView: UIView, topAnchorConstant: CGFloat, leadingAnchorConstant: CGFloat, traillingAnchorConstant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: addWordsWrapper.leadingAnchor, constant: leadingAnchorConstant).isActive = true
        view.trailingAnchor.constraint(equalTo: addWordsWrapper.trailingAnchor, constant: traillingAnchorConstant).isActive = true
        view.topAnchor.constraint(equalTo: equalView.topAnchor, constant: topAnchorConstant).isActive = true
    }
    
    @IBAction func addSynonym(_ sender: Any) {
        let hashtag = HashTag(word: addSynonymField.text!, withHashSymbol: false, isRemovable: true)
        if addSynonymField.text != "" && !addedTags.contains(addSynonymField.text!){
            
            addedTags.append(addSynonymField.text!)
            tags.addTag(tag: hashtag)
        }else{
            showAlertDialog(title: NSLocalizedString("add_synonym_duplicate_title", comment: ""), message: NSLocalizedString("add_synoynm_duplicate_message", comment: ""))
        }
        scrollView.backgroundColor = UIColor.gray.withAlphaComponent(CGFloat(Constants.scrollViewAlphaBackgroundColor))
        scrollView.contentSize = CGSize(width: 100, height: tags.frame.size.height - 10)
        addSynonymField.text = ""
    }
    
     private func addConstrainsToScrollViewAndHashtags() {
        scrollView.leftAnchor.constraint(equalTo: addWordsWrapper.leftAnchor, constant: 20.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: addWordsWrapper.topAnchor, constant: 155.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: addWordsWrapper.rightAnchor, constant: -20.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: addWordsWrapper.bottomAnchor, constant: -70.0).isActive = true
        
        tags.translatesAutoresizingMaskIntoConstraints = false
        tags.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        tags.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240.0).isActive = true
    }
    
    private func setupContentView() {
        addTagButton.layer.cornerRadius = CGFloat(Constants.cornerButtonRadius)
        addWordsButton.layer.cornerRadius = CGFloat(Constants.cornerButtonRadius)
        addWordsWrapper.clipsToBounds = true
        addWordsWrapper.layer.cornerRadius = CGFloat(Constants.cornerWrapperRadius)
        addWordsWrapper.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.tags.delegate = self
        self.scrollView.delegate = self
        // add scroll view programatically
        self.addWordsWrapper.addSubview(scrollView)
        //add tags wrapper programatically
        self.scrollView.addSubview(self.tags)
        
        addConstrainsToScrollViewAndHashtags()
        
        self.heightConstraint = self.tags.heightAnchor.constraint(equalToConstant: 50.0)
        self.heightConstraint?.isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if text.count >= Constants.minCharsForInput {
            let hashtag = HashTag(word: textField.text!, withHashSymbol: false, isRemovable: true)
            tags.addTag(tag: hashtag)
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? Constants.withoutContent
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
        
        UIView.animate(withDuration: Constants.durationTimeOfAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            
            let hashtag = HashTag(word: "", withHashSymbol: false, isRemovable: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayTime) {         self.tags.addTag(tag: hashtag)
                self.tags.removeTag(tag: hashtag)
            }
        }
    }
    
     func closeAddWordsControllerOnSuccess(wordIsAdded: Bool) {
        if wordIsAdded{
            self.navigationController?.popViewController(animated: true)
        }else{
            
            showAlertDialog(title: NSLocalizedString("add_word_duplicate_title", comment: ""), message: NSLocalizedString("add_word_duplicate_message", comment: ""))
        }
    }
    
    private func showAlertDialog(title: String, message: String) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
}
