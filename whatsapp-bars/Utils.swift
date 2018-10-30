//
//  Utils.swift
//  whatsapp-bars
//
//  Created by Alberto Taiuti on 28/10/2018.
//  Copyright © 2018 Alberto Taiuti. All rights reserved.
//

import UIKit

func fade(_ view: UIView, toAlpha alpha: CGFloat,
          withDuration duration: TimeInterval, andHide: Bool) {
  UIView.animate(withDuration: duration, animations: {
    if !andHide {
      view.isHidden = false
    }
    
    view.alpha = alpha
  }) { (_) in
    view.isHidden = andHide
  }
}
