//
//  WaterfallLayout.swift
//  WaterfallDemo
//
//  Created by larry on 2018/12/21.
//  Copyright © 2018 twofly. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDelegate {
    func itemHeightForIndexPath(indexpath : IndexPath) -> CGFloat?
}

class WaterfallLayout: UICollectionViewLayout {
    //行间距
    var minimumLineSpacing: CGFloat = 0.0 {
        didSet{
            //设置item的宽度
            setUpItemWidth()
        }
    }
    
    //列间距
    var minimumInteritemSpacing: CGFloat = 0.0 {
        didSet{
            //设置item的宽度
            setUpItemWidth()
        }
    }
    var scrollDirection: UICollectionView.ScrollDirection = .vertical // default is UICollectionViewScrollDirectionVertical
    fileprivate var item_w : CGFloat = 0//item宽度
    //内边距
    var sectionInset: UIEdgeInsets = .zero {
        didSet{
            //设置item的宽度
            setUpItemWidth()
        }
    }
    //列数，默认2
    var columnsNum = 2{
        didSet{
            //设置列高
            columnsHeightArray.removeAll()
            for _ in 0...columnsNum{
                //如果数量不对则全部设置为0
                columnsHeightArray.append(0)
            }
            //设置item的宽度
            setUpItemWidth()
        }
    }
    
    var delegate : WaterfallLayoutDelegate?
    
    fileprivate var attrArray: Array<UICollectionViewLayoutAttributes> = Array<UICollectionViewLayoutAttributes>()//属性数组
    fileprivate var columnsHeightArray: Array<CGFloat> = [0,0]//每列的高度
    
    //设置每一个item的属性
    func setAttrs() {
        guard let secNum = collectionView?.numberOfSections else {
            return
        }
        for i in 0...secNum-1{
            for i in 0...columnsNum - 1 {
                columnsHeightArray[i] = getLongValue()
            }
//            attrArray.append(layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: i))!)
            guard let itemsNum = collectionView?.numberOfItems(inSection: i) else {
                return
            }
            for j in 0...itemsNum - 1{
                attrArray.append(layoutAttributesForItem(at: IndexPath.init(row: j, section: i))!)
            }
        }
    }
    
    //获取最短列的索引
    func getShortesIndex() -> Int {
        var index = 0
        for i in 0...columnsNum - 1{
            if columnsHeightArray[index] > columnsHeightArray[i]{
                index = i
            }
        }
        return index
    }
    
    //获取最长列的值
    func getLongValue() -> CGFloat {
        var value : CGFloat = 0
        for i in 0...columnsNum - 1{
            if value < columnsHeightArray[i]{
                value = columnsHeightArray[i]
            }
        }
        return value
    }
    
    //设置每列的宽度
    func setUpItemWidth(){
        guard let collectionWidth = collectionView?.frame.size.width else {
            return
        }
        item_w = (collectionWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat((columnsNum - 1))) / CGFloat(columnsNum)
    }
    
    override var collectionViewContentSize: CGSize{
        get{
            return CGSize(width: 0, height: getLongValue() + sectionInset.top + sectionInset.bottom)
        }
    }
    
    override func prepare() {
        super.prepare()
        setUpItemWidth()
        setAttrs()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let shortesIndex = getShortesIndex()
        let item_x = sectionInset.left + (item_w + minimumInteritemSpacing) * CGFloat(shortesIndex)
        let item_y = columnsHeightArray[shortesIndex] + sectionInset.top
        let item_h = delegate?.itemHeightForIndexPath(indexpath: indexPath) ?? 0
        attr.frame = CGRect(x: item_x, y: item_y , width: item_w, height: item_h)
        
        //更新列高数组
        columnsHeightArray[shortesIndex] += (item_h + minimumLineSpacing)
        return attr
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let header_x: CGFloat = sectionInset.left
        let header_y: CGFloat = columnsHeightArray[0] + minimumLineSpacing + sectionInset.top
        let header_w = item_w * CGFloat(columnsNum) + minimumInteritemSpacing * CGFloat(columnsNum - 1)
        let header_h: CGFloat = 40
        attr.frame = CGRect(x: header_x, y: header_y, width: header_w, height: header_h)
        for i in 0...columnsNum - 1{
            columnsHeightArray[i] += (header_h + minimumLineSpacing)
        }
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArray
    }
}

