//
//  TypicalView+Void.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 06.02.2023.
//

import Foundation

public extension TypicalView where Delegate == Void {
    func set(delegate: Delegate) {}
}

public extension TypicalView where ContentType == Void {
    func set(content: ContentType) {}
}
