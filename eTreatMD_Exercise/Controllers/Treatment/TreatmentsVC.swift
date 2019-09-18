//
//  TreatmentVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class TreatmentsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getTreatments()
    }
    
    func getTreatments() {
        TreatmentsService.treatmentsService.getTreatments { (treatments) in
            guard let treatments = treatments else { return }
            
            for treatment in treatments {
                print("XXX")
                print(treatment.name)
                print(treatment.amount)
                print(treatment.unit)
            }
        }
    }

}
