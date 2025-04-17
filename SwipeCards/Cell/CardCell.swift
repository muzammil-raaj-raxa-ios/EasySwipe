//
//  CardCell.swift
//  SwipeCards
//
//  Created by MacBook Pro on 17/04/2025.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var applyView: UIView!
    @IBOutlet weak var passView: UIView!
    
    var onSwiped: ((Bool) -> Void)?
    private var originalCenter: CGPoint = .zero
    private let threshold: CGFloat = 100
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        applyView.isHidden = true
        passView.isHidden = true
        
        addRoundedBorder(view: cellView, cornerRadius: 20, borderWidth: 1, borderColor: UIColor.lightGray)
        addRoundedBorder(view: applyView, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.green)
        addRoundedBorder(view: passView, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.red)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.transform = .identity
        self.alpha = 1
        applyView.isHidden = true
        passView.isHidden = true
    }
    
    func addRoundedBorder(view: UIView,cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.masksToBounds = true
    }
    
    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        let translation = gesture.translation(in: superview)
        
        switch gesture.state {
        case .began:
            originalCenter = center
        case .changed:
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            let rotation = translation.x / (UIScreen.main.bounds.width * 2)
            self.transform = CGAffineTransform(rotationAngle: rotation)
            
            // Show Apply or Pass view based on swipe direction
            if translation.x > 0 {
                applyView.isHidden = false  // Show Apply view when swiping right
                passView.isHidden = true    // Hide Pass view
            } else if translation.x < 0 {
                passView.isHidden = false   // Show Pass view when swiping left
                applyView.isHidden = true   // Hide Apply view
            }
            
        case .ended:
            if abs(translation.x) > threshold {
                let isRightSwipe = translation.x > 0
                swipeCard(toRight: isRightSwipe)
                onSwiped?(isRightSwipe)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.originalCenter
                    self.transform = .identity
                    // Hide both views if swipe doesn't pass the threshold
                    self.applyView.isHidden = true
                    self.passView.isHidden = true
                }
            }
        default:
            break
        }
    }
    
    private func swipeCard(toRight: Bool) {
        let direction: CGFloat = toRight ? 1 : -1
        UIView.animate(withDuration: 0.3, animations: {
            self.center.x += direction * 500
            self.alpha = 0
        }, completion: { _ in
            self.onSwiped?(toRight)
        })
    }
    
}
