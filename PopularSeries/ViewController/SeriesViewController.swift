//
//  SeriesViewController.swift
//  PopularSeries
//
//  Created by Fernando Koyanagi on 19/02/20.
//  Copyright © 2020 crmall. All rights reserved.
//

import UIKit
import AFNetworking

class SeriesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var series: Array<Any>?
    var carregando = false
    var page = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate=self;
        
        fetchSeries()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return series?.count ?? 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerieCell", for: indexPath) as! SerieCell
        self.tableView.rowHeight = 200
        
        let serie = series![indexPath.row] as! NSDictionary
        
        let name = serie["name"] as? String
        let overview = serie["overview"] as? String
        let imagePath = serie["poster_path"] as! String
       
        cell.nameLabel.text = name
        cell.overviewLabel.text = overview
        
        let url = "https://image.tmdb.org/t/p/original/"

        cell.imageSerieView.setImageWith(URL(string: url+imagePath)!)

        return cell;
    }
    func fetchSeries(){
     
        let apiKey = "13569f0fbe8af1afcad2ab50444f21eb";
        let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&language=pt-BR&page=\(self.page)")!

        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]

                if(self.series == nil){
                    self.series = json?["results"] as? Array<Any>
                }
                else{
                    let results = json?["results"] as! Array<Any>
                    for item in results {
                        self.series?.append(item)
                       
                    }

                }
                
                self.tableView.reloadData()
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height{
            
            if(!self.carregando){
                self.carregaProximaPagina()
            }
        }
    }
    func carregaProximaPagina(){
        self.carregando = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
            self.page+=1
            self.fetchSeries()
            self.carregando=false;
        })
    }
}
