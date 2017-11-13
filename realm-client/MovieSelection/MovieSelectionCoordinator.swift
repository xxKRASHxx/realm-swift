
//
//  MovieSelectionCoordinator.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class MovieSelectionCoordinator: NSObject {
  
  let presenter: UINavigationController
  private let initialController: RemoteContentContainerViewController<ContextProvider>
  
  var nextCoordinator: Coordinator! {
    didSet { nextCoordinator.start(animated: true) }
  }
  
  init(presenter: UINavigationController) {
    self.presenter = presenter
    let provider = ContextProvider(credentials: .init(username: "test-user", password: "Tu123456"))
    initialController = RemoteContentContainerViewController(provider: provider)
    super.init()
    
    reactive.coordinator <~ provider.providedContent
      .signal.skipNil()
      .map { $0.actionSignal }
      .flatten(.latest)
      .map { result in
        switch result {
        case .open(let movie): return MovieCompositionCoordinator(presenter: self.presenter, movie: movie)
        }
      }
  }
}

extension MovieSelectionCoordinator: Coordinator {
  
  func start(animated: Bool) {
    presenter.pushViewController(initialController, animated: animated)
  }
}

private extension Reactive where Base: MovieSelectionCoordinator {
  var coordinator: BindingTarget<Coordinator> {
    return makeBindingTarget { $0.nextCoordinator = $1 }
  }
}
