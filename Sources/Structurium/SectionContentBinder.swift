//
//  SectionContentBinder.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

public protocol SectionContentBinder {
    var numberOfItems: () -> Int { get }
    var willDisplayCell: (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void { get }
    var didSelectItemAt: ((_ indexPath: IndexPath) -> Void)? { get }
}
