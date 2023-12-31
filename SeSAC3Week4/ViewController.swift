//
//  ViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

//구조체의 수량은 늘어날 수 있다.
struct Movie {
    var title: String
    var release: String
}


class ViewController: UIViewController {
    
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var movieTableView: UITableView!
    
//    var movieList: [String] = []
    //확장
    var movieList: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.rowHeight = 60
        
        indicatorView.isHidden = true
        
        
        
    }
    
    
    
    func callRequest(date: String) {
        
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                //                let name = json["movieNm"].stringValue
//                //                차근차근 접근해야한다..!
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                // 중괄호일때와 대괄호(배열)일때 접근방법이 다르므로 이를 고려
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                print(name1, name2, name3)
//
//                self.movieList.append(name1)
//                self.movieList.append(name2)
//                self.movieList.append(name3)
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = item["movieNm"].stringValue
                    let openDT = item["openDt"].stringValue
                    
                    let data = Movie(title: movieNm, release: openDT)
                    self.movieList.append(data)
                }
                //hidden 처리만 하고 멈춤처리를 하지않으면 indicatorview가 계속 돌아가는 상황이기때문에 세트로 움직인다고 생각!!
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true // 통신 끝, 뷰 갱신
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //구현시 고려해야할 조건들..!
        //20220101 > 1. 8글자 2.20233333 올바른 날짜 3. 날짜 범주
        
        callRequest(date: searchBar.text!)
    }
    
}

    extension ViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
            
//            cell.textLabel?.text = movieList[indexPath.row]
//            cell.detailTextLabel?.text = "테스트"
            cell.textLabel?.text = movieList[indexPath.row].title
            cell.detailTextLabel?.text = movieList[indexPath.row].release
            
            
            
            return cell
        }
    }

