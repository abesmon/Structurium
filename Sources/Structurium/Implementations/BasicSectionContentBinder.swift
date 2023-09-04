//
//  BasicSectionContentBinder.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicSectionContentBinder<CellType: UICollectionViewCell>: SectionContentBinder {
    let _numberOfItems: () -> Int
    let _willDisplayCell: (_ cell: CellType, _ indexPath: IndexPath) -> Void
    let _didSelectItemAt: ((_ indexPath: IndexPath) -> Void)?

    public init(
        numberOfItems: @escaping @autoclosure () -> Int,
        willDisplayCell: @escaping (_: CellType, _: IndexPath) -> Void = { _, _ in },
        didSelectItemAt: ((_: IndexPath) -> Void)? = nil
    ) {
        self._numberOfItems = numberOfItems
        self._willDisplayCell = willDisplayCell
        self._didSelectItemAt = didSelectItemAt
    }

    public static func single(
        willDisplayCell: @escaping (_: CellType) -> Void = { _ in },
        didSelectItem: (() -> Void)? = nil
    ) -> BasicSectionContentBinder {
        .init(
            numberOfItems: 1,
            willDisplayCell: { cell, _ in willDisplayCell(cell) },
            didSelectItemAt: { _ in didSelectItem?() }
        )
    }

    public func numberOfItems() -> Int { _numberOfItems() }
    public func willDisplayCell(_ cell: CellType, at indexPath: IndexPath) { _willDisplayCell(cell, indexPath) }
    public func didSelectItem(at indexPath: IndexPath) { _didSelectItemAt?(indexPath) }
}
