//
//  MoviesViewController.swift
//  Swift Publisher Test1
//
//  Created by Admin on 10/12/20.
//  Copyright © 2020 Kaustabh. All rights reserved.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    
    var baseurl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    var tempArray : [FetchData]? = []
    
    var moviesArray : [Movie] = []
    
    //var fetchData : AnyPublisher<MovieResponse,Error>
    
    let apiClient = APIClient()
    
    private var publisher: AnyPublisher<[MyNote], Error>?
    
    private var publisherTwo : AnyPublisher<[FetchData],Error>?
    
    var cancellable: AnyCancellable?
    
    var moviescancellation: AnyCancellable?
    
    var notes : [MyNote] = []
    
    @IBOutlet weak var tableView : UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Webservice().fetchNotes()
        self.getWebserviceNotes()
        
        //self.getMovies()

        

        // Do any additional setup after loading the view.
    }
    
//    func request() -> AnyPublisher<MovieResponse, Error> {
//        // 3
//        guard var components = URLComponents(url: baseurl.appendingPathComponent(""), resolvingAgainstBaseURL: true)
//            else { fatalError("Couldn't create URLComponents") }
//        components.queryItems = [URLQueryItem(name: "write_key", value: "write_value")] // 4
//        
//        //let request = URLRequest(url: components.url!)
//        
//        let request = URLRequest(url: baseurl)
//        
//        return apiClient.run(request)
//            .map(\.value)
//            .eraseToAnyPublisher()
//    }
    
    
    func getWebserviceNotes() {

        self.publisher = Webservice().fetchNotes()
        guard let pub = self.publisher else { return }

        cancellable = pub
                .sink(receiveCompletion: {_ in },
                      receiveValue: { (notes) in
                        self.notes = notes
                        self.tableView.reloadData()
                        print("Value",self.notes)
                })
    }
    
    
//    func getMovies() {
//        moviescancellation = self.request()
//            .mapError({ (error) -> Error in
//                print(error)
//                return error
//            })
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: {
//                    self.moviesArray = $0.movies
//                    print("Movies Count---->",self.moviesArray.count)
//            })
//    }
    
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct APIClient {

    struct Response<T> { // 1
        let value: T
        let response: URLResponse
    }
    
     func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in

                let httpResponse = result.response as? HTTPURLResponse
                if httpResponse?.statusCode != 200 {
                    //Show Alert Code
                }
                let value = try JSONDecoder().decode(T.self, from: result.data)

                return Response(value: value, response: result.response)
        }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

    }
}

class MoviesTVC : UITableViewCell {
    @IBOutlet weak var title : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MoviesViewController : UITableViewDelegate , UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTVC") as! MoviesTVC
        cell.title.text = self.notes[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

class Webservice {
    func fetchNotes() -> AnyPublisher<[MyNote], Error> {
        let url = "https://jsonplaceholder.typicode.com/photos"
        guard let notesURL = URL(string: url) else { fatalError("The URL is broken")}

        return URLSession.shared.dataTaskPublisher(for: notesURL)
            .map { $0.data }
            .decode(type: [MyNote].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
