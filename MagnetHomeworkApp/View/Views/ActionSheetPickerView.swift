//
//  ActionSheetPickerView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/30/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

protocol PickableItem {
    var string: String { get }
    var color: Color { get }
}

protocol PickerViewDelegate {
    func didSelect(_ item: PickableItem?, title: String)
    func present(_ viewController: UIViewController)
}

class ActionSheetPickerView: BouncyView {
    
    var delegate: PickerViewDelegate?
    var items: [PickableItem]
    var title: String?
    
    var actionSheet = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        
        return titleLabel
    }()
    
    private lazy var selectedItemLabel: UILabel = {
        let selectedItemLabel = UILabel()
        selectedItemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemLabel.textAlignment = .right
        
        return selectedItemLabel
    }()
    
    init(items: [PickableItem]) {
        self.items = items
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(to title: String) {
        titleLabel.text = title
        self.title = title
        actionSheet.title = "Select \(title.lowercased())"
    }
    
    func presentActionSheet(from viewController: UIViewController) {
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    override func setupView() {
        addSubviews([titleLabel, selectedItemLabel])
        addConstraints()
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.addDropShadow(color: .black, opacity: 0.1, radius: 15)
        
        for item in items {
            actionSheet.addAction(UIAlertAction(title: item.string, style: .default, handler: { [unowned self] (action) in
                self.selectedItemLabel.text = item.string
                self.selectedItemLabel.textColor = item.color.uiColor
                self.delegate?.didSelect(item, title: self.title!)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        super.setupView()
    }
    
    private func addConstraints() {
        titleLabel.addConstraints(
            top: self.topAnchor, topConstant: 8,
            bottom: self.bottomAnchor, bottomConstant: 8,
            leading: self.leadingAnchor, leadingConstant: 8,
            trailing: selectedItemLabel.leadingAnchor)
        selectedItemLabel.addConstraints(
            top: self.topAnchor, topConstant: 8,
            bottom: self.bottomAnchor, bottomConstant: 8,
            trailing: self.trailingAnchor, trailingConstant: 8)
    }
    
    override func tapped() {
        // Display action sheet
        delegate?.present(actionSheet)
    }
    
    func reset() {
        self.selectedItemLabel.text = "None"
    }
}
