//
//  MovieListViewModel.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/25/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ReactiveSwift
import ReactiveCocoa
import Result

class MovieListViewModel {
  
  enum MovieAction {
    case create
    case open(at: Int)
    case delete(at: Int)
  }
  
  enum MovieResult {
    case open(movie: Movie)
  }
  
  var realm: Realm
  var movies: MutableProperty<Results<Movie>>
  let actionSignal: Signal<MovieResult, NoError>
  private let resultObserver: Signal<MovieResult, NoError>.Observer
  private var notificationToken: NotificationToken?
  
  init(realm: Realm) {
    self.realm = realm
    movies = MutableProperty(realm.objects(Movie.self))
    (self.actionSignal, self.resultObserver) = Signal<MovieResult, NoError>.pipe()
    setupObserving()
  }
  
  deinit {
    self.notificationToken?.invalidate()
  }
}

extension MovieListViewModel {
  
  func consume(action: MovieAction) {
    switch action {
    case .create: new()
    case .open(let index): open(at: index)
    case .delete(let index): remove(at: index)
    }
  }
  
  func action(for action: MovieListViewModel.MovieAction) -> Action<(), (), NoError> {
    weak var dispatcher = self
    return Action {
      return SignalProducer<(), NoError> { dispatcher?.consume(action: action) }
    }
  }
}

private extension MovieListViewModel {
  
  func setupObserving() {
    self.notificationToken = observer(weak: self) =>> self.realm.observe
  }
  
  func observer(weak: MovieListViewModel) -> NotificationBlock {
    weak var observeer = weak
    return { _, realm in
      observeer?.movies.value = realm.objects(Movie.self)
    }
  }
}

private extension MovieListViewModel {
  
  func new() {
    let movie = Movie()
    try! realm.write {
      realm.add(movie)  
      open(movie: movie)
    }
  }
  
  func remove(at index: Int) {
    try! realm.write {
      realm.delete(self.movies.value[index])
    }
  }
  
  func open(movie: Movie) {
    resultObserver.send(value: .open(movie: movie))
  }
    
  func open(at index: Int) {
    let movie = self.movies.value[index]
    resultObserver.send(value: .open(movie: movie))
  }
}
