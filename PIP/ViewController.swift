//
//  ViewController.swift
//  PIP
//
//  Created by Yonghyun on 2020/07/20.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pipView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pipViewDesign()
        pipSetting()
    }

    func pipViewDesign() {
        pipView.layer.cornerRadius = 10
        pipView.clipsToBounds = true
        pipView.layer.shadowColor = UIColor.gray.cgColor
        pipView.layer.shadowOpacity = 1.0
        pipView.layer.shadowOffset = CGSize(width: 0, height: 0)
        pipView.layer.shadowRadius = 10
        pipView.layer.masksToBounds = false
    }
    
    func pipSetting() {
        self.view.isUserInteractionEnabled = true
        self.view.isMultipleTouchEnabled = true
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag))
        pipView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        self.view.addGestureRecognizer(rotate)
        
        pinch.delegate = self
        panGesture.delegate = self
        rotate.delegate = self
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        // 이미지를 스케일에 맞게 변환
        self.pipView.transform = self.pipView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        // 다음 변환을 위해 핀치의 스케일 속성을 1로 설정
        pinch.scale = 1
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        // self는 여기서 ViewController이므로 self.view ViewController가 기존에가지고 있는 view이다.
        let translation = sender.translation(in: self.pipView) // translation에 움직인 위치를 저장한다.
        
        
        
        /*
         
         x0,y0-----------x1,y1
         |                  |
         |                  |
         |                  |
         x2,y2-----------x3,y3
         
         */
        
        var x0 = pipView.frame.origin.x
        var y0 = pipView.frame.origin.y
        
        var x1 = pipView.frame.origin.x + pipView.frame.width
        var y1 = pipView.frame.origin.y
        
        var x2 = pipView.frame.origin.x
        var y2 = pipView.frame.origin.y + pipView.frame.height
        
        var x3 = pipView.frame.origin.x + pipView.frame.width
        var y3 = pipView.frame.origin.y + pipView.frame.height
        
        if (x0 < 20 && y0 < 60)
            || (x1 > UIScreen.main.bounds.width - 20 && y1 < 60)
            || (x2 < 20 && y2 > UIScreen.main.bounds.height - 20)
            || (x3 > UIScreen.main.bounds.width - 20 && y3 > UIScreen.main.bounds.height - 20) {
            
        }

        // sender의 view는 sender가 바라보고 있는 circleView이다. 드래그로 이동한 만큼 circleView를 이동시킨다.
        pipView!.center = CGPoint(x: pipView!.center.x + translation.x, y: pipView!.center.y + translation.y)
        sender.setTranslation(.zero, in: self.pipView) // 0으로 움직인 값을 초기화 시켜준다.
        
        
        print("x : \(pipView.frame.origin.x)")
        print("y : \(pipView.frame.origin.y)")
        
        
        // 화면 범위 못 넘어가게 하고
        // rotate 가능하게 하고
        // 클릭하면 전체화면으로 UIView.animate 써서 만들기
        // view 가 기울어진 후 드래그 하면 이동이 이상함
    }
    
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        pipView.transform = pipView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
