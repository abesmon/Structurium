//
//  Array+SectionsDescriptor.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import Foundation

extension Array: SectionsDescriptor where Element == SectionDescription {
    public var sections: [SectionDescription] { self }
    public func updateSections() -> [SectionDescription] { self }
}
