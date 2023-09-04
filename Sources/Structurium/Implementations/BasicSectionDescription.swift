//
//  BasicSectionDescription.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicSectionDescription<T, U, SectionContentBinderType, HeaderContentBinderType>: SectionDescription
where T: UICollectionViewCell, U: UICollectionReusableView,
      SectionContentBinderType: SectionContentBinder, SectionContentBinderType.CellType == T,
      HeaderContentBinderType: HeaderContentBinder, HeaderContentBinderType.HeaderType == U
{
    public let headerCell: (U.Type, String)?
    public let referenceSizeForHeader: ((UICollectionView) -> CGSize)?
    public let cell: (T.Type, String)
    public let cellSize: (UICollectionView, IndexPath) -> CGSize
    public let inset: () -> UIEdgeInsets
    public let minSpacings: (line: CGFloat, item: CGFloat)

    public let contentBinder: SectionContentBinderType
    public let headerContentBinder: HeaderContentBinderType?


    // MARK: - with headers
    public init(
        headerCell: U.Type = U.self,
        headerCellId: String = String(describing: U.self),
        referenceSizeForHeader: (@escaping (UICollectionView) -> CGSize),
        cell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping @autoclosure () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinderType,
        headerContentBinder: HeaderContentBinderType
    ) {
        self.init(
            headerCellOpt: (headerCell, headerCellId),
            referenceSizeForHeader: referenceSizeForHeader,
            cell: (cell, cellId),
            cellSize: cellSize,
            inset: inset,
            minSpacings: minSpacings,
            contentBinder: contentBinder,
            headerContentBinder: headerContentBinder
        )
    }

    // MARK: - optional headers
    private init(
        headerCellOpt: (U.Type, String)? = (U.self, String(describing: U.self)),
        referenceSizeForHeader: ((UICollectionView) -> CGSize)?,
        cell: (T.Type, String) = (T.self, String(describing: T.self)),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinderType,
        headerContentBinder: HeaderContentBinderType?
    ) {
        self.headerCell = headerCellOpt
        self.referenceSizeForHeader = referenceSizeForHeader
        self.cell = cell
        self.cellSize = cellSize
        self.inset = inset
        self.minSpacings = minSpacings
        self.contentBinder = contentBinder
        self.headerContentBinder = headerContentBinder
    }
}

// MARK: without headers
public struct EmptyHeaderConentBinder: HeaderContentBinder {
    public func willDisplayHeader(_ view: UICollectionReusableView, at indexPath: IndexPath) {}
}

extension BasicSectionDescription where U == UICollectionReusableView, HeaderContentBinderType == EmptyHeaderConentBinder {
    public init(
        cell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping @autoclosure () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinderType
    ) {
        self.init(
            headerCellOpt: nil,
            referenceSizeForHeader: nil,
            cell: (cell, cellId),
            cellSize: cellSize,
            inset: inset,
            minSpacings: minSpacings,
            contentBinder: contentBinder,
            headerContentBinder: nil
        )
    }

    /// For scenarios like one celled horizontal scroll
    public init(
        oneCell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView) -> CGSize,
        inset: @escaping @autoclosure () -> UIEdgeInsets,
        contentBinder: SectionContentBinderType
    ) {
        self.init(
            headerCellOpt: nil,
            referenceSizeForHeader: nil,
            cell: (oneCell, cellId),
            cellSize: { collection, _ in cellSize(collection) },
            inset: inset,
            minSpacings: (0, 0),
            contentBinder: contentBinder,
            headerContentBinder: nil
        )
    }
}
