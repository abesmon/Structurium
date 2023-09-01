import XCTest
import UIKit
@testable import Structurium

final class StructuriumTests: XCTestCase {
    func testCreateDriver() throws {
        let driver = CollectionViewDriver(sectionDescriptions: [])
        print(driver)
    }

    func testCreateSections() throws {
        let section = BasicSectionDescription(
            cell: (UICollectionViewCell.self, "cell"),
            cellSize: { _, _ in
                    .zero
            },
            inset: UIEdgeInsets.zero,
            minSpacings: (0, 0),
            contentBinder: BasicSectionContentBinder(
                numberOfItems: 1,
                willDisplayCell: { _, _ in
                    print("will display")
                },
                didSelectItemAt: { _ in
                    print("did select")
                }
            )
        )
        print(section)
    }
}
