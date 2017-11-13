//
//  ContentProviding.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

protocol RemoteContentProviding {
  
  associatedtype Content
  
  var providedContent: MutableProperty<Content?> { get }
  
  func fetchContent(_ completion: @escaping (Result<Content, AnyError>) -> Void)
  func viewController(for content: Result<Content, AnyError>) -> UIViewController
}
