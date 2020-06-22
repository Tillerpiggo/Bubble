//
//  ColorPickerView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/8/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 18
        colorView.layer.masksToBounds = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        return colorView
    }()
    
    var color: Color?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(colorView)
        contentView.pinEdgesToView(colorView)
        self.pinEdgesToView(contentView)
    }
    
    func setColor(to color: Color) {
        // Figure this out later
        /*
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: colorView.frame.size)
        gradientLayer.colors = [color.color1, color.color2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        DispatchQueue.main.async { self.colorView.layer.addSublayer(gradientLayer) }
 */
        colorView.backgroundColor = color.uiColor
        self.color = color
    }
}

protocol ColorPickerViewDelegate {
    func didSelect(color: Color)
}

// Note - this is effectively a view controller, however it is easier to implement as a subview like this.
class ColorPickerView: ProgrammaticView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: ColorPickerViewDelegate?
    var selectedColor: Color?
    
    let colorCollectionViewCellIdentifier = "ColorCell"
    
    let colors: [Color] = {
        return [Color.red, Color.orange, Color.blue, Color.lightBlue, Color.purple, Color.pink, Color.lime]
    }()
    
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    func selectCell(atIndexPath indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    override func setupView() {
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: colorCollectionViewCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        self.pinEdgesToView(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = 44.0
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCollectionViewCellIdentifier, for: indexPath) as! ColorCollectionViewCell
        
        cell.setColor(to: colors[indexPath.row])
        cell.contentView.layer.opacity = 0.3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func deselectAll() {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedIndexPaths {
                collectionView.deselectItem(at: indexPath, animated: true)
                collectionView(collectionView, didDeselectItemAt: indexPath)
            }
        }
    }
    
    // TODO - Add animation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            cell.contentView.layer.opacity = 1.0
            if let color = cell.color { selectedColor = color }
        }
        
        delegate?.didSelect(color: colors[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.opacity = 0.3
        }
    }
}

// random change
