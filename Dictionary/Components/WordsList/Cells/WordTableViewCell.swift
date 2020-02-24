//
//  TableViewCell.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 17/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit
import Darwin
import EasyTipView

class WordTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var synonymsCollectionView: UICollectionView!
    @IBOutlet weak var initialWordLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    var synonyms = [String]()
    
    var preferences = EasyTipView.Preferences()
    var navigationController: UINavigationController!
        var toolTipView: EasyTipView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.synonymsCollectionView.delegate = self
        self.synonymsCollectionView.dataSource = self
        
        let layout = synonymsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 200, height: 30)
        let synonymCellNib = UINib(nibName: "SynonymCollectionViewCell", bundle: nil)
        self.synonymsCollectionView.register(synonymCellNib, forCellWithReuseIdentifier: "SynonymCollectionViewCell")
        
        setupShadow()
        setupToolTipPreferences()

    }
    
    func setupNavigationController(navigationController: UINavigationController, word: String, synonyms: [String]){
        self.synonyms.removeAll()
        self.navigationController = navigationController
        wordLabel.text = word
        initialWordLabel.text = word.prefix(1).uppercased()
        self.synonyms.append(contentsOf: synonyms)
        self.synonymsCollectionView.reloadData()
        
    }
    
    func setupShadow() {
        
        self.cellContentView!.layer.cornerRadius = 11
        self.cellContentView!.layer.shadowOffset = CGSize(width: 0, height: 7)
        self.cellContentView.layer.shadowColor = UIColor.gray.cgColor
        self.cellContentView!.layer.shadowRadius = 5.0  // 1.0
        self.cellContentView!.layer.shadowOpacity = 0.3
        self.cellContentView!.layer.masksToBounds = false;
        self.cellContentView!.clipsToBounds = false;
        
        initialWordLabel.layer.shadowColor = UIColor.systemOrange.cgColor
        initialWordLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        initialWordLabel.layer.shadowOpacity = 0.7
        initialWordLabel.layer.shadowRadius = 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let currentCell = collectionView.cellForItem(at: indexPath) as! SynonymCollectionViewCell
        if toolTipView != nil{self.toolTipView?.dismiss()}
                   toolTipView = EasyTipView(text: "Some text", preferences: preferences)
                   toolTipView?.show(forView: currentCell)
    }
    
    func setupToolTipPreferences() {
           preferences.drawing.font = UIFont(name: "Arial", size: 13)!
           preferences.drawing.foregroundColor = UIColor.black
        preferences.drawing.backgroundColor = UIColor(named: "synonymWrapperColor")!
           
           EasyTipView.globalPreferences = preferences
       }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if toolTipView != nil{self.toolTipView?.dismiss()}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = synonymsCollectionView.dequeueReusableCell(withReuseIdentifier: "SynonymCollectionViewCell", for: indexPath as IndexPath) as! SynonymCollectionViewCell
        cell.setupCellContent(synonym: synonyms[indexPath.row])
        return cell
    }
}
