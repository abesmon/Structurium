//
//  SectionContentBinder.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

public protocol SectionContentBinder {
    associatedtype CellType: UICollectionViewCell

    func numberOfItems() -> Int
    func willDisplayCell(_ cell: CellType, at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
}

internal extension SectionContentBinder {
    func willDisplayCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let safeCell = cell as? CellType else { return }
        willDisplayCell(safeCell, at: indexPath)
    }
}
