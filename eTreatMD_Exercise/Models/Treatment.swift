//
//  Treatment.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import Foundation

class Treatment: Codable {
    var name: String?
    var unit: String?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case unit = "unit"
        case amount = "amount"
    }
}
