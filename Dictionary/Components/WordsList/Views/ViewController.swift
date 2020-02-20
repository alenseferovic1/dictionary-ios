//
//  ViewController.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 14/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, WordsViewModelOutput {
    

    @IBOutlet weak var wordsSearchBar: UISearchBar!
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    @IBOutlet weak var noMachesLabel: UILabel!
    
    @IBOutlet weak var searchIcon: UIImageView!
    
    var wordsViewModel: WordsViewModelProtocol?
    var dictionary = [String: [String]]()

    @IBOutlet weak var searchIconTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchIconConstraints()
        setupNavBarPlusIcon()
        wordsTableView.isHidden = true
        noMachesLabel.isHidden = true
        self.wordsTableView.delegate = self
        self.wordsTableView.dataSource = self
        
        wordsViewModel = WordsViewModel.build()
        
        let wordCellNib = UINib(nibName: "WordTableViewCell", bundle: nil)
        self.wordsTableView.register(wordCellNib, forCellReuseIdentifier: "WordTableViewCell")
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
    return 10
       }

       // There is just one row in every section
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath as IndexPath) as! WordTableViewCell
        cell.setupNavigationController(navigationController: navigationController!)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 15
     }

     // Make the background color show through
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView()
         headerView.backgroundColor = UIColor.clear
         return headerView
     }
    
    func getSearchWordsResult(dictionary: [String : [String]]?, error: Error?) {
        self.dictionary = dictionary!
    }
    
    fileprivate func setSearchIconConstraints() {
        if UIDevice.current.orientation.isPortrait {
            
            searchIconTopConstraint.constant = 150
        }else{
            searchIconTopConstraint.constant = 15
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        setSearchIconConstraints()
}
}

