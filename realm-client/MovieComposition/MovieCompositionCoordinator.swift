//
//  MovieCompositionCoordinator.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/31/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result
import AVKit

class MovieCompositionCoordinator: NSObject {
  
  let presenter: UINavigationController
  private var compositionViewController: UIViewController!
  
  private lazy var imagePickerController: UIImagePickerController = {
    let controller = UIImagePickerController()
    controller.modalPresentationStyle = .popover
    controller.sourceType = .photoLibrary
    controller.mediaTypes = ["public.movie"]
    controller.delegate = self
    return controller
  }()
  
  private let observer: Signal<MediaInfo, AnyError>.Observer
  private let signal: Signal<MediaInfo, AnyError>
  
  private let (playSignal, playObserver) = Signal<Void, NoError>.pipe()
  
  lazy var chooseVideo: Action<Void, MediaInfo, AnyError> = {
    Action { _ in
      self.presenter.present(self.imagePickerController,
                             animated: true, completion: nil)
      return self.signal.producer
    }
  }()
  
  lazy var play: Action<URL?, Void, NoError> = {
    Action<URL?, Void, NoError> { url in
      
      guard let url = url else {
        self.playObserver.sendCompleted()
        return SignalProducer(self.playSignal)
      }
      
      try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      
      let playerController:AVPlayerViewController = {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: url)
        return controller
      }()
      
      self.presenter.present(
        playerController,
        animated: true,
        completion: {
          playerController.player?.play()
          self.playObserver.sendCompleted()
        })
      
      return SignalProducer(self.playSignal)
    }
  }()
  
  init(presenter: UINavigationController, movie: Movie) {
    self.presenter = presenter
    (self.signal, self.observer) = Signal.pipe()
    super.init()
    let generateViewModel: (Movie) -> MovieCompositionViewModel = { movie in
      let viewModel = MovieCompositionViewModel(with: movie)
      viewModel.selectVideo = self.chooseVideo
      viewModel.play = self.play
      return viewModel
    }
    self.compositionViewController =
      movie
      =>> generateViewModel
      =>> MovieCompositionViewController.with
  }
}

extension MovieCompositionCoordinator: Coordinator {
  
  func start(animated: Bool) {
    presenter.pushViewController(compositionViewController, animated: animated)
  }
}

extension MovieCompositionCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    MediaInfo.from(info: info)
      .do(self.observer.send)
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.observer.send(error: AnyError(NSError()))
    picker.dismiss(animated: true)
  }
}

private extension MovieCompositionViewController {
  static func with(viewModel: MovieCompositionViewModel) -> MovieCompositionViewController {
    guard let viewController =
      UIStoryboard(name: "MovieSelection", bundle: nil)
        .instantiateViewController(withIdentifier: "MovieCompositionViewController")
        as? MovieCompositionViewController
      else { fatalError() }
    viewController.viewModel = viewModel
    return viewController
  }
}
