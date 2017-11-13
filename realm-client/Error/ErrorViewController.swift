//
//  ErrorViewController.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/26/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import UIKit
import Foundation
import Result

private enum NoError: Error { case none }

class ErrorViewController: UIViewController {
  
  var error: AnyError
  @IBOutlet weak var errorLabel: UILabel!
  
  init(any error: AnyError) {
    self.error = error
    super.init(nibName: "ErrorViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    error = AnyError(NoError.none)
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    errorLabel.text = error.localizedDescription
  }
}
