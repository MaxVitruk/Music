//
//  TrackTableViewController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit
import SDWebImage

class TrackTableViewController: UITableViewController, TableDataHolder, ErrorHandler {
    private var predownloadRange : Int { return 3 }
    private var trackCellName : String { return "track_cell" }
    private var detailsSegue : String { return "segue_push_details" }
    
    
    typealias Data = Track
    
    var activityIndicator : UIActivityIndicatorView!
    
    var data : [Track] = [] {
        didSet {
            asyncMain {
                self.tableView.reloadData()
            }
        }
    }
    
    var pageController : TrackPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        addActivityIndicator()
        pageController = TrackPageControl()
        pageController.delegate = self
        pageController.requestNext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageController.addObserver(self, forKeyPath: #keyPath(TrackPageControl.isLoading), options: [.old, .new], context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pageController.removeObserver(self, forKeyPath: #keyPath(TrackPageControl.isLoading))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SingleTrackViewController, let t = sender as? Track {
            vc.data = t
        }
    }
    
    private func requestTracks(page : Int) {
        if data.isEmpty {
            tableView.setNoData(reason: .loading)
        }
        
        networking.requestTracks(page: page) { [weak self] result in
            switch result {
            case .success(let tracks):
                self?.pageController.done()
                self?.data.append(contentsOf: tracks)
            case .failure(let error):
                asyncMain {
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func addActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .gray)
        let refreshBarButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = refreshBarButton
    }
}

//MARK: - KVO
extension TrackTableViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(TrackPageControl.isLoading) {
            asyncMain { [weak self] in
                let isLoading = (change?[.newKey] as? Bool) ?? false
                isLoading ?
                    self?.activityIndicator.startAnimating() :
                    self?.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - Table View Delegate
extension TrackTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = data[indexPath.row]
        self.performSegue(withIdentifier: detailsSegue, sender: track)
    }
}

//MARK: - Table View Datasource
extension TrackTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellName) as! TrackCell
        cell.set(track: track)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 { tableView.removeEmptyMessage() }
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if data.count - indexPath.row <= predownloadRange {
            pageController.requestNext()
        }
    }
}

extension TrackTableViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap{ URL(string : data[$0.item].albumArtUrl) }
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
}

extension TrackTableViewController : TrackPageControllerDelegate {
    func request(page: Int) {
       requestTracks(page: page)
    }
}
