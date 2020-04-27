//
//  InputTextField.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-14.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit

class LoginSignUpInputTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        textColor = .black
        
        font = UIFont.systemFont(ofSize: 16)
        
    }
        
    override func layoutSubviews() {
        underlined()
    }
    
    // While editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // While displaying text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // Placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func underlined(){
           let border = CALayer()
           let lineWidth = CGFloat(3)
           border.borderColor = UIColor.mainGray().cgColor
           border.frame = CGRect(x: 0, y: self.frame.size.height - lineWidth, width: self.frame.size.width, height: self.frame.size.height)
           border.borderWidth = lineWidth
           self.layer.addSublayer(border)
           self.layer.masksToBounds = true
       }
}
