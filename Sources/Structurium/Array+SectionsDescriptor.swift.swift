//
//  Array+SectionsDescriptor.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import Foundation

extension Array: SectionsDescriptor where Element == any SectionDescription {
    public var sections: [any SectionDescription] { self }
    public func updateSections() -> [any SectionDescription] { self }
}
