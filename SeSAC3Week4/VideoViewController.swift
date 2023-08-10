//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by NAM on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

struct Video {
    let author: String
    let date: String
    let time: Int
    let thumbnail: String
    let title: String
    let link: String
    
    
    //연산 프로퍼티를 활용..!
    var contents: String {
       
            return "\(author) | \(time)회\n \(date)"
       
    }
}


class VideoViewController: UIViewController {
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    //* String 활용시
    //    var videoList: [String] = []
    
    //** struct 확장 시
    var videoList: [Video] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.dataSource = self
        videoTableView.delegate = self
        videoTableView.prefetchDataSource = self
        
        videoTableView.rowHeight = 140
        
        //실시간 검색을 사용하면 키워드 타이핑마다 요청이 들어간다..!
        //엔터칠때마다 검색이 되도록 구현해야한다..!
        searchBar.delegate = self
    }
    
    func callRequest(query: String, page: Int) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
        let header: HTTPHeaders = ["Authorization": APIKey.kakaoAK]
        
        print(url)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                //상태(스테이터스) 코드에 따라
                //보통 400번대가 서버 오류, 500번대 클라이언트 오류
                //성공했을 경우에만 반복문을 담을 수 있도록 처리한 코드는 아래와 같다
                //아래 코드를 확장하기위해선 다양한 상황에 대한 오류를 대응해야한다.
                //API 문서에서 상태 코드
                if statusCode == 200 { // 성공의 경우
                
                    self.isEnd = json["meta"]["is_end"].boolValue
                    
                    
                    for item in json["documents"].arrayValue {
                        let author = item["author"].stringValue
                        let date = item["datetime"].stringValue
                        let time = item["play_time"].intValue
                        let thumbnail = item["thumbnail"].stringValue
                        let title = item["title"].stringValue
                        let link = item["url"].stringValue
                        
                        let data = Video(author: author, date: date, time: time, thumbnail: thumbnail, title: title, link: link)
                        
                        self.videoList.append(data)
                    }
                    
                    self.videoTableView.reloadData()
                    print(self.videoList)
                    
                } else {
                    print("문제가 발생했어요. 잠시 후 다시 시도해주세요!!")
                }
                
                
                //스테이터스 코드 확인하는 코드
                print(response.response?.statusCode)
                
                //*String 배열 활용시
                //json 큰 구조로는 Dictionary 형태 -> 나오는 양식이 그때그때 달라진다..!
                //                for item in json["documents"].arrayValue {
                //                    let title = item["title"].stringValue
                //                    self.videoList.append(title)
                //                }
                //                print(self.videoList)
                
                //                //sturct 활용시
                //                for item in json["documents"].arrayValue {
                //                    let author = item["author"].stringValue
                //                    let date = item["datetime"].stringValue
                //                    let time = item["play_time"].intValue
                //                    let thumbnail = item["thumbnail"].stringValue
                //                    let title = item["title"].stringValue
                //                    let link = item["url"].stringValue
                //
                //                    let data = Video(author: author, date: date, time: time, thumbnail: thumbnail, title: title, link: link)
                //
                //                    self.videoList.append(data)
                //
                //                }
                
                
                //                print("=====")
                //                print(self.videoList)
                //                print("=====")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        
        if let url = URL(string: videoList[indexPath.row].thumbnail) { // 링크가 지워졌거나, 정상작동하지 않는 경우를 대비하여
            cell.thumbnailImageView.kf.setImage(with: url)
        }
         
        return cell
        
    }
    
    //UITableViewDataSourcePrefetching: iOS10이상 사용 가능한 프로토콜, cellForRoawAt 메서드가 호출되기 전에 미리 호출됨
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받는 기능
    //videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    //page count
    //검색어의 결과가 15페이지가 안될경우? ->
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && isEnd == false { // 스크롤이 가장 마지막까지 내려왔을 때, API 제공해주는 곳의 요건에 따라 제약도 정해야한다..!
                // 위 세가지 조건이 모두 만족해야 아래 코드 실행된다..!
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    //취소 기능: 직접 취소하는 기능을 구현해주어야 함!
    //천천히 스크롤 되는 상황보다는 빠르게 스크롤 되는 상황에 많이 작동하는데..!
    //데이터를 요청해서 반응하는 상황에 prefetching(다운받고 있는 것들을 취소해달라는..!)을 취소..!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("====취소: \(indexPaths)")
    }
    
}

extension VideoViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1 // 다음 검색시 페이지가 고정되기때문에..! 새로운 페이지로 만들기 위해..!
        //pagenation 함수로 인해 page = 15이 상태에서 검색이 진행되어 15페이지에 해당하는 내용만 화면에 나온다.
        //새로운 검색어 페에지에
        videoList.removeAll()
        
        //아래코드는 append만 하고있어 검색 결과가 쌓이는 식이다..!
        //removeAll()을 통해
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
        
        view.endEditing(true)
    }
}


