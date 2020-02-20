//
//  WordsService.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 18/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation
protocol WordsServiceProtocol {
    func setWordsServiceOutput(serviceOutput: ServiceOutput)
    func getSearchedWords(searchString: String)
    func addNewWordToDictionary(wordAsKey: String, synonyms: [String])
}

class WordsService: BaseService, WordsServiceProtocol{
   var wordsDictionary = [String: [String]]()
   var searchWordsDictionary = [String: [String]]()
   
    func getSearchedWords(searchString: String) {
        if let (entry) = wordsDictionary.first(where: { (key, value) -> Bool in key.lowercased().contains(searchString.lowercased()) }) {
            
            searchWordsDictionary.removeAll()
            searchWordsDictionary[entry.key] = entry.value
            
           } else {
               print("no match")
           }
        
        self.output?.responseFromService(object: searchWordsDictionary, error: nil)
    }
    
    func setWordsServiceOutput(serviceOutput: ServiceOutput) {
        self.output = serviceOutput
    }
    
      func addNewWordToDictionary(wordAsKey: String, synonyms: [String]) {
        var modifiedSynonyms = [String]()
        
        // Check if word already exists
        
    // kuca: avlija, ognjiste
        
        // basta: avlija, ognjiste
        
        if wordsDictionary[wordAsKey] == nil{
            var array = [String]()
          wordsDictionary[wordAsKey] = synonyms
    
            for  (index,syn) in synonyms.enumerated(){
                if wordsDictionary[syn] == nil{
                    // remove duplicates if they exists
                                 var newSynonyms = synonyms
                                 
                                                newSynonyms.remove(at: index)
                                                newSynonyms.append(wordAsKey)
                    
                    wordsDictionary[syn] = newSynonyms
                    modifiedSynonyms.append(syn)
                }else{
                    array.append(contentsOf: wordsDictionary[syn]!)
                    var newSynonyms = modifiedSynonyms
                                   newSynonyms.remove(at: index)
                                   newSynonyms.append(wordAsKey)
                                   wordsDictionary[syn]!.append(contentsOf: newSynonyms)
                                  
//                    for synob in wordsDictionary[syn]!{
//                        if !synonyms.contains(synob){
//                            wordsDictionary[wordAsKey]?.append(synob)
//                        }
//                    }
                                   
                    
                }
            }
        
            wordsDictionary[wordAsKey]?.append(contentsOf: array.filter { !synonyms.contains($0)})

      }
    }
}
