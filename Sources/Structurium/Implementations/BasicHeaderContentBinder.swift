//
//  BasicHeaderContentBinder.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicHeaderContentBinder: HeaderContentBinder {
    public let willDisplayHeader: ((_ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)

    public init(willDisplayHeader: @escaping ((_ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)) {
        self.willDisplayHeader = willDisplayHeader
    }
}
