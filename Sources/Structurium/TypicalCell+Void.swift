//
//  TypicalCell+Void.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 06.02.2023.
//

import Foundation

public extension TypicalCell where Delegate == Void {
    func set(delegate: Delegate) {}
}

public extension TypicalCell where ContentType == Void {
    func set(content: ContentType) {}
}
