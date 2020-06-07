//
//  AddClassViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 3/26/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import Foundation
import UIKit

class AddClassCollectionViewCell: UICollectionViewCell {
    
    //var dynamicViewDelegate: DynamicViewDelegate?
    var delegate: ProgrammaticAddClassViewDelegate?
    
    let addClassView: ProgrammaticAddClassView = {
        let addClassView = ProgrammaticAddClassView()
        addClassView.translatesAutoresizingMaskIntoConstraints = false
        
        // Maybe set delegate
        
        return addClassView
    }()
    
    /*
    // Detects if you press this view while it's a button
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.backgroundColor = .blue
        
        return button
    }()
 */
    
    // TODO: Abstract this into helper functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard isUserInteractionEnabled else { return nil }
        
        guard !isHidden else { return nil }
        
        guard alpha >= 0.01 else { return nil }
        
        guard self.point(inside: point, with: event) else { return nil }
        
        // https://stackoverflow.com/questions/40988992/collection-view-cell-button-not-triggering-action
        if button.point(inside: convert(point, to: button), with: event) {
            // For some reason, while buttonPressed isn't called, this is called twice...
            
            return self.button
        }
        
        return super.hitTest(point, with: event)
    }
 */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.addSubviews([addClassView])//, button])
        contentView.backgroundColor = .white
        
        addContentViewConstraints()
        addAddClassViewConstraints()
        //addClassView.dynamicViewDelegate = self
        addClassView.delegate = self
        //addButtonConstraints()
        
       // self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func expand() {
        addClassView.expand()
    }
    
    //override var intrinsicContentSize: CGSize { return CGSize(width: 1, height: 1) }
}

/*
// MARK: - Dynamic View Delegate
extension AddClassCollectionViewCell: DynamicViewDelegate {
    func sizeChanged() {
        dynamicViewDelegate?.sizeChanged()
    }
}
 */

// MARK: - ProgrammaticAddClassViewDelegate
extension AddClassCollectionViewCell: ProgrammaticAddClassViewDelegate {
    
    func addClass(withText text: String) {
        delegate?.addClass(withText: text)
    }
    
    func didShrink() {
        delegate?.didShrink()
    }
    
    func didExpand() {
        delegate?.didExpand()
    }
    
}

// Helper methods:
fileprivate extension AddClassCollectionViewCell {
    func addContentViewConstraints() {
        contentView.pinEdgesToView(self)
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func addAddClassViewConstraints() {
        // In relation to the contentView:
        
        addClassView.pinEdgesToView(contentView, withMargin: 0.0)
    }
    
    /*
    func addButtonConstraints() {
        button.pinEdgesToView(self)
    }
    
    @objc func buttonPressed() {
        print("The button was pressed!")
    }
 */
}
