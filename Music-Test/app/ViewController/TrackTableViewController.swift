//
//  TrackTableViewController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

class TrackTableViewController: UITableViewController {
    private var trackCellName : String { return "track_cell" }
    
    var tracks : [Track] = [] {
        didSet {
            asyncMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.requestTracks { result in
            switch result {
            case .success(let tracks):
                self.tracks = tracks
            case .failure(let error):
                print("Error = " + error.localizedDescription)
            }
        }
    }
}


//Mark: - Table View Datasource
extension TrackTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = tracks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellName) as! TrackCell
        cell.set(track: track)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
}
