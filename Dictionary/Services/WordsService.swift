//
//  WordsService.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 20/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation
protocol WordsServiceProtocol {
    func setWordsServiceOutput(serviceOutput: WordsServiceOutput)
    func getSearchedWords(searchString: String)
    func addNewWordToDictionary(wordAsKey: String, synonyms: [String])
}

protocol WordsServiceOutput{
    func wordsResponseFromService(object: [String: [String]]?, error: Error?)
    func addWordsResponseFromService(wordIsAdded: Bool)
}

class WordsService: WordsServiceProtocol{
    private var wordsDictionary = [String: [String]]()
    private var serviceOutput: WordsServiceOutput?
    
    func getSearchedWords(searchString: String) {
        var searchWordsDictionary = [String: [String]]()
        
        searchWordsDictionary = wordsDictionary.filter{
            // check if word in dictionary contains search string
            $0.key.lowercased().contains(searchString.lowercased())
        }
        
        self.serviceOutput?.wordsResponseFromService(object: searchWordsDictionary, error: nil)
    }
    
    func setWordsServiceOutput(serviceOutput: WordsServiceOutput) {
        self.serviceOutput = serviceOutput
    }
    
    private func addAndUpdateSynonymsAsWord(_ synonyms: [String], _ wordAsKey: String, _ arrayOfNonExsistentSynonyms: inout [String], _ arrayOfExsitentSynonyms: inout [String]) {
        for  (index,syn) in synonyms.enumerated(){
            // add synonyms as words and replace synonym with word
            if wordsDictionary[syn] == nil{
                
                var newSynonyms = synonyms
                
                newSynonyms.remove(at: index)
                newSynonyms.append(wordAsKey)
                
                arrayOfNonExsistentSynonyms.append(syn)
                wordsDictionary[syn] = newSynonyms
                
            }else{
                //  append array with existing synonyms
                //add new word/key as synonym to synonym as word
                
                arrayOfExsitentSynonyms.append(syn)
                wordsDictionary[syn]?.append(wordAsKey)
            }
        }
        
        //update existed items with  words as synonyms
        for existedItem in arrayOfExsitentSynonyms{
            wordsDictionary[existedItem]?.append(contentsOf: arrayOfNonExsistentSynonyms)
        }
    }
    
    private func updateDictionaryWithMissingWords(_ arrayOfExsitentSynonyms: inout [String], _ synonyms: [String], _ wordAsKey: String, _ arrayOfNonExsistentSynonyms: [String]) {
        // Exsisting synonyms/words are already up to date and from them we can get missing words
        
        let existedItem = arrayOfExsitentSynonyms[0]
        // set new array for avoid duplicate for loop
        var synonymsDictionary = [String: String]()
        for synonym in synonyms{
            synonymsDictionary[synonym] = "synonym"
        }
        let missingWords = wordsDictionary[existedItem]?.filter{synonymsDictionary[$0] == nil}
        // new array we are using to avoid duplicates
        var modifiedMissingWordsArray = [String]()
        
        for (index,item) in missingWords!.enumerated(){
            if(item != wordAsKey){
                wordsDictionary[item]?.append(wordAsKey)
                wordsDictionary[item]?.append(contentsOf: arrayOfNonExsistentSynonyms)
            }else{
                modifiedMissingWordsArray = missingWords!
                modifiedMissingWordsArray.remove(at: index)
                wordsDictionary[item]?.append(contentsOf: modifiedMissingWordsArray)
            }
        }
        
        for noExsistedItem in arrayOfNonExsistentSynonyms{
            
            wordsDictionary[noExsistedItem]?.append(contentsOf: modifiedMissingWordsArray)
        }
    }
    
    func addNewWordToDictionary(wordAsKey: String, synonyms: [String]) {
        
        if wordsDictionary[wordAsKey] == nil{
            var arrayOfExstedSynonyms = [String]()
            var arrayOfNonExistentSynonyms = [String]()
            wordsDictionary[wordAsKey] = synonyms
            
            addAndUpdateSynonymsAsWord(synonyms, wordAsKey, &arrayOfNonExistentSynonyms, &arrayOfExstedSynonyms)
            
            // update all related words with missing synonyms
            
            if(arrayOfExstedSynonyms.count != Constants.withoutContent){
                
                updateDictionaryWithMissingWords(&arrayOfExstedSynonyms, synonyms, wordAsKey, arrayOfNonExistentSynonyms)
                
            }
            serviceOutput?.addWordsResponseFromService(wordIsAdded: true)
        }else{
            serviceOutput?.addWordsResponseFromService(wordIsAdded: false)
        }
    }
}
