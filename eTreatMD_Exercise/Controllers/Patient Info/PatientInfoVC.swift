//
//  PatientInfoVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class PatientInfoVC: UIViewController {
    //-----------------
    // MARK: - Variables
    //-----------------
    var patient: Patient?
    
    //-----------------
    // MARK: - UIOutlets
    //-----------------
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let patient = patient else { return }
        print("XXXX")
        print(patient.name)
        print(patient.id)
    }

}
