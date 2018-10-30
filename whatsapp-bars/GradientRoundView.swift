//
//  GradientRoundView.swift
//  whatsapp-bars
//
//  Created by Alberto Taiuti on 28/10/2018.
//  Adapted from https://github.com/nathangitter/fluid-interfaces/blob/master/FluidInterfaces/FluidInterfaces/GradientView.swift
//  Copyright © 2018 Alberto Taiuti. All rights reserved.
//

import UIKit

class GradientRoundView: UIView {
  
  public var bottomColour: UIColor = .white {
    didSet {
      updateGradientColours()
    }
  }
  
  public var topColour: UIColor = .blue {
    didSet {
      updateGradientColours()
    }
  }
  
  public var cornerRadius: CGFloat? {
    didSet {
      layoutSubviews()
    }
  }

  private lazy var gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0, y: 1)
    
    gradientLayer.colors = [topColour.cgColor, bottomColour.cgColor]

    return gradientLayer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradientLayer.frame = bounds
    
    let roundLayer = CAShapeLayer()
    roundLayer.path = UIBezierPath(roundedRect: bounds,
                                   cornerRadius: cornerRadius ?? bounds.width * 0.2).cgPath
    layer.mask = roundLayer
  }
  
  private func sharedInit() {
    layer.addSublayer(gradientLayer)
  }
  
  private func updateGradientColours() {
    gradientLayer.colors = [topColour.cgColor, bottomColour.cgColor]
  }
}
