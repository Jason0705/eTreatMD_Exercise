//
//  PatientsService.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import Foundation

class PatientsService {
    
    static var patientsService = PatientsService()
    
    private let PATIENTS_URL_STRING = "https://api.myjson.com/bins/zhp9h"
    
    func getPatients(completion: @escaping ([Patient]?) -> Void) {
        guard let url = URL(string: PATIENTS_URL_STRING) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("DataTask Error: \(error.localizedDescription)")
                    completion(nil)
                } else if let data = data {
                    do {
                        print("DATA: \(String(data: data, encoding: .utf8)!)")
                        let patients = try JSONDecoder().decode([Patient].self, from: data)
                        completion(patients)
                    } catch let error {
                        print("JSONDecoding Error: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
                }.resume()
        } catch let error {
            print("JSONSerialization Error: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
}
