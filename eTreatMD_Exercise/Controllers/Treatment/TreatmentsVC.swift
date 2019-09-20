//
//  TreatmentVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class TreatmentsVC: UIViewController {
    //-----------------
    // MARK: - Variables
    //-----------------
    var treatments = [Treatment]()
    
    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var treatmentsTableView: UITableView! {
        didSet {
            treatmentsTableView.delegate = self
            treatmentsTableView.dataSource = self
            treatmentsTableView.register(UINib(nibName: TreatmentTVCell.nibName, bundle: nil), forCellReuseIdentifier: TreatmentTVCell.reuseIdentifier)
            
            treatmentsTableView.separatorStyle = .none
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(getTreatments), for: .valueChanged)
            treatmentsTableView.refreshControl = refreshControl
        }
    }
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()

        getTreatments()
    }
}

//-----------------
// MARK: - API Requests
//-----------------
extension TreatmentsVC {
    @objc func getTreatments() {
        treatmentsTableView.refreshControl?.beginRefreshing()
        TreatmentsService.treatmentsService.getTreatments { [weak self] (treatments) in
            guard let `self` = self else { return }
            guard let treatments = treatments else {
                DispatchQueue.main.async {
                    self.treatmentsTableView.reloadData()
                    UIView.animate(withDuration: 1.0, animations: {
                        self.treatmentsTableView.refreshControl?.endRefreshing()
                    })
                }
                return
            }
            DispatchQueue.main.async {
                self.treatments = treatments
                self.treatmentsTableView.reloadData()
                UIView.animate(withDuration: 1.0, animations: {
                    self.treatmentsTableView.refreshControl?.endRefreshing()
                })
            }
        }
    }
}

//-----------------
// MARK: - UITableView Delegate & DataSource
//-----------------
extension TreatmentsVC: UITableViewDelegate, UITableViewDataSource {
    //-----------------
    // MARK: - UITableView DataSource
    //-----------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treatments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TreatmentTVCell.reuseIdentifier, for: indexPath) as! TreatmentTVCell
        
        let treatment = treatments[indexPath.row]
        cell.setUp(with: treatment)
        
        return cell
    }
    
    //-----------------
    // MARK: - UITableView Delegate
    //-----------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let treatment = treatments[indexPath.row]
        guard let name = treatment.name, let amount = treatment.amount, let unit = treatment.unit else { return }
        print("You have selected: \(name), \(amount) \(unit)")
    }
}
