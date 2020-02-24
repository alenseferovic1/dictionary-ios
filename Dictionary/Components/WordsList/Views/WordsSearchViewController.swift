//
//  ViewController.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 17/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit

protocol WordSearchDelegate {
    func closeAddWordsControllerOnSuccess(wordIsAdded: Bool)
}

class WordsSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, WordsViewModelOutput, AddWordsDelegate {

    @IBOutlet weak var wordsSearchBar: UISearchBar!
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    @IBOutlet weak var noMachesLabel: UILabel!
    
    @IBOutlet weak var searchIcon: UIImageView!
    
    var wordsViewModel: WordsViewModelProtocol?
    
    var wordSearchDelegate: WordSearchDelegate?
    
    var dictionary = [String: [String]]()
    
    @IBOutlet weak var searchIconTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchIconConstraints()
        setupNavBarPlusIcon(delegate: self)
        wordsTableView.isHidden = true
        noMachesLabel.isHidden = true
        
        self.wordsTableView.delegate = self
        self.wordsTableView.dataSource = self
        self.wordsSearchBar.delegate = self
        
        wordsViewModel = WordsViewModel.build()
        wordsViewModel?.setWordsViewModelOutput(wordsViewModelOutput: self)
        
        let wordCellNib = UINib(nibName: "WordTableViewCell", bundle: nil)
        self.wordsTableView.register(wordCellNib, forCellReuseIdentifier: "WordTableViewCell")
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.text!.isEmpty && dictionary.count == Constants.withoutContent  {
            noMachesLabel.isHidden = false
        }else{
           noMachesLabel.isHidden = true
        }
        wordsViewModel?.getSearchedItems(searchString: searchBar.text!)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionary.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath as IndexPath) as! WordTableViewCell
        cell.setupNavigationController(navigationController: navigationController!, word: Array(dictionary)[indexPath.section].key, synonyms: Array(dictionary)[indexPath.section].value)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.wordCellHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.heightForHeaderInSection)
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func getSearchWordsResult(dictionary: [String : [String]]?, error: Error?) {
        
        self.dictionary = dictionary!
        if dictionary?.count != Constants.withoutContent{
        wordsTableView.isHidden = false
        }else{
          wordsTableView.isHidden = true
        }
        wordsTableView.reloadData()
        
    }
    
    private func setSearchIconConstraints() {
        if UIDevice.current.orientation.isPortrait {
            
            searchIconTopConstraint.constant = CGFloat(Constants.searchImagePortraitModeTopConstraint)
        }else{
            searchIconTopConstraint.constant = CGFloat(Constants.searchImageLandscapeModeTopConstraint)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setSearchIconConstraints()
    }
    
    func addWords(word: String, synonyms: [String], wordSearchDelegate: WordSearchDelegate) {
        self.wordSearchDelegate = wordSearchDelegate
        wordsViewModel!.addNewWordToDictionary(wordAsKey: word, synonyms: synonyms)
    }
    
    func getAddWordsResponse(wordIsAdded: Bool) {
        wordSearchDelegate?.closeAddWordsControllerOnSuccess(wordIsAdded: wordIsAdded)
    }
}

