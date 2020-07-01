//
//  ActionPickerViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/30/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class ActionSheetPickerViewCell: ProgrammaticCollectionViewCell {
    
    var delegate: PickerViewDelegate?
    
    var actionSheetPickerView: ActionSheetPickerView?
    
    private func initializeActionSheetPickerView(with items: [PickableItem]) {
        let actionSheetPickerView = ActionSheetPickerView(items: items)
        actionSheetPickerView.translatesAutoresizingMaskIntoConstraints = false
        actionSheetPickerView.delegate = self
        
        self.actionSheetPickerView = actionSheetPickerView
    }
    
    override func setupView() {
        contentView.pinEdgesToView(self, priority: 999)
    }
    
    func configure(with items: [PickableItem]) {
        initializeActionSheetPickerView(with: items)
        contentView.addSubview(actionSheetPickerView!)
        actionSheetPickerView!.pinEdgesToView(contentView)
    }
    
    func setTitle(to title: String) {
        actionSheetPickerView?.setTitle(to: title)
    }
    
    func presentActionSheet(from viewController: UIViewController) {
        actionSheetPickerView?.presentActionSheet(from: viewController)
    }
    
    func reset() {
        actionSheetPickerView?.reset()
    }
}

extension ActionSheetPickerViewCell: PickerViewDelegate {
    func didSelect(_ item: PickableItem?, title: String) {
        delegate?.didSelect(item, title: actionSheetPickerView!.title!)
    }
    
    func present(_ viewController: UIViewController) {
        delegate?.present(viewController)
    }
}
