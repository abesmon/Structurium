//
//  CollectionViewDriver.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

public class CollectionViewDriver: NSObject {
    private let sectionDescriptions: [SectionDescription]

    private var registeredCells: [String] = []
    private var registeredViews: [String] = []
    private weak var currentCollectionView: UICollectionView?
    public weak var scrollViewNextDelegate: UIScrollViewDelegate?

    public init(sectionDescriptions: [SectionDescription]) {
        self.sectionDescriptions = sectionDescriptions
    }

    deinit {
        unbindCurrent()
    }

    public func setup(collectionView: UICollectionView) {
        unbindCurrent()
        currentCollectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self

        for section in sectionDescriptions {
            if let header = section.headerCell {
                collectionView.register(header.0,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: header.1)
                registeredViews.append(header.1)
            }
            collectionView.register(section.cell.0, forCellWithReuseIdentifier: section.cell.1)
            registeredCells.append(section.cell.1)
        }
    }

    public func unbindCurrent() {
        defer {
            registeredCells = []
            registeredViews = []
        }

        guard let currentCollectionView = currentCollectionView else {
            return
        }

        for registeredCell in registeredCells {
            currentCollectionView.register(nil as AnyClass?, forCellWithReuseIdentifier: registeredCell)
        }
        for registeredView in registeredViews {
            currentCollectionView.register(nil as AnyClass?,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                           withReuseIdentifier: registeredView)
        }
    }
}

extension CollectionViewDriver: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionDescription = sectionDescriptions[indexPath.section]
        guard let headerCell = sectionDescription.headerCell else { return UICollectionReusableView() }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell.1, for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionDescription = sectionDescriptions[indexPath.section]
        return collectionView.dequeueReusableCell(withReuseIdentifier: sectionDescription.cell.1, for: indexPath)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int { sectionDescriptions.count }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionDescriptions[section].contentBinder.numberOfItems()
    }
}

extension CollectionViewDriver: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sectionDescriptions[indexPath.section].contentBinder.willDisplayCell(cell, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            sectionDescriptions[indexPath.section].headerContentBinder?.willDisplayHeader(view, indexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sectionDescriptions[indexPath.section].contentBinder.didSelectItemAt?(indexPath)
    }
}

extension CollectionViewDriver: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        sectionDescriptions[indexPath.section].cellSize(collectionView, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionDescriptions[section].inset()
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionDescriptions[section].minSpacings.line
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionDescriptions[section].minSpacings.item
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        sectionDescriptions[section].referenceSizeForHeader?(collectionView) ?? .zero
    }
}

extension CollectionViewDriver: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer { scrollViewNextDelegate?.scrollViewDidScroll?(scrollView) }
        calculatePinned(scrollView)
    }

    private func calculatePinned(_ scrollView: UIScrollView) {
        let minimalContentOffset: CGFloat = 5
        let diffRangeToPin = CGFloat(-3)...CGFloat(3)
        guard let collectionView = scrollView as? UICollectionView else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let headers = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
            for header in headers {
                guard let header = header as? (PinableCell & UICollectionReusableView) else { return }
                guard collectionView.contentOffset.y > minimalContentOffset else {
                    header.setPinned(false)
                    return
                }
                let frame = header.frame
                let headerAndOffsetDiff = frame.origin.y - collectionView.contentOffset.y
                header.setPinned(diffRangeToPin.contains(headerAndOffsetDiff))
                break
            }
        }
    }
}
