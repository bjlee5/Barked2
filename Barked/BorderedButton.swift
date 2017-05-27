//
//  BoarderedButton.swift
//  Barked
//
//  Created by MacBook Air on 5/3/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
    }
    
}
