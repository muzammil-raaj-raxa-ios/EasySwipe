//
//  JobCardCell.swift
//  SwipeCards
//
//  Created by MacBook Pro on 18/04/2025.
//

import UIKit

class JobCardCell: UICollectionViewCell {

    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var passOrFailView: UIView!
    @IBOutlet weak var passOrFailLabel: UILabel!
    
    var onSwiped: ((Bool) -> Void)?
    private var originalCenter: CGPoint = .zero
    private let threshold: CGFloat = 100
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        passOrFailView.isHidden = true
        addRoundedBorder(view: cellView, cornerRadius: 20, borderWidth: 1, borderColor: UIColor.lightGray)
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
        passOrFailView.isHidden = true
        passOrFailLabel.text = ""
        passOrFailView.layer.borderWidth = 0
        passOrFailView.backgroundColor = .clear
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
            
            // Show visual feedback based on direction
            passOrFailView.isHidden = false
            if translation.x > 0 {
                // Right Swipe - Show FAIL
                passOrFailLabel.text = "FAIL"
                passOrFailLabel.textColor = .green
                passOrFailView.backgroundColor = .clear
                passOrFailView.layer.borderWidth = 4
                passOrFailView.layer.borderColor = UIColor.green.cgColor
                passOrFailView.layer.cornerRadius = 0
            } else if translation.x < 0 {
                // Left Swipe - Show PASS
                passOrFailLabel.text = "PASS"
                passOrFailLabel.textColor = .red
                passOrFailView.backgroundColor = .clear
                passOrFailView.layer.borderWidth = 4
                passOrFailView.layer.borderColor = UIColor.red.cgColor
                passOrFailView.layer.cornerRadius = 0
            }
            
        case .ended:
            if abs(translation.x) > threshold {
                let isRightSwipe = translation.x > 0
                swipeCard(toRight: isRightSwipe)
                onSwiped?(isRightSwipe)
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.impactOccurred()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.originalCenter
                    self.transform = .identity
                    self.passOrFailView.isHidden = true
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
