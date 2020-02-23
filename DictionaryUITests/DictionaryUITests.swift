//
//  DictionaryUITests.swift
//  DictionaryUITests
//
//  Created by Alen  Seferovic on 14/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import XCTest

class DictionaryUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAddWords(){
        
        let app = XCUIApplication()
        app.launch()
        
        let plusButton = app.navigationBars["Dictionary.View"].buttons["plus"]
        let addWordField = app.textFields["Enter new word"]
        let addSynonymButton = app.buttons["Add Synonym"]
        let addWordsButton = app.buttons["Add Words"]
        
        XCTAssertTrue(plusButton.exists)
        plusButton.tap()
        
        XCTAssertTrue(addWordField.exists)
        addWordField.tap()
        addWordField.typeText("Wash")
        
        let enterNewSynonymTextField = app.textFields["Enter new synonym"]
        XCTAssertTrue(enterNewSynonymTextField.exists)
        enterNewSynonymTextField.tap()
        // make sure to set hardware -> keyboard -> connect hardware keyboard to NO
        enterNewSynonymTextField.typeText("Clean")
        
        addSynonymButton.tap()
        addWordsButton.forceTapElement()
    }
    
    func testSearch(){
        
        let app = XCUIApplication()
         app.launch()
        
        let noWordMatchesLabel =   app.staticTexts["No word maches"]
        let searchField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("W")
        
        XCTAssertTrue(searchField.exists)
        noWordMatchesLabel.tap()
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
