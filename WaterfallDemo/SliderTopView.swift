//
//  SliderTopView.swift
//  WaterfallDemo
//
//  Created by larry on 2018/12/21.
//  Copyright © 2018 twofly. All rights reserved.
//

import UIKit

protocol SliderTopViewProcol{
    func handleBtnClick(_ index: Int)
}

struct SliderTopViewItem{
    var title: String = ""
    var normalColor: UIColor = .white
    var selectedColor: UIColor = .white
    var normalFont: UIFont = .systemFont(ofSize: 12)
    var selectedFont: UIFont = .systemFont(ofSize: 12)
    
    init(_ title: String = "", _ normalColor: UIColor = .white, _ selectedColor: UIColor = .white,_ normalFont: UIFont = .systemFont(ofSize: 12), _ selectedFont: UIFont = .systemFont(ofSize: 12)) {
        self.title = title
        self.normalColor = normalColor
        self.normalFont = normalFont
        self.selectedColor = selectedColor
        self.selectedFont = selectedFont
    }
}

class SliderTopView: UIScrollView {

    private let startTag = 10000
    var normalColor: UIColor = .white
    var selectedColor: UIColor = .white
    var normalFont: UIFont = .systemFont(ofSize: 12)
    var selectedFont: UIFont = .systemFont(ofSize: 12)
    var bottomLineColor: UIColor = .white
    var sliderDelegate: SliderTopViewProcol?
    
    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0
    private var leftSpacing: CGFloat = 0
    private var rightSpacing: CGFloat = 0

    private var items = [SliderTopViewItem]()
    private let bottomLine = UIView()
    
    var selectedIndex: Int = 0 {
        didSet {
            guard let subView: UIButton = viewWithTag(startTag + selectedIndex) as? UIButton else {
                return
            }
            subView.isSelected = true
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.center = CGPoint(x: subView.center.x, y: self.bounds.height - 3 / 2.0)
            }
        }
    }
    
    /**
     *  配置items
     */
    func configItems(_ newItems: [SliderTopViewItem]) {
        for i in 0..<items.count {
            let subView = viewWithTag(startTag+i)
            subView?.removeFromSuperview()
        }
        
        items.removeAll()
        items.append(contentsOf: newItems)
        configSize()
        
        for i in 0..<items.count {
            let item = items[i]
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: leftSpacing + itemWidth * CGFloat(i), y: 0, width: itemWidth, height: itemHeight)
            btn.setTitle(item.title, for: .normal)
            btn.setTitle(item.title, for: .selected)
            btn.setTitleColor(item.normalColor, for: .normal)
            btn.setTitleColor(item.selectedColor, for: .selected)
            btn.titleLabel?.font = item.normalFont
            btn.tag = startTag + i
            btn.addTarget(self, action: #selector(handleBtnClick), for: .touchUpInside)
            addSubview(btn)
        }
        
        bottomLine.frame = CGRect(x: 0, y: 0, width: 25, height: 3)
        bottomLine.backgroundColor = bottomLineColor
        addSubview(bottomLine)
        
        selectedIndex = 0
    }
    
    /**
     *  item相关位置
     */
    func configSize() {
        itemWidth = UIScreen.main.bounds.width / CGFloat(items.count + 2)
        itemHeight = 19.0
        leftSpacing = itemWidth
        rightSpacing = itemWidth
    }
    
    @objc func handleBtnClick(_ btn: UIButton) {
        guard btn.tag - startTag != selectedIndex, let subView: UIButton = viewWithTag(startTag + selectedIndex) as? UIButton else {
            return
        }
        subView.isSelected = false
        selectedIndex = btn.tag - startTag
        sliderDelegate?.handleBtnClick(selectedIndex)
    }
}
