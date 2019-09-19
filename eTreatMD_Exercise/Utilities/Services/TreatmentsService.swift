//
//  TreatmentsService.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import Foundation

class TreatmentsService {
    
    static var treatmentsService = TreatmentsService()
    
    private let TREATMENTS_URL_STRING = "https://test.livewithacne.com/media/steps/treatment.json"
    private let SECONDARY_TREATMENTS_URL_STRING = "https://api.myjson.com/bins/rr2ed"
    
    func getTreatments(completion: @escaping ([Treatment]?) -> Void) {
        guard let url = URL(string: TREATMENTS_URL_STRING) else {
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
//                        print("DATA: \(String(data: data, encoding: .utf8)!)")
                        let treatments = try JSONDecoder().decode([Treatment].self, from: data)
                        completion(treatments)
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
