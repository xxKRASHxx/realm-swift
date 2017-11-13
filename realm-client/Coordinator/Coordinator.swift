//
//  Coordinator.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

protocol Coordinator {
  func start(animated: Bool)
}

extension Coordinator {
  func start(animated: Bool? = false) {
    start(animated: animated!)
  }
}
