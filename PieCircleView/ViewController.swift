//
//  ViewController.swift
//  PieCircleView
//
//  Created by lichao_liu on 2018/12/11.
//  Copyright © 2018年 com.pa.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var circleView:PieCircleView?
    override func viewDidLoad() {
        super.viewDidLoad()
         circleView = PieCircleView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500), radius: 100, distance: 10, datas: [10,20,30,60,100], colors: [UIColor.red,UIColor.yellow,UIColor.purple,UIColor.blue,UIColor.black])
        circleView!.center = view.center
        view.addSubview(circleView!)
        circleView!.startStroke()
        
        let btn = UIButton(type: .custom)
        btn.setTitle("click again", for: .normal)
        btn.addTarget(self, action: #selector(whenBtnClicked), for: .touchUpInside)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.frame = CGRect.init(x: 150, y: 80, width: 100, height: 40)
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.borderWidth = 1
        view.addSubview(btn)
    }

    @objc func whenBtnClicked() {
        circleView?.startStroke()
    }

}

