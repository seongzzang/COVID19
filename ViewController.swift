//
//  ViewController.swift
//  COVID19
//
//  Created by 양성혜 on 2022/08/03.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                debugPrint("success")
            case let .failure(error):
                debugPrint("error")
            }
            
        })
    }

    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey":"aFWg17v3U2XlitwkOhEjZ5QKC8PeR6SMn"
        ]
        AF.request(url,method: .get,parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    }catch{
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }

}

