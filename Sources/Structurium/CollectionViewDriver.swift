//
//  CollectionViewDriver.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 19.12.2022.
//

import UIKit

@resultBuilder
public struct SectionDescriptionBuilder {
    public static func buildBlock(_ components: [any SectionDescription]...) -> [any SectionDescription] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: any SectionDescription) -> [any SectionDescription] {
        [expression]
    }

    public static func buildExpression(_ expression: [any SectionDescription]) -> [any SectionDescription] {
        expression
    }

    public static func buildOptional(_ component: [any SectionDescription]?) -> [any SectionDescription] {
        component ?? []
    }

    public static func buildEither(first component: [any SectionDescription]) -> [any SectionDescription] {
        component
    }

    public static func buildEither(second component: [any SectionDescription]) -> [any SectionDescription] {
        component
    }

    public static func buildArray(_ components: [[any SectionDescription]]) -> [any SectionDescription] {
        components.flatMap { $0 }
    }

    public static func buildLimitedAvailability(_ component: [any SectionDescription]) -> [any SectionDescription] {
        component
    }
}

public class CollectionViewDriver: NSObject {
    struct DynamicDescriptor: SectionsDescriptor {
        var sections: [any SectionDescription] { builder() }
        let builder: () -> [any SectionDescription]

        init(@SectionDescriptionBuilder builder: @escaping () -> [any SectionDescription]) {
            self.builder = builder
        }
    }

    private let descriptor: SectionsDescriptor
    private var sectionsDescriptionsCache: [any SectionDescription] = []

    private var registeredCells: [String] = []
    private var registeredViews: [String] = []
    private weak var currentCollectionView: UICollectionView?
    public weak var scrollViewNextDelegate: UIScrollViewDelegate?

    public init(descriptor: SectionsDescriptor) {
        self.descriptor = descriptor
        super.init()
        self.updateCache()
    }

    public convenience init(@SectionDescriptionBuilder builder: @escaping () -> [any SectionDescription]) {
        self.init(descriptor: DynamicDescriptor(builder: builder))
    }

    deinit {
        unbindCurrent()
    }

    public func setup(collectionView: UICollectionView) {
        unbindCurrent()
        currentCollectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self

        reloadSections()
    }

    public func unbindCurrent() {
        defer {
            registeredCells = []
            registeredViews = []
        }

        guard let currentCollectionView = currentCollectionView else { return }

        for registeredCell in registeredCells {
            currentCollectionView.register(nil as AnyClass?, forCellWithReuseIdentifier: registeredCell)
        }
        for registeredView in registeredViews {
            currentCollectionView.register(nil as AnyClass?,
                                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                           withReuseIdentifier: registeredView)
        }
    }

    public func reloadSections() {
        guard let collectionView = currentCollectionView else { return }
        reloadSections(collectionView: collectionView)
    }

    private func updateCache() {
        sectionsDescriptionsCache = descriptor.sections
    }

    private func reloadSections(collectionView: UICollectionView) {
        updateCache()
        for section in sectionsDescriptionsCache {
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

    public override var debugDescription: String {
        """
        descriptor: \(descriptor)
        cache: \(sectionsDescriptionsCache)
        registeredCells: \(registeredCells)
        registeredViews: \(registeredViews)
        currentCollectionView: \(String(describing: currentCollectionView))
        nextDelegate: \(String(describing: scrollViewNextDelegate))
        """
    }
}

extension CollectionViewDriver: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionDescription = sectionsDescriptionsCache[indexPath.section]
        guard let headerCell = sectionDescription.headerCell else { return UICollectionReusableView() }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell.1, for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionDescription = sectionsDescriptionsCache[indexPath.section]
        return collectionView.dequeueReusableCell(withReuseIdentifier: sectionDescription.cell.1, for: indexPath)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int { sectionsDescriptionsCache.count }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (sectionsDescriptionsCache[section].contentBinder as any SectionContentBinder).numberOfItems()
    }
}

extension CollectionViewDriver: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (sectionsDescriptionsCache[indexPath.section].contentBinder as any SectionContentBinder).willDisplayCell(cell, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            (sectionsDescriptionsCache[indexPath.section].headerContentBinder as (any HeaderContentBinder)?)?.willDisplayHeader(view, at: indexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (sectionsDescriptionsCache[indexPath.section].contentBinder as any SectionContentBinder).didSelectItem(at: indexPath)
    }
}

extension CollectionViewDriver: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        sectionsDescriptionsCache[indexPath.section].cellSize(collectionView, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionsDescriptionsCache[section].inset()
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionsDescriptionsCache[section].minSpacings.line
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionsDescriptionsCache[section].minSpacings.item
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        sectionsDescriptionsCache[section].referenceSizeForHeader?(collectionView) ?? .zero
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
