//
//  ViewController.swift
//  WaterfallDemo
//
//  Created by larry on 2018/12/21.
//  Copyright © 2018 twofly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sliderTopView = SliderTopView()
    let scrollV = UIScrollView()
    let hotView = WatefallView()
    let newView = WatefallView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        sliderTopView.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 40)
        sliderTopView.backgroundColor = .red
        sliderTopView.sliderDelegate = self
        sliderTopView.configItems([SliderTopViewItem.init("最热"),
                                   SliderTopViewItem.init("最新")])
        view.addSubview(sliderTopView)
        
        scrollV.frame = CGRect(x: 0, y: 90, width: view.frame.width, height: view.frame.height - 90) // view.bounds
        scrollV.contentSize = CGSize(width: scrollV.frame.width * 2, height: scrollV.frame.height)
        scrollV.isPagingEnabled = true
        view.addSubview(scrollV)
        
        hotView.frame = CGRect(x: 0, y: 0, width: scrollV.frame.width, height: scrollV.frame.height)
        hotView.configCollectionView()
        scrollV.addSubview(hotView)
        
        newView.frame = CGRect(x: scrollV.frame.width, y: 0, width: scrollV.frame.width, height: scrollV.frame.height)
        newView.configCollectionView()
        scrollV.addSubview(newView)
    }
}

extension ViewController: SliderTopViewProcol {
    func handleBtnClick(_ index: Int) {
        print("click \(index)")
        UIView.animate(withDuration: 0.25) {
            self.scrollV.contentOffset = CGPoint(x: CGFloat(index) * self.scrollV.frame.width, y: 0)
        }
    }
}
