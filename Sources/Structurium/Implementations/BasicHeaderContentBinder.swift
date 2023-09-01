//
//  BasicHeaderContentBinder.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicHeaderContentBinder<HeaderType: UICollectionReusableView>: HeaderContentBinder {
    let _willDisplayHeader: ((_ view: HeaderType, _ indexPath: IndexPath) -> Void)

    public init(willDisplayHeader: @escaping ((_ view: HeaderType, _ indexPath: IndexPath) -> Void)) {
        self._willDisplayHeader = willDisplayHeader
    }

    public func willDisplayHeader(_ view: HeaderType, at indexPath: IndexPath) {
        _willDisplayHeader(view, indexPath)
    }
}
