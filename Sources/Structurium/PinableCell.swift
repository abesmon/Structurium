//
//  PinableCell.swift
//  HomeChannel
//
//  Created by Алексей Лысенко on 20.12.2022.
//

import Foundation

protocol PinableCell: AnyObject {
    func setPinned(_ isPinned: Bool)
}
