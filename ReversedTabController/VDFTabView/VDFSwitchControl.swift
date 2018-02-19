//
//  VDFSwitchControl.swift
//  ReversedTabController
//
//  Created by Bogdan Coticopol on 19/02/2018.
//  Copyright © 2018 Bogdan Coticopol. All rights reserved.
//

import UIKit

struct VDFSwitchControlStyle {
    public var onImage: String = "checked"
    public var offImage: String = "unchecked"
}

class VDFSwitchControl: UIButton {
    
    public var style: VDFSwitchControlStyle {
        get {
            return _style
        }
        set(value) {
            _style = value
            initWithCustomStyle()
        }
    }
    
    public var isOn: Bool {
        get {
            return isSelected
        }
        set(value) {
            isSelected = value
        }
    }
    
    private var imageON: UIImage!
    private var imageOFF: UIImage!
    private var _style: VDFSwitchControlStyle = VDFSwitchControlStyle()
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        initWithCustomStyle()
    }
    
    init (frame: CGRect, style: VDFSwitchControlStyle) {
        super.init(frame: frame)
        self.style = style
        setupUI()
        initWithCustomStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        initWithCustomStyle()
    }
    
    private func setupUI() {
        print("\(#file): Initialized.")
        self.addTarget(self, action: #selector(controlTap(_:)), for: .touchUpInside)
    }
    
    @objc private func controlTap(_ sender: VDFSwitchControl) {
        isOn = !isOn
    }
    
    private func initWithCustomStyle() {
        
        titleLabel?.text = ""
        imageView?.contentMode = .scaleAspectFill
        
        imageON = UIImage(named: style.onImage)
        imageOFF = UIImage(named: style.offImage)
        
        setImage(imageOFF, for: .normal)
        setImage(imageON, for: .selected)
        
        isSelected = false
    }

}
