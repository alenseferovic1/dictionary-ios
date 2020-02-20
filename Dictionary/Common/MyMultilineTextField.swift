//
//  MyMultilineTextField.swift
//  Dictionary
//
//  Created by Alen  Seferovic on 17/02/2020.
//  Copyright © 2020 Alen  Seferovic. All rights reserved.
//

import Foundation
import MaterialComponents.MDCMultilineTextField

class MyMultilineTextField: MDCTextField {

    private var controller: MDCTextInputControllerFilled?
    private var placeholderText: String

    init(placeholder: String) {
        self.placeholderText = placeholder

        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {

        translatesAutoresizingMaskIntoConstraints = false
        clearButtonMode = .whileEditing
        controller = MDCTextInputControllerFilled(textInput: self)
        controller?.placeholderText = placeholderText
        controller?.borderFillColor = UIColor.gray.withAlphaComponent(0.3)
        controller?.activeColor = UIColor.black.withAlphaComponent(0.5)
        controller?.normalColor = UIColor.black.withAlphaComponent(0.3)
        controller?.floatingPlaceholderNormalColor = UIColor.black.withAlphaComponent(0.3)
             controller?.inlinePlaceholderColor = UIColor.black.withAlphaComponent(0.3)
        controller?.floatingPlaceholderActiveColor = UIColor.black.withAlphaComponent(0.5)
    }
}
