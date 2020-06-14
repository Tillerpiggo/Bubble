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
        colorView.layer.cornerRadius = 20
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        return colorView
    }()
    
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
    
    func setColor(to color: UIColor) {
        colorView.backgroundColor = color
    }
}

// Note - this is effectively a view controller, however it is easier to implement as a subview like this.
class ColorPickerView: ProgrammaticView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let colorCollectionViewCellIdentifier = "ColorCell"
    
    let colors: [UIColor] = {
        return [.red, .blue, .green]
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
    
    override func setupView() {
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: colorCollectionViewCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        self.pinEdgesToView(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = collectionView.bounds.height
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCollectionViewCellIdentifier, for: indexPath) as! ColorCollectionViewCell
        
        cell.setColor(to: colors[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 32.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

// random change
