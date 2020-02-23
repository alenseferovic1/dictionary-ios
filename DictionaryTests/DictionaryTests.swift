//
//  DictionaryTests.swift
//  DictionaryTests
//
//  Created by Alen  Seferovic on 14/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import XCTest
@testable import Dictionary

class DictionaryTests: XCTestCase {
    
    var wordsViewModel: WordsViewModel?
    var wordsTestOutput = WordsTestOutput()
    
    override func setUp() {
        wordsViewModel = WordsViewModel.build()
        wordsViewModel?.setWordsViewModelOutput(wordsViewModelOutput: wordsTestOutput)
    }
        
    func testAddWordsToDictionary(){
        wordsViewModel?.addNewWordToDictionary(wordAsKey: "Wash", synonyms: ["Clean", "Sweep"])
        XCTAssert(wordsTestOutput.wordIsAdded == true)
    }
    
    func testSearchWordsToDictionary(){
        wordsViewModel?.addNewWordToDictionary(wordAsKey: "Wash", synonyms: ["Clean", "Sweep"])
        wordsViewModel?.getSearchedItems(searchString: "Wash")
        XCTAssert(wordsTestOutput.numberOfItems == 1)
    }
}

class WordsTestOutput: WordsViewModelOutput{
    
    var numberOfItems: Int?
    var wordIsAdded: Bool?
    
    func getSearchWordsResult(dictionary: [String : [String]]?, error: Error?) {
        numberOfItems = dictionary?.count
    }
    
    func getAddWordsResponse(wordIsAdded: Bool) {
        self.wordIsAdded = wordIsAdded
    }
}
