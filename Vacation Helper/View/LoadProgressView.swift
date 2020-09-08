//
//  Replicator.swift
//  Vacation Helper
//
//  Created by Valentin Kiselev on 9/5/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class LoadProgressView: UIView {
	
	private var replicatorLayer: CAReplicatorLayer!
    private var sourceLayer: CALayer!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initializeSetup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initializeSetup()
	}
	
	func initializeSetup() {
		backgroundColor = #colorLiteral(red: 0.7515175167, green: 0.8980813847, blue: 1, alpha: 1)
		replicatorLayer = CAReplicatorLayer()
		sourceLayer = CALayer()
		layer.addSublayer(replicatorLayer)
		replicatorLayer.addSublayer(sourceLayer)
		
		startAnimation(delay: 0.1, replicates: 30)
	}


	
	override func layoutSubviews() {
		replicatorLayer.frame = self.bounds
        replicatorLayer.position = self.center
		
		sourceLayer.frame = CGRect(x: 0.0, y: 0.0, width: 3, height: 17)
        sourceLayer.backgroundColor = UIColor.white.cgColor
        sourceLayer.position = self.center
        sourceLayer.anchorPoint = CGPoint(x: 0.0, y: 5.0)
	}
	
	func startAnimation(delay: TimeInterval, replicates: Int) {
        
        replicatorLayer.instanceCount = replicates
        let angle = CGFloat(2.0 * Double.pi) / CGFloat(replicates)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        replicatorLayer.instanceDelay = delay
        sourceLayer.opacity = 0
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = Double(replicates) * delay
        opacityAnimation.repeatCount = Float.infinity
        sourceLayer.add(opacityAnimation, forKey: nil)
    }
	
}
