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
        JobModel(title: "Software Development Engineer, Photoshop iOS"),
        JobModel(title: " Engineer, Photoshop iOS"),
        JobModel(title: " iOS"),
        JobModel(title: "Software Development Engineer, Photoshop iOS"),
        JobModel(title: " Engineer, Photoshop iOS"),
        JobModel(title: " iOS"),
        JobModel(title: "Software Development Engineer, Photoshop iOS"),
        JobModel(title: " Engineer, Photoshop iOS"),
        JobModel(title: " iOS"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.isHidden = !jobs.isEmpty
        
        cardsCV.delegate = self
        cardsCV.dataSource = self
        cardsCV.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        let job = jobs[indexPath.item]
        
        cell.jobLabel.text = job.title
        
        cell.onSwiped = { [weak self, weak cell] isRight in
            guard let self = self, let cell = cell,
                  let actualIndexPath = collectionView.indexPath(for: cell),
                  actualIndexPath.item < self.jobs.count else { return }
            
            self.jobs.remove(at: actualIndexPath.item)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [actualIndexPath])
            }, completion: { _ in
                collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 620)
    }
}
