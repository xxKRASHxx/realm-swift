//
//  ViewController.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/24/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ReactiveSwift
import ReactiveCocoa
import Result

class MovieListViewController: UITableViewController {
  
  var viewModel: MovieListViewModel!
  
  @IBOutlet weak var addMovieButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupObserving()
  }
  
  func setupObserving() {
    self.tableView.reactive.reloadData <~ viewModel.movies.map { _ in () }.signal
    addMovieButton.reactive.pressed = viewModel.action(for: .create) =>> CocoaAction.init
  }
}

extension MovieListViewController {
  
  override func tableView(_ tableView: UITableView?,
                          numberOfRowsInSection section: Int) -> Int {
    return viewModel.movies.value.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let item = viewModel.movies.value[indexPath.row]
    cell.textLabel?.text = item.id
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    viewModel.consume(action: .delete(at: indexPath.row))
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    viewModel.consume(action: .open(at: indexPath.row))
  }
  
  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}
