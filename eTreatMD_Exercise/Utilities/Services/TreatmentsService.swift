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
//    private let SECONDARY_TREATMENTS_URL_STRING = "https://api.myjson.com/bins/rr2ed"
    
    func getTreatments(completion: @escaping ([Treatment]?) -> Void) {
        guard let url = URL(string: TREATMENTS_URL_STRING) else {
            getTreatmentsFromFile { (treatments) in
                completion(treatments)
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
                    self.getTreatmentsFromFile { (treatments) in
                        completion(treatments)
                        }
                } else if let data = data {
                    do {
//                        print("DATA: \(String(data: data, encoding: .utf8)!)")
                        let treatments = try JSONDecoder().decode([Treatment].self, from: data)
                        completion(treatments)
                    } catch let error {
                        print("JSONDecoding Error: \(error.localizedDescription)")
                        self.getTreatmentsFromFile { (treatments) in
                            completion(treatments)
                        }
                    }
                } else {
                    self.getTreatmentsFromFile { (treatments) in
                        completion(treatments)
                    }
                }
                }.resume()
        } catch let error {
            print("JSONSerialization Error: \(error.localizedDescription)")
            getTreatmentsFromFile { (treatments) in
                completion(treatments)
            }
        }
    }
    
    private func getTreatmentsFromFile(completion: @escaping ([Treatment]?) -> Void) {
        if let path = Bundle.main.path(forResource: "treatment", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let treatments = try JSONDecoder().decode([Treatment].self, from: data)
                    completion(treatments)
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
