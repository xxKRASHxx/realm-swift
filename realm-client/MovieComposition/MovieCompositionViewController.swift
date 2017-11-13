//
//  MovieCompositionViewController.swift
//  realm-client
//
//  Created by Danil Lisovoy on 11/1/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class MovieCompositionViewController: UIViewController {
  
  var viewModel: MovieCompositionViewModel!
  
  @IBOutlet weak var idLabel: UILabel!
  
  @IBOutlet weak var playButton: UIButton!
  
  @IBOutlet weak var firstButton: UIButton!
  @IBOutlet weak var secondButton: UIButton!
  @IBOutlet weak var thirdButton: UIButton!
  
  var buttons: [UIButton] {
    return [firstButton, secondButton, thirdButton]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

extension MovieCompositionViewController {
  
  func setup() {
    setupBinding()
    setupActions()
  }
  
  func setupBinding() {
    navigationItem.reactive.title <~ viewModel.status
    idLabel.reactive.text <~ viewModel.movieId
    playButton.reactive.title(for: .normal) <~ viewModel.movieURL.map { $0?.absoluteString ?? "None" }
  }
  
  func setupActions() {
    let actions = (1...buttons.count).map { CocoaAction<UIButton>(self.viewModel.choose, input:$0) }
    buttons.apply(values: actions) { $0.reactive.pressed = $1 }
    
    playButton.reactive.pressed =
      CocoaAction<UIButton>(self.viewModel.play!, input:self.viewModel.movieURL.value)
  }
}
