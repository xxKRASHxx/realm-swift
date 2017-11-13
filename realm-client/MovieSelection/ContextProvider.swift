//
//  ContextProvider.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

struct Credentials {
  let username: String
  let password: String
}

struct ContextProvider: RemoteContentProviding {
  
  typealias Content = MovieListViewModel
  
  let credentials: Credentials
  let providedContent = MutableProperty<MovieListViewModel?>(nil)
  
  enum ContextError: Error {
    case undefined
  }
  
  func fetchContent(_ completion: @escaping (Result<Content, AnyError>) -> Void) {
    SyncUser.logIn(
      with: .usernamePassword(username: credentials.username,
                              password: credentials.password,
                              register: false),
      server: URL(string: "http://localhost:9080")!
    ) { user, error in
      
      guard let user = user
        else { completion(Result(error: AnyError(error ?? ContextError.undefined))); return }
      
      DispatchQueue.main.async {
        let configuration = Realm.Configuration(syncConfiguration:
          SyncConfiguration(
            user: user,
            realmURL: URL(string: "realm://localhost:9080/~/movies")!,
            enableSSLValidation: false)
        )
        
        let result = Result<Content, AnyError>
        { (try Realm(configuration: configuration) =>> MovieListViewModel.init)! }
        self.providedContent.value = result.value
        completion(result)
      }
    }
  }
  
  func viewController(for content: Result<Content, AnyError>) -> UIViewController {
    switch content {
    case .success(let viewModel):
      guard let viewController = viewModel =>> MovieListViewController.with
        else { fatalError("can not initialize") }
      return viewController
    case .failure(let error):
      return ErrorViewController(any: error)
    }
  }
}

extension MovieListViewController {
  static func with(viewModel: MovieListViewModel) -> MovieListViewController {
    guard let viewController = UIStoryboard(name: "MovieSelection", bundle: nil)
      .instantiateInitialViewController() as? MovieListViewController
      else { fatalError() }
    viewController.viewModel = viewModel
    return viewController
  }
}

