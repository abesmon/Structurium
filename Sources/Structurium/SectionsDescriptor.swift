//
//  SectionsDescriptor.swift
//  
//
//  Created by Алексей Лысенко on 01.09.2023.
//

import Foundation

public protocol SectionsDescriptor {
    var sections: [any SectionDescription] { get }
}
