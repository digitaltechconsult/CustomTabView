//
//  BCOSegmentedControl.swift
//  ReversedTabController
//
//  Created by Bogdan Coticopol on 18/02/2018.
//  Copyright © 2018 Bogdan Coticopol. All rights reserved.
//

import UIKit

// MARK: - VDFSegmentedControl style parameters
struct VDFSegmentedControlStyle {
    public var defaultFont: UIFont =  UIFont.systemFont(ofSize: 14)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var defaultColor: UIColor = UIColor.gray
    public var selectedColor: UIColor = UIColor.blue
    public var thicknessPercentage: CGFloat = 0.02
    public var selectedThicknessPercentage: CGFloat = 0.04
}

// MARK: - VDFSegmentedControlProtocol
@objc protocol VDFSegmentedControlProtocol {
    @objc optional func segmentedControlValueChanged(_ sender:VDFSegmentedControl);
}

// MARK: - VDFSegmentedControl UI
class VDFSegmentedControl: UISegmentedControl {
    
    //MARK: Properties
    public var style: VDFSegmentedControlStyle {
        get {
            return _style
        }
        set(value) {
            _style = value
            initWithCustomStyle()
        }
    }
    
    private var _style: VDFSegmentedControlStyle = VDFSegmentedControlStyle()
    private var defaultBorderView: UIView!
    private var selectedBorderViews: [UIView] = []
    private let delegate: VDFSegmentedControlProtocol? = nil
    
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        initWithCustomStyle()
    }
    
    init (frame: CGRect, style: VDFSegmentedControlStyle) {
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
    
    
    //MARK: Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        initWithCustomStyle()
    }
    
    //MARK: Targets
    @objc private func segmentedControlValueChanged(_ sender: VDFSegmentedControl) {
        for i in 0..<numberOfSegments {
            selectedBorderViews[i].isHidden = true
        }
        selectedBorderViews[selectedSegmentIndex].isHidden = false
        delegate?.segmentedControlValueChanged?(sender)
    }
    
    //MARK: Private methods
    private func setupUI() {
        print("\(#file): Initialized.")
        self.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func initWithCustomStyle() {
        print("\(#file): Redraw the UI.")
        self.backgroundColor = .clear
        self.tintColor = .clear
        
        self.setTitleTextAttributes([NSAttributedStringKey.font: style.defaultFont, NSAttributedStringKey.foregroundColor: style.defaultColor], for: .normal)
        self.setTitleTextAttributes([NSAttributedStringKey.font: style.selectedFont, NSAttributedStringKey.foregroundColor: style.selectedColor], for: .selected)
        
        //default border
        if defaultBorderView != nil { //if we need to redraw the UI remove the old one
            defaultBorderView.removeFromSuperview()
        }
        defaultBorderView = drawDefaultBorder()
        self.addSubview(defaultBorderView)
        
        //selected border
        self.addSubviews(views: self.drawSelectedBorders())
    }
    
    private func drawDefaultBorder() -> UIView {
        let defaultBorder = UIView(frame: calculateRect(thickness: style.thicknessPercentage))
        defaultBorder.backgroundColor = style.defaultColor
        defaultBorder.isHidden = false
        return defaultBorder
    }
    
    private func drawSelectedBorders() -> [UIView] {
        var selectedBorders: [UIView] = []
        for i in 0..<numberOfSegments {
            let selectedView = UIView(frame: calculateRect(thickness: style.selectedThicknessPercentage, segment: i))
            selectedView.backgroundColor = style.selectedColor
            selectedView.isHidden = i == selectedSegmentIndex ? false : true
            drawArrow(toView: selectedView)
            selectedBorders.append(selectedView)
        }
        return selectedBorders
    }
    
    private func drawArrow(toView: UIView) {
        let width = toView.frame.size.width
        let height = toView.frame.size.height
        let arrowSize = width * style.selectedThicknessPercentage
        let halfWidth = width * 0.5
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: halfWidth - arrowSize, y: height))
        linePath.addLine(to: CGPoint(x: halfWidth, y: height + arrowSize))
        linePath.addLine(to: CGPoint(x: halfWidth + arrowSize, y: height))
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.fillColor = style.selectedColor.cgColor
        toView.layer.addSublayer(line)
    }
    
    private func addSubviews(views: [UIView]) {
        for view in selectedBorderViews {
            view.removeFromSuperview()
        }
        selectedBorderViews.removeAll()
        for view in views {
            addSubview(view)
            selectedBorderViews.append(view)
        }
    }
    
    private func calculateRect(thickness: CGFloat) -> CGRect {
        let y = frame.size.height * (1 - thickness)
        let width = frame.size.width
        let height = frame.size.height * thickness
        return CGRect(x: 0, y: y, width: width, height: height)
    }
    
    private func calculateRect(thickness: CGFloat, segment: Int) -> CGRect {
        let width = frame.size.width / CGFloat(numberOfSegments)
        let height = frame.size.height * thickness
        let y = frame.size.height * (1 - thickness)
        let x = CGFloat(segment) * width
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
