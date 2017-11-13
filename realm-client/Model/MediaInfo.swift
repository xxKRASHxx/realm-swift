//
//  MediaInfo.swift
//  realm-client
//
//  Created by Danil Lisovoy on 11/3/17.
//  Copyright © 2017 Danil Lisovoy. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct MediaInfo {
  let url: URL
  let preview: PHAsset?
}

extension MediaInfo {
  static func from(info dictionary: [String: Any]) -> MediaInfo? {
    let assetUrl = dictionary[UIImagePickerControllerPHAsset] as? NSURL
    let fileUrl = dictionary[UIImagePickerControllerMediaURL] as? NSURL
    
    let result = assetUrl?.absoluteURL
      .map { PHAsset.fetchAssets(withALAssetURLs: [$0], options: nil).firstObject }
      .flatten()
    guard let url = fileUrl?.absoluteURL else { return nil }
    
    return MediaInfo(url: url, preview: result)
  }
}
