//
//  BaseService.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 18/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation

protocol ServiceOutput {
    func responseFromService(object: [String: [String]]?, error: Error?)
}

class BaseService {
    static var BASE_URL:  String = ""
    var output: ServiceOutput?
    
}
