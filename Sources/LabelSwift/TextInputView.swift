//
//  TextInputView.swift
//  LabelSwift
//
//  Created by Shadhin Music on 21/8/25.
//

import UIKit

public class TextInputView: UIView, UITextFieldDelegate {
    
    private let label = UILabel()
    private let textField = UITextField()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Label setup
        label.text = "Enter text below 👇"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // TextField setup
        textField.borderStyle = .roundedRect
        textField.placeholder = "Type something..."
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(label)
        addSubview(textField)
        
        // Constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    // UITextFieldDelegate method
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        label.text = textField.text
    }
}
