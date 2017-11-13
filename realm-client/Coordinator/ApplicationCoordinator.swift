//
//  ApplicationCoordinator.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
  
  let window: UIWindow
  let rootViewController = UINavigationController()
  
  lazy var movieSelectionCoordinator: MovieSelectionCoordinator = {
    return MovieSelectionCoordinator(presenter: self.rootViewController)
  }()
  
  init(window: UIWindow) {
    self.window = window
  }
}

extension ApplicationCoordinator: Coordinator {
  func start(animated: Bool) {
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    movieSelectionCoordinator.start(animated: animated)
  }
}
