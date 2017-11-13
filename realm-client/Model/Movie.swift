//
//  TaskList.swift
//  realm-client
//
//  Created by Danil Lisovoy on 10/24/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import RealmSwift

// MARK: Model

enum ProcessingStatus: String {
  case pending
  case uploading
  case processing
  case processed
  case error
}

final class Movie: Object {
  @objc dynamic var id = UUID().uuidString
  
  @objc dynamic var status: String = ProcessingStatus.pending.rawValue
  @objc dynamic var url: String?
  
  @objc dynamic var data1: Data? = nil
  @objc dynamic var data2: Data? = nil
  @objc dynamic var data3: Data? = nil
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
