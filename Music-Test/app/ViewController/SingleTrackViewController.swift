//
//  SingleTrackViewController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

class SingleTrackViewController: UIViewController, ErrorHandler {
    @IBOutlet weak var titleTrack : UILabel!
    @IBOutlet weak var artist : UILabel!
    @IBOutlet weak var duration : UILabel!
    @IBOutlet weak var albumArt : UIImageView!

    private var urlToCancel : URL?
    
    var data : Track!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fitUI(track: data)
        
        urlToCancel = networking.requestSingleTrack(id: data.trackId) { [weak self] result in
            self?.urlToCancel = nil
            
            switch result {
            case .success(let track):
                self?.data = track
                asyncMain {
                    self?.fitUI(track: track)
                }
            case .failure(let error):
                asyncMain {
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func fitUI(track : Track){
        titleTrack.text = track.title
        artist.text = track.artist
        duration.text = track.duration.playbackTime
        let albumUrl = URL(string: track.albumArtUrl)
        albumArt.sd_setImage(with: albumUrl, placeholderImage: nil)
    }
    
    deinit {
        if let url = self.urlToCancel {
            networking.cancelRequest(for: url)
        }
    }
}
