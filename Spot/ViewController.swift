//
//  ViewController.swift
//  Spot
//
//  Created by Neel Patel on 08/11/16.
//  Copyright © 2016 Neel Patel. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()


struct post {
    
    let mainImage : UIImage!
    let name : String!
    let previewURL : String!
}

class TableViewController: UITableViewController {

    var posts = [post]()
    
    
    var searchurl = "https://api.spotify.com/v1/search?q=One+Direction&type=track"
    typealias JSONStandard = [String : AnyObject]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchurl)
    }

    func callAlamo(url : String){
        
        Alamofire.request(url).responseJSON(completionHandler: {
            
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data){
        do{
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
         //   print(readableJSON)
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard]{
                    for i in 0..<items.count {
                       let item = items[i]
                        print(item)
                        let name = item["name"] as! String
                        let previewURL = item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                posts.append(post.init(mainImage: mainImage, name: name, previewURL: previewURL))
                              //  posts.append(name)
                                self.tableView.reloadData()
                            }
                        
                        }
               // names.append(name)
              //  self.tableView.reloadData()
                    }
                }
            }
        }
        catch{
            print(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
       let mainImageView = cell?.viewWithTag(2) as! UIImageView
        
        mainImageView.image = posts[indexPath.row].mainImage
        
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        
        mainLabel.text = posts[indexPath.row].name
        
    //   cell?.textLabel?.text = posts[indexPath.row]
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioVC
        
        vc.Image = posts[indexPath!].mainImage
        vc.songTitle = posts[indexPath!].name
        vc.mainpreviewURL = posts[indexPath!].previewURL
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

