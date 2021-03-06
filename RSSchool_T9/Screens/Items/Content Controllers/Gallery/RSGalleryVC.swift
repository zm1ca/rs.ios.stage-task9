//
// 📰 🐸 
// Project: RSSchool_T9
// 
// Author: Źmicier Fiedčanka
// On: 30.07.21
// 
// Copyright © 2021 RSSchool. All rights reserved.

import UIKit

class RSGalleryVC: RSContentVC {
    
    var gallery: Gallery!
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let imagesStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 20
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout                = UICollectionViewFlowLayout()
        flowLayout.sectionInset       = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.itemSize           = CGSize(width: 200, height: 300)
        flowLayout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(RSGalleryCell.self, forCellWithReuseIdentifier: RSGalleryCell.reuseID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate        = self
        collectionView.dataSource      = self
        collectionView.isScrollEnabled = false
        setupBasicUI(with: gallery)
        loadImagesToViews()
        
        collectionViewHeightConstraint = NSLayoutConstraint(item: collectionView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 0)
        
        layoutUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIScreen.isPortrait {
            collectionViewHeightConstraint.constant = CGFloat(gallery.images.count) * ((view.safeAreaLayoutGuide.layoutFrame.width - 40) * 1.337 + 20)
        } else {
            let rowsCount = (gallery.images.count + 2) / 3
            let sectionWidthInsets: CGFloat = 20 * 2
            let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width
            let availableSpace       = screenWidth - sectionWidthInsets - 25 * 2
            let itemWidth            = availableSpace / 3
            let rowHeight = itemWidth *  1.337
            collectionViewHeightConstraint.constant = (rowHeight + 20) * CGFloat(rowsCount)
        }
    }
    
    
    // MARK: - Customization and layout
    private func loadImagesToViews() {
        gallery.images.forEach {
            imagesStackView.addArrangedSubview(RSGalleryImageView(image: $0))
        }
    }

    private func layoutUI() {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: separationLine.bottomAnchor, constant: 50),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            collectionViewHeightConstraint
        ])
    }
}


//TODO: Split delegates!
extension RSGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gallery.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSGalleryCell.reuseID, for: indexPath) as! RSGalleryCell
        cell.set(with: gallery.images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidthInsets: CGFloat = 20 * 2
        let minimumItemSpacing: CGFloat = UIScreen.isPortrait ? 0 : 25
        let screenWidth          = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let availableSpace       = screenWidth - sectionWidthInsets - minimumItemSpacing * 2
        let itemWidth            = UIScreen.isPortrait ? availableSpace : availableSpace / 3
        let aspectRatio: CGFloat = 1.337
        return CGSize(width: itemWidth, height: itemWidth * aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = RSDetailedImageVC()
        imageVC.imageView.image = gallery.images[indexPath.row]
        imageVC.modalPresentationStyle = .fullScreen
        self.present(imageVC, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout();
    }

    
}
