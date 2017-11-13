//
//  AppDelegate.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/24/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  lazy var applicationCoordinator: Coordinator = {
    guard let main = self.window else { fatalError("Application window is obligatorily") }
    return ApplicationCoordinator(window: main)
  }()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    RealmSwift.SyncManager.shared.logLevel = SyncLogLevel.all
    RealmSwift.SyncManager.shared.errorHandler = { error, _ in
      print("Realm error: \(error)")
    }
    
    applicationCoordinator.start()
    
    return true
  }
}

