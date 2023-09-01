//
//  BasicSectionDescription.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import UIKit

public struct BasicSectionDescription: SectionDescription {
    public let headerCell: (AnyClass, String)?
    public let referenceSizeForHeader: ((UICollectionView) -> CGSize)?
    public let cell: (AnyClass, String)
    public let cellSize: (UICollectionView, IndexPath) -> CGSize
    public let inset: () -> UIEdgeInsets
    public let minSpacings: (line: CGFloat, item: CGFloat)

    public let contentBinder: SectionContentBinder
    public let headerContentBinder: HeaderContentBinder?


    // MARK: - with headers
    public init<T: UICollectionReusableView, U: UICollectionViewCell>(
        headerCell: T.Type = T.self,
        headerCellId: String = String(describing: T.self),
        referenceSizeForHeader: (@escaping (UICollectionView) -> CGSize),
        cell: U.Type = U.self,
        cellId: String = String(describing: U.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @autoclosure @escaping () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinder,
        headerContentBinder: HeaderContentBinder
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

    // MARK: without headers
    public init<T: UICollectionViewCell>(
        cell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @autoclosure @escaping () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinder
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

    // MARK: - one cell only
    public init<T: UICollectionViewCell>(
        oneCell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @autoclosure @escaping () -> UIEdgeInsets,
        contentBinder: SectionContentBinder
    ) {
        self.init(
            headerCellOpt: nil,
            referenceSizeForHeader: nil,
            cell: (oneCell, cellId),
            cellSize: cellSize,
            inset: inset,
            minSpacings: (0, 0),
            contentBinder: contentBinder,
            headerContentBinder: nil
        )
    }

    public init<T: UICollectionViewCell>(
        oneCell: T.Type = T.self,
        cellId: String = String(describing: T.self),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping () -> UIEdgeInsets,
        contentBinder: SectionContentBinder
    ) {
        self.init(
            headerCellOpt: nil,
            referenceSizeForHeader: nil,
            cell: (oneCell, cellId),
            cellSize: cellSize,
            inset: inset,
            minSpacings: (0, 0),
            contentBinder: contentBinder,
            headerContentBinder: nil
        )
    }

    // MARK: - optional headers
    private init(
        headerCellOpt: (AnyClass, String)?,
        referenceSizeForHeader: ((UICollectionView) -> CGSize)?,
        cell: (AnyClass, String),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinder,
        headerContentBinder: HeaderContentBinder?
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

    private init<T: UICollectionReusableView, U: UICollectionViewCell>(
        headerCellOpt: (T.Type, String) = (T.self, String(describing: T.self)),
        referenceSizeForHeader: ((UICollectionView) -> CGSize)?,
        cell: (U.Type, String) = (U.self, String(describing: T.self)),
        cellSize: @escaping (UICollectionView, IndexPath) -> CGSize,
        inset: @escaping () -> UIEdgeInsets,
        minSpacings: (line: CGFloat, item: CGFloat),
        contentBinder: SectionContentBinder,
        headerContentBinder: HeaderContentBinder?
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
