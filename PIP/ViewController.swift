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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPan(_:)))
        pipView.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(doRotate(_:)))
        self.view.addGestureRecognizer(rotate)
        
        pinch.delegate = self
        panGesture.delegate = self
        rotate.delegate = self
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        self.pipView.transform = self.pipView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    @objc func doPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.pipView)
        let statusFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame
        
        if let senderView = self.pipView {
            if senderView.frame.origin.x < 20.0 {
                senderView.frame.origin = CGPoint(x: 20.0, y: senderView.frame.origin.y)
            }
            if senderView.frame.origin.y < statusFrame?.height ?? 0 + 20 {
                senderView.frame.origin = CGPoint(x: senderView.frame.origin.x, y: statusFrame?.height ?? 0 + 20)
            }
            if senderView.frame.origin.x + senderView.frame.size.width > view.frame.width - 20 {
                senderView.frame.origin = CGPoint(x: view.frame.width - senderView.frame.size.width - 20, y: senderView.frame.origin.y)
            }
            if senderView.frame.origin.y + senderView.frame.size.height > view.frame.height - 30 {
                senderView.frame.origin = CGPoint(x: senderView.frame.origin.x, y: view.frame.height - senderView.frame.size.height - 30)
            }
        }

        if let centerX = self.pipView?.center.x, let centerY = self.pipView?.center.y {
            self.pipView?.center = CGPoint.init(x: centerX + translation.x , y: centerY + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.pipView)
        }
    }
    
    // view 가 기울어진 후 드래그 하면 이동이 이상함
    
    @objc func doRotate(_ gesture: UIRotationGestureRecognizer) {
        pipView.transform = pipView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
