//
//  TextTypingViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/28/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class TextTypingViewController: UIViewController {

    let textView: UITextView = {
       let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 26)
        v.textAlignment = .center
        v.becomeFirstResponder()
        return v
    }()
    @objc func handleLeftAlignment() {
        textView.textAlignment = .left
    }
    lazy var leftButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
        b.addTarget(self, action: #selector(handleLeftAlignment), for: .touchUpInside)
        return b
    }()
    @objc func hanldleRightAlignment() {
        textView.textAlignment = .right
    }
    lazy var  rightButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "text.alignright"), for: .normal)
          b.addTarget(self, action: #selector(hanldleRightAlignment), for: .touchUpInside)
        return b
    }()
    @objc func handleCenterAlignment() {
        textView.textAlignment = .center
    }
    
    lazy var  middleButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "text.justify"), for: .normal)
             b.addTarget(self, action: #selector(handleCenterAlignment), for: .touchUpInside)
        return b
    }()
    
    lazy var  horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(self.leftButton)
        stack.addArrangedSubview(self.middleButton)
        stack.addArrangedSubview(self.rightButton)
        
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 40
        return stack
    }()
    
    @objc func handleDone() {
        print("Hello")
         dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }

        
    @objc func handleCheck() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        navigationItem.title = "Hello"
        
        view.backgroundColor = .white
       
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleCheck))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleCancel))

        
        navigationController?.setToolbarHidden(false, animated: false)
        
        view.addSubview(textView)
        
        view.addSubview(horizontalStackView)
        
        navigationItem.titleView = horizontalStackView
        
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.heightAnchor.constraint(equalToConstant: 200),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.backgroundColor = .white
      
    }
    

   
}
