//
//  TypicalCell.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 24.11.2022.
//

import Foundation

public protocol TypicalCell {
    associatedtype ContentType
    associatedtype Delegate

    func set(content: ContentType)
    func set(delegate: Delegate)
}

public extension TypicalCell {
    func set(anyDelegate: Any) {
        guard let delegate = anyDelegate as? Delegate else { return }
        set(delegate: delegate)
    }

    func set(firstDelegateFrom delegateCandidates: [Any]) {
        guard let first = delegateCandidates.first(where: { delegateCandidate in
            delegateCandidate is Delegate
        }) as? Delegate else { return }
        set(delegate: first)
    }
}
