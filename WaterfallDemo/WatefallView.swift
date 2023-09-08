//
//  WatefallView.swift
//  WaterfallDemo
//
//  Created by larry on 2018/12/21.
//  Copyright © 2018 twofly. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

let cellW_default = (UIScreen.main.bounds.width - 23 * 2 - 13) / 2.0
let cellH_default = cellW_default * 5.0 / 3.0
let cellH_topic = cellW_default * 0.6

class WatefallView: UIView {

    var collectionView : UICollectionView!
    
    func configCollectionView() {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 13, left: 23, bottom: 6.3, right: 23)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .blue
        collectionView.register(UINib(nibName: "WaterfallCell", bundle: Bundle.main), forCellWithReuseIdentifier: "WaterfallCell")
        //        collectionView.register(WaterfallReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WaterfallReusableView")
        addSubview(collectionView)
    }
}

extension WatefallView : UICollectionViewDelegate, UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(arc4random() % 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterfallCell", for: indexPath)
        cell.backgroundColor = .red
        // Configure the cell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusedView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WaterfallReusableView", for: indexPath)
        reusedView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        return reusedView
    }
}

extension WatefallView : WaterfallLayoutDelegate{
    func itemHeightForIndexPath(indexpath: IndexPath) -> CGFloat? {
        return indexpath.row == 0 ? cellH_topic : cellH_default
    }
}

class WaterfallReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


