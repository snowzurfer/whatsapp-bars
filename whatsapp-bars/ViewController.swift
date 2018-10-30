//
//  ViewController.swift
//  whatsapp-bars
//
//  Created by Alberto Taiuti on 28/10/2018.
//  Copyright © 2018 Alberto Taiuti. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "WhatsappCell"
fileprivate let itemsPerRow = 2
fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 1.0, right: 10.0)


class ViewController: UIViewController {

  private enum State {
    case normal
    case edit
  }
  private var currentState = State.normal
  
  private let dataSouce = [
    UIColor.cyan,
    UIColor.orange,
    UIColor.yellow,
    UIColor.magenta,
    UIColor.red,
    UIColor.blue,
    UIColor.purple
  ]
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var plusBtn: UIBarButtonItem!
  
  private lazy var toolBar: UIToolbar = {
    return UIToolbar()
  }()
  
  private var navBar: UINavigationBar! {
    return navigationController!.navigationBar
  }
  
  private var tabBar: UITabBar! {
    return tabBarController!.tabBar
  }
  
  private var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
  
  private var toolBarYPos: CGFloat {
    if currentState == .normal {
      // Assume portrait or upside down
      return screenHeight
    }
    // Ideally check for other states here, but since we only have two, keep it
    // simple; would do something like: else if currentState == .edit {
    else {
      return screenHeight - toolBar.frame.height
    }
  }
  
  private var orientationObs: NSObjectProtocol?
  private var toolBarConstraints = [NSLayoutConstraint]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CustomCollectionViewCell.self,
                                 forCellWithReuseIdentifier: reuseIdentifier)
    
    navBar.prefersLargeTitles = true
    
    navigationController!.isToolbarHidden = true
    
    view.addSubview(toolBar)
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBarConstraints.append(contentsOf: [
      toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      toolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      toolBar.topAnchor.constraint(equalTo: tabBar.topAnchor)
      ])
  }
  
  // https://stackoverflow.com/a/40140344/1584340
  func didRotate(notification: Notification) {
    toolBar.frame.origin.y = toolBarYPos
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                           object: nil,
                                           queue: .main,
                                           using: didRotate)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self,
                                              name: UIDevice.orientationDidChangeNotification,
                                              object: nil)
    NSLayoutConstraint.deactivate(toolBarConstraints)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let item = UIBarButtonItem(title: "Action", style: .plain,
                                 target: self,
                                 action: #selector(self.onActionToolbar))
    toolBar.setItems([item], animated: false)
    toolBar.frame.origin.y = self.toolBarYPos
    
    NSLayoutConstraint.activate(toolBarConstraints)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    toolBar.frame.origin.y = toolBarYPos
  }

  @IBAction func onEditBtnTouchUp(_ sender: Any) {
    // Switch to the editing mode
    if currentState == .normal {
      currentState = .edit
      
      fade(tabBar, toAlpha: 0, withDuration: 0.2, andHide: true)
      UIView.animate(withDuration: 0.2, animations: {
        // Set edit to done
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                                action: #selector(self.onDoneBtnTouchUp))
        // Fade away + btn
        self.plusBtn.isEnabled = false
        self.plusBtn.tintColor = UIColor.clear
        
        // Position the toolbar
        self.toolBar.frame.origin.y = self.toolBarYPos
      })
    }
  }
  
  @objc func onDoneBtnTouchUp(_ sender: Any) {
    // Switch to normal state
    if currentState == .edit {
      currentState = .normal
      
      fade(tabBar, toAlpha: 1, withDuration: 0.2, andHide: false)
      UIView.animate(withDuration: 0.2, animations: {
        // Set edit to done
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self,
                                                                action: #selector(self.onEditBtnTouchUp))
        
        // Fade in + btn
        self.plusBtn.isEnabled = true
        self.plusBtn.tintColor = nil
        
        // Position the toolbar
        self.toolBar.frame.origin.y = self.toolBarYPos
      })
    }
  }
  
  @objc func onActionToolbar(_ sender: Any) {
    let vc = UIAlertController(title: "On Action",
                               message: "The Action button was tapped.",
                               preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
    self.present(vc, animated: true, completion: nil)
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return dataSouce.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! CustomCollectionViewCell
    
    cell.setup(topColour: dataSouce[indexPath.row],
               bottomColour: UIColor.white)
    
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * CGFloat((itemsPerRow + 1))
    let availableWidth = view.bounds.width - paddingSpace
    let widthPerItem = availableWidth / CGFloat(itemsPerRow)
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
