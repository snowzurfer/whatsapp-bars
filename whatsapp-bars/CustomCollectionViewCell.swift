//
//  CustomCollectionViewCell.swift
//  whatsapp-bars
//
//  Created by Alberto Taiuti on 28/10/2018.
//  Copyright © 2018 Alberto Taiuti. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
  private lazy var gradientView: GradientRoundView = {
    let view = GradientRoundView()
    backgroundView = view
    return view
  }()

  func setup(topColour: UIColor, bottomColour: UIColor) {
    gradientView.bottomColour = bottomColour
    gradientView.topColour = topColour
  }
}
