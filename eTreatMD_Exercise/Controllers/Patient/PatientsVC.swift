//
//  PatientVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class PatientsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPatients()
    }
    

    func getPatients() {
        PatientsService.patientsService.getPatients { (patients) in
            guard let patients = patients else { return }
            for patient in patients {
                print("YYY")
                print(patient.name)
                print(patient.id)
            }
        }
    }

}
