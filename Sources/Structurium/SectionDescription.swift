//
//  SectionDescription.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

public protocol SectionDescription {
    associatedtype HeaderCell: UICollectionReusableView
    associatedtype CellClass: UICollectionViewCell
    associatedtype SectionContentBinderType: SectionContentBinder where SectionContentBinderType.CellType == CellClass
    associatedtype HeaderContentBinderType: HeaderContentBinder where HeaderContentBinderType.HeaderType == HeaderCell

    var headerCell: (HeaderCell.Type, String)? { get }
    var referenceSizeForHeader: ((UICollectionView) -> CGSize)? { get }
    var cell: (CellClass.Type, String) { get }
    var cellSize: (UICollectionView, IndexPath) -> CGSize { get }
    var inset: () -> UIEdgeInsets { get }
    var minSpacings: (line: CGFloat, item: CGFloat) { get }

    var contentBinder: SectionContentBinderType { get }
    var headerContentBinder: HeaderContentBinderType? { get }
}
