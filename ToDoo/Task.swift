//
//  ToDo.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 10.07.2024.
//

import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var category: String
    var doneBy: Date?
}
