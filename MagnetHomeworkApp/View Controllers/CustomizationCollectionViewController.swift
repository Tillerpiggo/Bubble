//
//  CustomizationCollectionViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 6/23/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class CustomizationCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Remember to set classes
    var classes: [Class]
    
    // Subclass should override this property
    var items: [[Any?]] {
        return [[nil]]
    }
    
    var selectedItems = [Any?]()
    var collectionViewHeight: NSLayoutConstraint?
    
    private var collectionPickerViewCellIdentifier = "CollectionPickerViewCell"
    
    // Override
    func registerCells() {
        collectionView.register(CollectionPickerViewCell.self, forCellWithReuseIdentifier: collectionPickerViewCellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        registerCells()
        
        for _ in items {
            selectedItems.append(nil)
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.pinEdgesToView(view)
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: collectionViewLayout.collectionViewContentSize.height)
        collectionViewHeight?.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.collectionViewHeight?.constant = collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    init(collectionViewLayout layout: UICollectionViewLayout, classes: [Class]) {
        self.classes = classes
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Datasource and delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // Override
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionPickerViewCellIdentifier, for: indexPath) as! CollectionPickerViewCell
        
        cell.configure(with: items[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func reset() {
        selectedItems = [Any?](repeating: nil, count: collectionView(collectionView, numberOfItemsInSection: 0))
        
        // Shrink and clear all of the cells
        if let classCollectionPickerViewCell = collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? ClassCollectionPickerViewCell {
            classCollectionPickerViewCell.reset()
        }
        
        if let dueDateCollectionPickerViewCell = collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? DueDateCollectionPickerViewCell {
            dueDateCollectionPickerViewCell.reset()
        }
    }
}

extension CustomizationCollectionViewController: PickerViewDelegate {
    @objc func didSelect(_ item: Any?, pickerView: CollectionPickerView) {
        // Up to the subclass to override and implement
        
        // Generally, they should do a series of if let statements and insert the item in selectedItems appropriately
    }
}


class AssignmentCustomizationCollectionViewController: CustomizationCollectionViewController {
    
    private var classCollectionPickerViewCellIdentifier = "ClassCollectionPickerViewCell"
    private var dueDateCollectionPickerViewCellIdentifier = "DueDateCollectionPickerViewCell"
    
    override func registerCells() {
        collectionView.register(ClassCollectionPickerViewCell.self, forCellWithReuseIdentifier: classCollectionPickerViewCellIdentifier)
        collectionView.register(DueDateCollectionPickerViewCell.self, forCellWithReuseIdentifier: dueDateCollectionPickerViewCellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionPickerViewCell
        
        // Possibly refactor this into an overridable function so you dont have to add configure and delegate into the mix
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: classCollectionPickerViewCellIdentifier, for: indexPath) as! ClassCollectionPickerViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: dueDateCollectionPickerViewCellIdentifier, for: indexPath) as! DueDateCollectionPickerViewCell
        }
        
        cell.configure(with: items[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    override var items: [[Any?]] {
        return [
            
            classes,
           [
               DateModel(withDate: NSDate(timeIntervalSinceNow: 0 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 1 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 2 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 3 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 4 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 5 * 86400)),
               DateModel(withDate: NSDate(timeIntervalSinceNow: 6 * 86400))
           ],
        ]
    }
    
    override func didSelect(_ item: Any?, pickerView: CollectionPickerView) {
        if let _ = pickerView as? ClassPickerView {
            selectedItems[0] = item
        } else if let _ = pickerView as? DatePickerView {
            selectedItems[1] = item
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionPickerViewCell
        
        cell.toggleExpansion(animated: true)
        
        collectionView.collectionViewLayout.invalidateLayout()
            
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.collectionView.layoutIfNeeded()
        }
    }
}
