//
//  TrackCell.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit
import SDWebImage

class TrackCell : UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var artist : UILabel!
    @IBOutlet weak var albumArt : UIImageView!
    
    func set(track : Track){
        title.text = track.title
        artist.text = track.artist
        
        let albumUrl = URL(string: track.albumArtUrl)
        albumArt.sd_setImage(with: albumUrl, placeholderImage: nil)
    }
}
