//
//  ViewController.swift
//  Swift Publisher Test1
//
//  Created by Admin on 10/12/20.
//  Copyright © 2020 Kaustabh. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    var strArray : [String] = []
    
    var receiveArray : [FetchData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.APICallUsingPublisher()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    var subscriptions : Set<AnyCancellable> = []
    
    
    func APICallUsingPublisher() {
        let _ = URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/posts")!).retry(2).map(\.data).decode(type: [FetchData].self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completed) in
            switch completed {
            case .failure(let error):
                print(error)
            case .finished:
                print("API Call has been successfully finished")
            }
        }, receiveValue: { (Value) in
            //print(Value.first?.title ?? "")
            self.receiveArray = Value
            self.tableView.reloadData()
        })
        .store(in: &subscriptions)
    }
    


}


// MARK: - RecentQuotesResponseModelElement
struct FetchData: Codable {
    let userID, id: Int?
    let title, body: String?
}

class testTVC : UITableViewCell {
    
    @IBOutlet weak var titleName : UILabel!
    @IBOutlet weak var descripDetails : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receiveArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testTVC") as! testTVC
        cell.titleName.text = self.receiveArray[indexPath.row].title ?? ""
        cell.descripDetails.text = self.receiveArray[indexPath.row].body ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}

 
