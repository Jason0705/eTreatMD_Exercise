//
//  PatientTVCell.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class PatientTVCell: UITableViewCell, Reusable {

    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var nameLbl: UILabel!
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//-----------------
// MARK: - Functions
//-----------------
extension PatientTVCell {
    func setUp(with patient: Patient) {
        if let name = patient.name {
            nameLbl.text = name
        }
    }
}
