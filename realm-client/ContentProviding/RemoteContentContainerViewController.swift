//
//  RemoteContentContainerViewController.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class RemoteContentContainerViewController<T: RemoteContentProviding>: UIViewController {
  
  let provider: T?
  
  init(provider: T) {
    self.provider = provider
    super.init(nibName: "RemoteContentContainerViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    provider = nil
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    provider?.fetchContent(
      weakify(RemoteContentContainerViewController.handle, object: self)
    )
  }
}

extension RemoteContentContainerViewController {
  func handle(content: Result<T.Content, AnyError>) -> () {
    (self.provider?.viewController(for: content))
      .do(self.navigationController?.provide(animated: true))
  }
}

private extension UINavigationController {
  func provide(animated: Bool = false) -> (UIViewController) -> Void {
    return { viewController in
      let isFirstInStack = 1 == self.viewControllers.count
      isFirstInStack ?
        self.processFirst(viewController, animated: animated) :
        self.process(viewController, animated: animated)
      
    }
  }
  
  private func processFirst(_ viewController: UIViewController, animated: Bool) {
    self.setViewControllers([viewController], animated: animated)
  }
  
  private func process(_ viewController: UIViewController, animated: Bool) {
    self.popViewController(animated: animated)
    self.pushViewController(viewController, animated: animated)
  }
}
