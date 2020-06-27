//
//  CollectionPickerView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/22/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

protocol CollectionPickerViewDelegate {
    func didSelect(_ item: Any?, collectionPickerView: CollectionPickerView)
}

/// When subclassing, override title, cellType, and reuseIdentifier
class CollectionPickerView: ProgrammaticView {
    
    var delegate: CollectionPickerViewDelegate?
    var items: [Any?]
    var deselectedOpacity: Float = 0.25
    
    private var isExpanded = false
    private var shrinkConstraints = [NSLayoutConstraint]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var selectedIndexPath: IndexPath?
    
    // Override these
    var title: String {
        return "Must implement in subclass"
    }
    
    var cellType: UICollectionViewCell.Type {
        return UICollectionViewCell.self
    }
    
    var reuseIdentifier: String {
        return "override"
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        titleLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        titleLabel.text = title
        
        return titleLabel
    }()
    
    private lazy var selectedItemLabel: UILabel = {
        let selectedItemLabel = UILabel()
        selectedItemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        selectedItemLabel.textColor = UIColor(white: 0.86, alpha: 1.0)
        selectedItemLabel.text = "None"
        
        return selectedItemLabel
    }()
    
    private lazy var expandIndicator: UIImageView = {
        let expandIndicator = UIImageView(image: UIImage(named: "expandIndicatorShrunken")!)
        expandIndicator.translatesAutoresizingMaskIntoConstraints = false
        expandIndicator.contentMode = .scaleAspectFit
        //expandIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        return expandIndicator
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    init(items: [Any?]) {
        self.items = items
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubviews([titleLabel, selectedItemLabel, expandIndicator, collectionView])
        addConstraints()
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.addDropShadow(color: .black, opacity: 0.1, radius: 20)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 40)
        collectionViewHeightConstraint?.priority = UILayoutPriority(rawValue: 999)
        collectionViewHeightConstraint?.isActive = true
    }
    
    // TODO - possibly make a controller, move this heightAnchor code to didLayoutSubviews()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        print(collectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
    func toggleExpansion(animated: Bool) {
        if isExpanded {
            shrink(animated: animated)
        } else {
            expand(animated: animated)
        }
    }
}

// Expand and shrink
extension CollectionPickerView {
    func expand(animated: Bool) {
        guard !isExpanded else { return }
        isExpanded = true
        
        for constraint in shrinkConstraints {
            constraint.priority = UILayoutPriority(rawValue: 1)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                self.expandIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
                self.layoutIfNeeded()
            }
        } else {
            self.expandIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            self.layoutIfNeeded()
        }
    }
    
    func shrink(animated: Bool) {
        guard isExpanded else { return }
        isExpanded = false
        
        for constraint in shrinkConstraints {
            constraint.priority = UILayoutPriority(rawValue: 1000)
            constraint.isActive = true
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                self.expandIndicator.transform = .identity
                self.layoutIfNeeded()
            }
        } else {
            self.expandIndicator.transform = .identity
            self.layoutIfNeeded()
        }
    }
}

// Collection view delegate and data source
extension CollectionPickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make sure to set all cells layer.opacity = deselectedOpacity
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PickableItemCell
        
        cell.configure(with: items[indexPath.row])
        cell.contentView.layer.opacity = deselectedOpacity
        
        if cell.isSelected {
            cell.contentView.layer.opacity = 1.0
        }
        
        return cell
    }
    
    // Temporary, for testing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // TODO - Add animation, update label
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PickableItemCell {
            cell.contentView.layer.opacity = 1.0
            //cell.addDropShadow(color: .black, opacity: 0.4, radius: 30)
            
            selectedItemLabel.text = cell.string
            selectedItemLabel.textColor = cell.color
            
            //selectedIndexPath = indexPath
        }
        
        delegate?.didSelect(items[indexPath.row], collectionPickerView: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.opacity = deselectedOpacity
            //cell.removeDropShadow()
        }
    }
}

// Helpers for setupView() {
fileprivate extension CollectionPickerView {
    func addConstraints() {
        // Broken right now, but it actually works
        titleLabel.addConstraints(
            top: self.topAnchor, topConstant: 16,
            leading: self.leadingAnchor, leadingConstant: 24,
            trailing: selectedItemLabel.leadingAnchor,
            heightConstant: 24)
        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 16)
        bottomConstraint.priority = UILayoutPriority(500)
        bottomConstraint.isActive = true
        
        selectedItemLabel.addConstraints(
            top: titleLabel.topAnchor, topConstant: 0,
            bottom: titleLabel.bottomAnchor, bottomConstant: 0,
            trailing: expandIndicator.leadingAnchor, trailingConstant: 16)
        
        expandIndicator.addConstraints(
            trailing: self.trailingAnchor, trailingConstant: 16,
            widthConstant: 24,
            heightConstant: 24)
        expandIndicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        collectionView.addConstraints(
            top: titleLabel.bottomAnchor, topConstant: 16,
            bottom: self.bottomAnchor, bottomConstant: 16,
            leading: self.leadingAnchor, leadingConstant: 16,
            trailing: self.trailingAnchor, trailingConstant: 16,
            priority: 999)
        
        self.shrinkConstraints = [
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 0)
        ]
        
        for constraint in shrinkConstraints {
            constraint.priority = UILayoutPriority(rawValue: 1000)
            constraint.isActive = true
        }
        
        /*
        //collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height).isActive = true
        collectionView.layoutIfNeeded()
        //collectionView.heightAnchor.constraint(equalToConstant: collectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
       // collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
 */
    }
}

protocol PickableItemCell: ProgrammaticCollectionViewCell {
    var string: String? { get set }
    var color: UIColor? { get set }
    func configure(with item: Any?)
}

// Subclasses
class ClassPickerView: CollectionPickerView {
    override var title: String { return "Class" }
    override var reuseIdentifier: String { return "ClassPickerViewCell" }
    override var cellType: UICollectionViewCell.Type { return PickableClassCell.self }
}

class DatePickerView: CollectionPickerView {
    override var title: String { return "Due Date" }
    override var reuseIdentifier: String { return "DatePickerViewCell" }
    override var cellType: UICollectionViewCell.Type { return PickableDueDateCell.self }
}

