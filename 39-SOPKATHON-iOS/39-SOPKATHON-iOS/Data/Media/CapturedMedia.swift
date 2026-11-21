//
//  CapturedMedia.swift
//  39-SOPKATHON-iOS
//
//  Created by SeongHwan on 11/21/26.
//

import UIKit

enum CapturedMedia {
    case photo(UIImage)
    /// 앱 임시 폴더로 옮겨 둔 원본 영상 파일. 다 쓰면 호출한 쪽에서 삭제해야 함.
    case video(URL)
}
