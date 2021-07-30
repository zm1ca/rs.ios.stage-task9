//
// 📰 🐸 
// Project: RSSchool_T9
// 
// Author: Źmicier Fiedčanka
// On: 29.07.21
// 
// Copyright © 2021 RSSchool. All rights reserved.

import UIKit

class RSTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [configuredRSItemsVC(), configuredRSSettingsVC()]
    }
    
    private func configuredRSSettingsVC() -> UINavigationController {
        let settingsVC = RSSettingsTVC(style: .insetGrouped)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        settingsVC.title = "Settings"
        return UINavigationController(rootViewController: settingsVC)
    }
    
    private func configuredRSItemsVC() -> RSItemsCVC {
        let itemsVC = RSItemsCVC(collectionViewLayout: configuredFlowLayout())
        itemsVC.tabBarItem = UITabBarItem(title: "Items", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        itemsVC.collectionView.register(RSStoryCell.self, forCellWithReuseIdentifier: "storyCell")
        return itemsVC
    }
    
    private func configuredFlowLayout() -> UICollectionViewFlowLayout{
        let width                       = UIScreen.main.bounds.width
        let padding: CGFloat            = 16
        let minimumItemSpacing: CGFloat = 20
        let aspectRatio: CGFloat        = 1.223
        let availableSpace              = width - (2 * padding) - (minimumItemSpacing)
        let itemWidth                   = availableSpace / 2
        
        let flowLayout          = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize     = CGSize(width: itemWidth, height: itemWidth * aspectRatio)
        flowLayout.minimumLineSpacing = 30
        
        return flowLayout
    }

}
