import XCTest
import UIKit
@testable import Structurium

final class StructuriumTests: XCTestCase {
    func testCreateDriver() throws {
        let driver = CollectionViewDriver(descriptor: [])
        debugPrint(driver)
    }

    func testCreateDriverWithBuilder() {
        var soo: String?
        soo = "s"

        let driver = CollectionViewDriver {
            BasicSectionDescription(
                cell: UICollectionViewCell.self,
                cellId: "cell",
                cellSize: { _, _ in .zero },
                inset: .zero,
                minSpacings: (0, 0),
                contentBinder: BasicSectionContentBinder(
                    numberOfItems: { 1 },
                    willDisplayCell: { _, _ in print("will display") },
                    didSelectItemAt: { _ in print("did select") }
                )
            )

            [
                // На случай если надо зарегать одну ячейку, обычно это всякие скролы внутри скроллов
                BasicSectionDescription(
                    oneCell: UICollectionViewCell.self,
                    cellId: "cell",
                    cellSize: { _, _ in .zero },
                    inset: .zero,
                    contentBinder: BasicSectionContentBinder(
                        numberOfItems: { 1 },
                        willDisplayCell: { _, _ in print("will display") },
                        didSelectItemAt: { _ in print("did select") }
                    )
                ),
                BasicSectionDescription(
                    headerCell: UICollectionReusableView.self,
                    headerCellId: "headerCell",
                    referenceSizeForHeader: { _ in
                            .init(width: 10, height: 10)
                    },
                    cell: UICollectionViewCell.self,
                    cellId: "cell",
                    cellSize: { _, _ in
                            .init(width: 20, height: 20)
                    },
                    inset: .zero,
                    minSpacings: (10, 10),
                    contentBinder: BasicSectionContentBinder(
                        numberOfItems: { 100 },
                        willDisplayCell: { _, _ in print("will display") },
                        didSelectItemAt: { _ in print("did select") }
                    ),
                    headerContentBinder: BasicHeaderContentBinder { _, _ in print("willDisplayHeader") }
                )
            ]

            if soo != nil {
                BasicSectionDescription(
                    cell: UICollectionViewCell.self,
                    cellSize: { _, _ in .zero },
                    inset: .zero,
                    minSpacings: (0, 0),
                    contentBinder: BasicSectionContentBinder(
                        numberOfItems: { 1 },
                        willDisplayCell: { _, _ in print("will display") },
                        didSelectItemAt: { _ in print("did select") }
                    )
                )
            }

            if Date() > Date(timeIntervalSince1970: 100) {
                BasicSectionDescription(
                    oneCell: UICollectionViewCell.self,
                    cellSize: { _, _ in .zero },
                    inset: .zero,
                    contentBinder: BasicSectionContentBinder(
                        numberOfItems: { 1 },
                        willDisplayCell: { _, _ in print("will display") },
                        didSelectItemAt: { _ in print("did select") }
                    )
                )
            } else {
                BasicSectionDescription(
                    headerCell: UICollectionReusableView.self,
                    referenceSizeForHeader: { _ in
                            .init(width: 10, height: 10)
                    },
                    cell: UICollectionViewCell.self,
                    cellSize: { _, _ in
                            .init(width: 20, height: 20)
                    },
                    inset: .zero,
                    minSpacings: (10, 10),
                    contentBinder: BasicSectionContentBinder(
                        numberOfItems: { 100 },
                        willDisplayCell: { _, _ in print("will display") },
                        didSelectItemAt: { _ in print("did select") }
                    ),
                    headerContentBinder: BasicHeaderContentBinder { _, _ in print("willDisplayHeader") }
                )
            }
        }
        debugPrint(driver)
    }

    func testCreateSections() throws {
        let section = BasicSectionDescription(
            cell: UICollectionViewCell.self,
            cellId: "cell",
            cellSize: { _, _ in
                    .zero
            },
            inset: UIEdgeInsets.zero,
            minSpacings: (0, 0),
            contentBinder: BasicSectionContentBinder(
                numberOfItems: 1,
                willDisplayCell: { _, _ in print("will display") },
                didSelectItemAt: { _ in print("did select") }
            )
        )

        debugPrint(section)
    }
}
