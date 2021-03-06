//
//  ClassTableViewCell.swift
//  MagnetHomeworkApp
//
//  Created by Tyler Gee on 11/11/18.
//  Copyright © 2018 Beaglepig. All rights reserved.
//

import UIKit
import Foundation

protocol ClassTableViewCellDelegate {
    func expandedClass(_ class: Class)
    func collapsedClass(_ class: Class)
}

class ClassTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var previewAssignmentLabel: UILabel!
    @IBOutlet weak var numberOfAssignmentsLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var numberOfAssignmentsView: UIView!
    @IBOutlet weak var progressBarView: ProgressBarView!
    
    
    //@IBOutlet weak var completedImageView: UIImageView!
    //@IBOutlet weak var numberOfAssignmentsImageView: UIImageView!
    //@IBOutlet weak var numberOfAssignmentsLabel: UILabel!
    
    var accessoryButton: UIButton?
    var delegate: ClassTableViewCellDelegate?
    var isExpanded: Bool = false
    var `class`: Class?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
        
        //completedImageView.isHidden = true
        contentView.backgroundColor = .contentColor
        backgroundColor = .contentColor
        
        bubbleView.layer.cornerRadius = 18
        bubbleView.layer.masksToBounds = true
        bubbleView.backgroundColor = .white
        bubbleView.addDropShadow(color: .black, opacity: 0.2, radius: 4)
        numberOfAssignmentsView.layer.cornerRadius = 10
        numberOfAssignmentsView.layer.masksToBounds = true
        
        //progressBarView.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryButton?.frame.origin.y += 1
        accessoryButton?.frame.origin.x += 0
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = 0.25
        
        //previewAssignmentLabel.layer.add(animation, forKey: "kCATransitionFade")
        //previewAssignmentLabel.textColor = .secondaryTextColor
    }
    
    func configure(withClass `class`: Class) {
        self.class = `class`
        
        nameLabel.text = `class`.name
        nameLabel.textColor = .black
        
        updateDuePreview()
        
        //progressBarView.color = `class`.color.uiColor
        progressBarView.setProgress(to: `class`.progress, isAnimated: false)
        progressBarView.configure()
    }
    
    func updateDuePreview() {
        if let previewAssignments = `class`!.previewAssignments() {
            //previewAssignmentLabel.isHidden = false
            let duePreviewSection = previewAssignments.first?.dueDateString
            let numberOfAssignments = previewAssignments.count
            
            let string: String = "\(numberOfAssignments) \(duePreviewSection ?? "")"
            
            numberOfAssignmentsLabel.text = "\(`class`!.numberOfUncompletedAssignments)"
            
            //completedImageView.isHidden = true
            
            //let attributedText = NSMutableAttributedString(string: string)
            //print("AttributedText: \(attributedText.string)")
            //let sectionColor: UIColor = previewAssignments.first!.dueDate!.dueDateType.color
//            switch previewAssignments.first?.dueDateSection {
//            case 0:
//                sectionColor = .lateColor
//            case 2:
//                sectionColor = .dueThisWeekColor
//            case 3, 4:
//                sectionColor = .secondaryTextColor
//            case 1:
//                sectionColor = .dueTomorrowColor
//            default:
//                sectionColor = .nothingDueColor
//            }
            
            //attributedText.addAttribute(.foregroundColor, value: sectionColor, range: NSRange(location: 0, length: attributedText.string.count))
            //numberOfAssignmentsLabel.attributedText = attributedText
            //numberOfAssignmentsLabel.text = "\(`class`?.assignmentArray?.count ?? 0)"
        } else {
            //let attributedText = NSMutableAttributedString(string: "Nothing Due")
            //attributedText.addAttribute(.foregroundColor, value: UIColor.nothingDueColor, range: NSRange(location: 0, length: attributedText.string.count))
            
            //numberOfAssignmentsLabel.attributedText = attributedText
            let numberOfUncompletedAssignments = `class`!.assignmentArray?.filter({ $0.isCompleted == false }).count ?? 0
            numberOfAssignmentsLabel.text = "\(`class`!.numberOfUncompletedAssignments)"
        }
    }
    
//    func setPreviewAssignmentLabel(previewAssignments: [Assignment], numberOfAssignments: Int, includesCount: Bool = false) {
//        var text: String = ""
//
//        for previewAssignment in previewAssignments[0..<numberOfAssignments] {
//            text += "\(previewAssignment.text!)\n"
//        }
//        for _ in 0..<1 { text.removeLast() }
//        if includesCount { previewAssignmentSectionLabel.text?.append(" (\(previewAssignments.count))") }
//
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 2.0
//        let attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
//        previewAssignmentLabel.attributedText = attributedText
//    }
}
