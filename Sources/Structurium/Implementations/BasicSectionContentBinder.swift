//
//  BasicSectionContentBinder.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicSectionContentBinder: SectionContentBinder {
    public let numberOfItems: () -> Int
    public let willDisplayCell: (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    public let didSelectItemAt: ((_ indexPath: IndexPath) -> Void)?

    public init(
        numberOfItems: @escaping @autoclosure () -> Int,
        willDisplayCell: @escaping (_: UICollectionViewCell, _: IndexPath) -> Void = { _, _ in },
        didSelectItemAt: ((_: IndexPath) -> Void)? = nil
    ) {
        self.numberOfItems = numberOfItems
        self.willDisplayCell = willDisplayCell
        self.didSelectItemAt = didSelectItemAt
    }

    public init(
        numberOfItems: @escaping () -> Int,
        willDisplayCell: @escaping (_: UICollectionViewCell, _: IndexPath) -> Void = { _, _ in },
        didSelectItemAt: ((_: IndexPath) -> Void)? = nil
    ) {
        self.numberOfItems = numberOfItems
        self.willDisplayCell = willDisplayCell
        self.didSelectItemAt = didSelectItemAt
    }

    public static func singleSimple(
        willDisplayCell: @escaping (_: UICollectionViewCell, _: IndexPath) -> Void = { _, _ in },
        didSelectItemAt: ((_: IndexPath) -> Void)? = nil
    ) -> BasicSectionContentBinder {
        .init(
            numberOfItems: 1,
            willDisplayCell: willDisplayCell,
            didSelectItemAt: didSelectItemAt
        )
    }
}
