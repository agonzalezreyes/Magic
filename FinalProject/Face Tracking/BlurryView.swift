//
//  BlurryView.swift
//  FinalProject
//
//  Created by Alejandrina Gonzalez on 12/2/17.
//  Copyright © 2017 Alejandrina Gonzalez. All rights reserved.
//

import UIKit

class BlurryView: UIView {
    
    private let effect = UIBlurEffect(style: .light)
    var emojiLabel: UILabel!
    
    private func sameInit() {
        backgroundColor = .clear
        emojiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width/3.0, height: bounds.size.width/3.0))
        emojiLabel.center = center
        emojiLabel.font = UIFont(
            descriptor: .preferredFontDescriptor(withTextStyle: .body),
            size: emojiLabel.frame.height
        )
        emojiLabel.adjustsFontSizeToFitWidth = true
        emojiLabel.textAlignment = .center
        let blur = UIVisualEffectView(effect: effect)
        blur.frame = self.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blur)
        addSubview(emojiLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sameInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sameInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sameInit()
    }
}
