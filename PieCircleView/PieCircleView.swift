//
//  PieCircleView.swift
//  PieCircleView
//
//  Created by lichao_liu on 2018/12/11.
//  Copyright © 2018年 com.pa.com. All rights reserved.
//

import UIKit

class PALayer: CAShapeLayer {
    var startAngle:CGFloat = 0
    var endAngle: CGFloat = 0
}

class PieCircleView: UIView {
    private var radius:CGFloat = 0
    private var centerPoint:CGPoint = .zero
    private var distance:CGFloat = 10
    private var colors:[UIColor] = []
    private var datas:[Float] = []
    private var selectedLayer:CAShapeLayer?//选中的layer临时变量
    var lineDistance:CGFloat = 20
    //-MARK- radius 半径  distance 点击往外运动距离
     init(frame: CGRect,radius:CGFloat = 100,distance: CGFloat = 10,datas: [Float] = [100.0,50,100,50,60],colors: [UIColor] = [UIColor.red,UIColor.purple,UIColor.orange,UIColor.black,UIColor.blue]) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        if frame.width < radius*2 {
            self.radius = frame.width/2
        }else {
            self.radius = radius
        }
        self.distance = distance
        self.centerPoint = CGPoint(x: frame.width/2, y: frame.height/2)
        self.colors = colors
        self.datas = datas
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startStroke() {
        //去除已有渲染的
        if layer.mask != nil {
            layer.mask = nil
            layer.sublayers?.removeAll()
        }
        configData()
    }
    
    fileprivate func configData() {
        var start = -CGFloat.pi/2
        var end = start
        //计算比例
        let sums = datas.reduce(0) { $0+$1}
        for index in 0 ..< datas.count {
            let pieLayer = PALayer()
            end = start + CGFloat.pi * 2.0 * CGFloat(datas[index]/sums)
            let piePath = UIBezierPath()
            piePath.move(to: centerPoint)
            piePath.addArc(withCenter:centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            pieLayer.fillColor = colors[index].cgColor
            pieLayer.path = piePath.cgPath
            
            pieLayer.startAngle = start
            pieLayer.endAngle = end
            start = end
            layer.addSublayer(pieLayer)
        }
        createAnimatedMaskLayer()
    }
    
    fileprivate func createAnimatedMaskLayer() {
        let maskLayer = CAShapeLayer()
        let maskPath = UIBezierPath(arcCenter: centerPoint, radius: radius/2 + distance/2 + 50, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        //lineWidth属性, 它有一半的宽度是超出path所包住的范围
        maskLayer.lineWidth = radius + distance + 100
        ////设置边框颜色为不透明，则可以通过边框的绘制来显示整个视图 任意颜色
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.strokeEnd = 0
        maskLayer.path = maskPath.cgPath
        //设置填充颜色为透明，可以通过设置半径来设置中心透明范围
        maskLayer.fillColor = UIColor.clear.cgColor
        layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateLayer(point: touches.first!.location(in: self))
    }
    
    fileprivate func updateLayer(point: CGPoint) {
        if let layers = layer.sublayers as? [PALayer]{
            for layer in layers {
                if layer.path!.contains(point){
                    if selectedLayer != layer {
                        let currPos = layer.position
                        let middleAngle = (layer.startAngle + layer.endAngle)/2
                        let newPos = CGPoint(x:currPos.x + distance * cos(middleAngle), y:currPos.y + distance * sin(middleAngle))
                        layer.position = newPos
                        if selectedLayer != nil {
                            selectedLayer?.position = .zero
                        }
                        selectedLayer = layer
                    }else {
                        selectedLayer?.position = .zero
                        selectedLayer = nil
                    }
                    break
                }
            }
        }
    }
}
