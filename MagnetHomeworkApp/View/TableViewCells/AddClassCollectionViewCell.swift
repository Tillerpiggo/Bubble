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
    
    var dynamicViewDelegate: DynamicViewDelegate?
    var delegate: ProgrammaticAddClassViewDelegate?
    
    let addClassView: ProgrammaticAddClassView = {
        let addClassView = ProgrammaticAddClassView()
        addClassView.translatesAutoresizingMaskIntoConstraints = false
        
        // Maybe set delegate
        
        return addClassView
    }()
    
    // TODO: Abstract this into helper functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.addSubviews([addClassView])//, button])
        contentView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addContentViewConstraints()
        addAddClassViewConstraints()
        addClassView.dynamicViewDelegate = self
        addClassView.delegate = self
        //addButtonConstraints()
        
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func expand() {
        addClassView.expand()
    }
    
    //override var intrinsicContentSize: CGSize { return CGSize(width: 1, height: 1) }
}

// MARK: - Dynamic View Delegate
extension AddClassCollectionViewCell: DynamicViewDelegate {
    func sizeChanged() {
        dynamicViewDelegate?.sizeChanged()
    }
}

// MARK: - ProgrammaticAddClassViewDelegate
extension AddClassCollectionViewCell: ProgrammaticAddClassViewDelegate {
    
    func addClass(withText text: String, color: Color) {
        delegate?.addClass(withText: text, color: color)
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
        self.pinEdgesToView(contentView, priority: 999)
        //contentView.pinEdgesToView(self)
        //contentView.pinEdgesToView(contentView, priority: 999)
        
        //contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addAddClassViewConstraints() {
        // In relation to the contentView:
        
        
        contentView.pinEdgesToView(addClassView, withMargin: -20.0)
        addClassView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0).isActive = true
        addClassView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        addClassView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        addClassView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20.0).isActive = true
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
