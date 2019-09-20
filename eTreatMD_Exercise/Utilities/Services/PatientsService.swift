//
//  PatientsService.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import Foundation

class PatientsService {
    
    static var patientsService = PatientsService()
    
    private let PATIENTS_URL_STRING = "https://test.livewithacne.com/media/steps/patients.json"
//    private let SECONDARY_PATIENTS_URL_STRING = "https://api.myjson.com/bins/zhp9h"
    
    func getPatients(completion: @escaping ([Patient]?) -> Void) {
        guard let url = URL(string: PATIENTS_URL_STRING) else {
            getPatientsFromFile { (patients) in
                completion(patients)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let `self` = self else { return }
                if let error = error {
                    print("DataTask Error: \(error.localizedDescription)")
                    self.getPatientsFromFile { (patients) in
                        completion(patients)
                    }
                } else if let data = data {
                    do {
                        let patients = try JSONDecoder().decode([Patient].self, from: data)
                        completion(patients)
                    } catch let error {
                        print("JSONDecoding Error: \(error.localizedDescription)")
                        self.getPatientsFromFile { (patients) in
                            completion(patients)
                        }
                    }
                } else {
                    self.getPatientsFromFile { (patients) in
                        completion(patients)
                    }
                }
                }.resume()
        } catch let error {
            print("JSONSerialization Error: \(error.localizedDescription)")
            getPatientsFromFile { (patients) in
                completion(patients)
            }
        }
    }
    
    private func getPatientsFromFile(completion: @escaping ([Patient]?) -> Void) {
        if let path = Bundle.main.path(forResource: "patients", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let patients = try JSONDecoder().decode([Patient].self, from: data)
                    completion(patients)
                } catch let error {
                    print("JSONDecoding Error: \(error.localizedDescription)")
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
    }
    
}
