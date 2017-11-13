//
//  MovieCompositionViewModel.swift
//  realm-client
//
//  Created by Danil Lisovoy on 11/1/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ReactiveSwift
import ReactiveCocoa
import Result

class MovieCompositionViewModel {
  
  enum CompositionAction {
    case choose(at: Int)
  }
  
  let movieURL = MutableProperty<URL?>(nil)
  let movieId = MutableProperty<String>("")
  let status = MutableProperty<String>("")
  
  var selectVideo: Action<Void, MediaInfo, AnyError>?
  var play: Action<URL?, Void, NoError>?
  
  lazy var choose: Action<Int, Void, NoError> = {
    weak var dispatcher = self
    return Action { index in
      return SignalProducer { dispatcher?.consume(action: .choose(at: index)) }
    }
  }()
  
  private var token: NotificationToken!
  private let movie: Movie
  private var realm: Realm {
    get {
      guard let realm = movie.realm
        else { fatalError("Realm object must be managed.") }
      return realm
    }
  }
  
  init(with movie: Movie) {
    
    self.movie = movie
    
    movieId <~ movie.reactive
        .producer(forKeyPath: #keyPath(Movie.id))
        .map { $0 as? String }.skipNil()
    
    status <~ movie.reactive
        .producer(forKeyPath: #keyPath(Movie.status))
        .map { $0 as? String }.skipNil()
    
    movieURL <~ movie.reactive
      .producer(forKeyPath: #keyPath(Movie.url))
      .map { $0
        .flatMap { $0 as? String }
        .flatMap(URL.init)
      }.skipNil()
  }
}

private extension MovieCompositionViewModel {
  
  func consume(action: CompositionAction) {
    weak var weak = self
    
    switch action {
    case .choose(let index):
      let smth = selectVideo?.apply()
        .on(value: { info in
          guard let data = try? Data(contentsOf: info.url) else { fatalError("Cannot read from \(info.url)") }
          weak?.upload(data: data, at: index)
        })
      smth?.start()
    }
  }
}

private extension MovieCompositionViewModel {
  
  static let map = [1: "data1",
                    2: "data2",
                    3: "data3"]
  
  func upload(data: Data, at index: Int) {
    do {
      try realm.write {
        guard let path = MovieCompositionViewModel.map[index] else { fatalError("invalid keypath") }
        movie[path] = data
      }
    } catch { fatalError(error.localizedDescription) }
  }
}
