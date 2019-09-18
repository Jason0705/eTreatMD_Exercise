//
//  Patient.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import Foundation

class Patient: Codable {
    var name: String?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}
