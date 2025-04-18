//
//  ViewController.swift
//  SwipeCards
//
//  Created by MacBook Pro on 17/04/2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var cardsCV: UICollectionView!
    
    private var jobs: [JobModel] = [
        JobModel(title: "Lead UI/UX Designer Visual Design Lead and Interaction Planner"),
        JobModel(title: "iOS Developer Swift Expert with CoreData & Combine Experience"),
        JobModel(title: "Android Engineer Kotlin Pro with Jetpack Compose Mastery"),
        JobModel(title: "Senior Backend Developer Node.js and MongoDB Specialist"),
        JobModel(title: "Product Manager Agile Expert and Roadmap Strategist"),
        JobModel(title: "Graphic Designer Branding, Illustration, and Digital Art"),
        JobModel(title: "Full Stack Developer React & Express Enthusiast"),
        JobModel(title: "QA Engineer Automation Tester with Selenium & Appium"),
        JobModel(title: "DevOps Engineer CI/CD Pipeline Architect with Docker/Kubernetes"),
        JobModel(title: "Data Scientist Python & TensorFlow Expert with ML Skills"),
        JobModel(title: "Frontend Developer Vue.js Specialist with UI Animation Skills")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.isHidden = !jobs.isEmpty
        
        cardsCV.delegate = self
        cardsCV.dataSource = self
        cardsCV.register(UINib(nibName: "JobCardCell", bundle: nil), forCellWithReuseIdentifier: "JobCardCell")
        cardsCV.collectionViewLayout = CardStackLayout()
        cardsCV.isScrollEnabled = false
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyLabel.isHidden = !jobs.isEmpty
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCardCell", for: indexPath) as? JobCardCell else {
            return UICollectionViewCell()
        }
        
        let job = jobs[indexPath.item]
        
        cell.jobLabel.text = job.title
        
        cell.onSwiped = { [weak self, weak cell] isRight in
            guard let self = self, let cell = cell,
                  let currentIndexPath = collectionView.indexPath(for: cell),
                  currentIndexPath.item < self.jobs.count else { return }
            
            self.jobs.remove(at: currentIndexPath.item)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [currentIndexPath])
            }, completion: { _ in
                collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 342, height: 604)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
