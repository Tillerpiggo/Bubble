//
//  ProgrammaticAssignmentTableViewCell.swift
//  Bubble
//
//  Created by Tyler Gee on 6/20/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class AssignmentCollectionViewCell: ProgrammaticCollectionViewCell {
    
    override var intrinsicContentSize: CGSize { return CGSize(width: 100, height: 50) }
    
    private let completed = "completedCircleTemplate"
    private let incompleted = "incompletedCircle2"
    
    var assignment: Assignment?
    
    private lazy var assignmentView: AssignmentView = {
        let assignmentView = AssignmentView()
        assignmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return assignmentView
    }()
    
    /*
    // The background view
    private var bubbleView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = .white
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Round corners
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
        
        bubbleView.addDropShadow(color: .black, opacity: 0.12, radius: 20)
        
        return bubbleView
    }()
    
    private var textView: ExpandingTextView = {
        let textView = ExpandingTextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var isCompletedImageView: UIImageView = {
        let incompletedImage = UIImage(named: incompleted)!
        let imageView = UIImageView(image: incompletedImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
 */
    
    func configure(withAssignment assignment: Assignment) {
           /*
           let isCompleted = assignment.toDo?.isCompleted ?? false
           let isCompletedImage = isCompleted ? UIImage(named: completed) : UIImage(named: incompleted)
           isCompletedImageView.tintColor = assignment.owningClass!.color.uiColor
           isCompletedImageView.image = isCompletedImage
           
           textView.text = assignment.text ?? ""
           textView.textColor = isCompleted ? .lightGray : .textColor
           
           self.assignment = assignment
    */
        assignmentView.configure(withAssignment: assignment)
    }
    
    override func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        addSubviews()
        addConstraints()
 */
        addSubview(assignmentView)
        self.pinEdgesToView(contentView, withMargin: -4.0)
        contentView.pinEdgesToView(assignmentView)
    }
}

// Setup view helper methods
extension AssignmentCollectionViewCell {
    /*
    func addSubviews() {
        addSubview(bubbleView)
        bubbleView.addSubviews([textView, isCompletedImageView])
    }
    
    func addConstraints() {
        self.pinEdgesToView(contentView, withMargin: -4.0)
        contentView.pinEdgesToView(bubbleView)
        
        NSLayoutConstraint.activate([
            isCompletedImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            isCompletedImageView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            isCompletedImageView.heightAnchor.constraint(equalToConstant: 20),
            isCompletedImageView.widthAnchor.constraint(equalTo: isCompletedImageView.heightAnchor),
            textView.leadingAnchor.constraint(equalTo: isCompletedImageView.trailingAnchor, constant: 12),
            textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 4),
            textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -4),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -4)
        ])
    }
 */
    
    //https://www.robertpieta.com/autosizing-full-width-cells/
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // Replace the height in the target size to
        // allow the cell to flexibly compute its height
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        // The .required horizontal fitting priority means
        // the desired cell width (targetSize.width) will be
        // preserved. However, the vertical fitting priority is
        // .fittingSizeLevel meaning the cell will find the
        // height that best fits the content
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
}
