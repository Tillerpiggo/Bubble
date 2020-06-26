//
//  AssignmentView.swift
//  Bubble
//
//  Created by Tyler Gee on 6/25/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class AssignmentView: ProgrammaticView {
    
    private let completed = "completedCircleTemplate"
    private let incompleted = "incompletedCircle2"
    
    var assignment: Assignment?
    
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
    
    func configure(withAssignment assignment: Assignment) {
        let isCompleted = assignment.toDo?.isCompleted ?? false
        let isCompletedImage = isCompleted ? UIImage(named: completed) : UIImage(named: incompleted)
        isCompletedImageView.tintColor = assignment.owningClass!.color.uiColor
        isCompletedImageView.image = isCompletedImage
        
        textView.text = assignment.text ?? ""
        textView.textColor = isCompleted ? .lightGray : .textColor
        
        self.assignment = assignment
    }
    
    func select() {
        textView.select()
    }
    
    override func setupView() {
        addSubviews()
        addConstraints()
    }
}

extension AssignmentView {
    func addSubviews() {
        addSubview(bubbleView)
        bubbleView.addSubviews([textView, isCompletedImageView])
    }
    
    func addConstraints() {
        self.pinEdgesToView(bubbleView)
        
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
}
