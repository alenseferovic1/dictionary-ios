//
//  SynonymCollectionViewCell.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 15/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import UIKit

class SynonymCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synonymCell: UIView!
    
    var navigationController: UINavigationController?

    override func awakeFromNib() {
        super.awakeFromNib()
         self.synonymCell!.layer.cornerRadius = 11
    }
    
    func setupCellContent(synonym: String){
        titleLabel.text = synonym
    }
}
