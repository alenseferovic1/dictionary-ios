//
//  WordsViewModel.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 18/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation

protocol WordsViewModelOutput {
    func getSearchWordsResult(dictionary: [String : [String]]?, error: Error?)
}

protocol WordsViewModelProtocol {
    func getSearchedItems(searchString: String)
    func addNewWordToDictionary(wordAsKey: String, synonyms: [String])
    func setWordsViewModelOutput(wordsViewModelOutput: WordsViewModelOutput)
}


class WordsViewModel: WordsViewModelProtocol, ServiceOutput{

    var wordsService: WordsServiceProtocol
    var wordsViewModelOutput: WordsViewModelOutput?
    
    init(service: WordsServiceProtocol){
          wordsService = service
          wordsService.setWordsServiceOutput(serviceOutput: self)
      }
    
    static func build() -> WordsViewModel {
          return WordsViewModel(service: WordsService())
      }
    
    func getSearchedItems(searchString: String) {
        wordsService.getSearchedWords(searchString: searchString)
    }
    
    func responseFromService(object: [String : [String]]?, error: Error?) {
        wordsViewModelOutput?.getSearchWordsResult(dictionary: object, error: nil)
    }
    
    func setWordsViewModelOutput(wordsViewModelOutput: WordsViewModelOutput) {
        self.wordsViewModelOutput = wordsViewModelOutput
    }
    
    func addNewWordToDictionary(wordAsKey: String, synonyms: [String]) {
        wordsService.addNewWordToDictionary(wordAsKey: wordAsKey, synonyms: synonyms)
    }
}


