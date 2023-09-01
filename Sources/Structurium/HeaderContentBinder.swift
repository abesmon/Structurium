//
//  HeaderContentBinder.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 27.12.2022.
//

import UIKit

public protocol HeaderContentBinder {
    var willDisplayHeader: ((_ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void) { get }
}
