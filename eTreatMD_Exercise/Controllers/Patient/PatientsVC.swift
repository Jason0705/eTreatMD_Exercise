//
//  PatientVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class PatientsVC: UIViewController {
    //-----------------
    // MARK: - Variables
    //-----------------
    var patients = [Patient]()
    var selectedPatient: Patient?
    
    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var patientsTableView: UITableView! {
        didSet {
            patientsTableView.delegate = self
            patientsTableView.dataSource = self
            patientsTableView.register(UINib(nibName: PatientTVCell.nibName, bundle: nil), forCellReuseIdentifier: PatientTVCell.reuseIdentifier)
            
            patientsTableView.separatorStyle = .none
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(getPatients), for: .valueChanged)
            patientsTableView.refreshControl = refreshControl
        }
    }
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPatients()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patientVCToPatientInfoVC" {
            guard let destination = segue.destination as? PatientInfoVC else { return }
            destination.patient = selectedPatient
        }
    }
}

//-----------------
// MARK: - API Requests
//-----------------
extension PatientsVC {
    @objc func getPatients() {
        patientsTableView.refreshControl?.beginRefreshing()
        PatientsService.patientsService.getPatients { [weak self] (patients) in
            guard let `self` = self else { return }
            guard let patients = patients else {
                DispatchQueue.main.async {
                    self.patientsTableView.reloadData()
                    UIView.animate(withDuration: 1.0, animations: {
                        self.patientsTableView.refreshControl?.endRefreshing()
                    })
                }
                return
            }
            DispatchQueue.main.async {
                self.patients = patients
                self.patientsTableView.reloadData()
                UIView.animate(withDuration: 1.0, animations: {
                    self.patientsTableView.refreshControl?.endRefreshing()
                })
            }
        }
    }
}

//-----------------
// MARK: - UITableView Delegate & DataSource
//-----------------
extension PatientsVC: UITableViewDelegate, UITableViewDataSource {
    //-----------------
    // MARK: - UITableView DataSource
    //-----------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientTVCell.reuseIdentifier, for: indexPath) as! PatientTVCell
        
        let patient = patients[indexPath.row]
        cell.setUp(with: patient)
        
        return cell
    }
    
    //-----------------
    // MARK: - UITableView Delegate
    //-----------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedPatient = patients[indexPath.row]
        performSegue(withIdentifier: "patientVCToPatientInfoVC", sender: self)
    }
}
