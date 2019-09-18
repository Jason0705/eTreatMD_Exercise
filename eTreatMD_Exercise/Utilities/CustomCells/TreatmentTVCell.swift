//
//  TreatmentTVCell.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class TreatmentTVCell: UITableViewCell, Reusable {

    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = nil
        infoLbl.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//-----------------
// MARK: - Functions
//-----------------
extension TreatmentTVCell {
    func setUp(with treatment: Treatment) {
        if let name = treatment.name {
            nameLbl.text = name
        }
        
        if let amount = treatment.amount, let unit = treatment.unit {
            infoLbl.text = "\(amount) \(unit)"
        }
    }
}
