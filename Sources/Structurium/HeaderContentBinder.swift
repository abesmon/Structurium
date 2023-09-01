//
//  HeaderContentBinder.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 27.12.2022.
//

import UIKit

public protocol HeaderContentBinder {
    associatedtype HeaderType: UICollectionReusableView

    func willDisplayHeader(_ view: HeaderType, at indexPath: IndexPath)
}

extension HeaderContentBinder {
    func willDisplayHeader(_ view: UICollectionReusableView, at indexPath: IndexPath) {
        guard let safeView = view as? HeaderType else { return }
        willDisplayHeader(safeView, at: indexPath)
    }
}
