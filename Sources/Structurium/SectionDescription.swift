//
//  SectionDescription.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

public protocol SectionDescription {
    var headerCell: (AnyClass, String)? { get }
    var referenceSizeForHeader: ((UICollectionView) -> CGSize)? { get }
    var cell: (AnyClass, String) { get }
    var cellSize: (UICollectionView, IndexPath) -> CGSize { get }
    var inset: () -> UIEdgeInsets { get }
    var minSpacings: (line: CGFloat, item: CGFloat) { get }

    var contentBinder: SectionContentBinder { get }
    var headerContentBinder: HeaderContentBinder? { get }
}
