//
//  ViewController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

protocol TableDataHolder {
    associatedtype Data
    var data : [Data] {get set}
}

class UserViewController: UITableViewController, TableDataHolder, ErrorHandler {
    @IBOutlet weak var countdownProgress: UIProgressView!
    @IBOutlet weak var countDownLable: UILabel!
    
    
    typealias Data = User

    private var userCellName : String { return "user_cell" }
    
    var data : [User] = [] {
        didSet {
            asyncMain {
                self.tableView.reloadDataAnimated(animation : .bottom)
            }
        }
    }
    
    private var countdown : CountdownController?

    override func viewDidLoad() {
        super.viewDidLoad()
        countdown = CountdownController(overtime: 10)
        countdown?.delegate = self
        
        requestData()
        refreshControl?.addTarget(self, action: #selector(swipeToRefresh), for: .valueChanged)
    }
    
    private func requestData(){
        if data.isEmpty {
            tableView.setNoData(reason: .loading)
        }
        
        networking.requestUser { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data.sorted(by: { $0.score > $1.score })
            case .failure(let error):
                asyncMain {
                    self?.handleError(error)
                    self?.countdown?.invalidate()
                }
            }
            
            asyncMain { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc
    private func swipeToRefresh(){
        refreshControl?.beginRefreshing()
        countdown?.start()
        requestData()
    }
}


//MARK: - Table View Datasource
extension UserViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellName) as! UserCell
        cell.set(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 { tableView.removeEmptyMessage() }
        return data.count
    }
}

//MARK: - CountdownDelegate
extension UserViewController : CountdownDelegate {
    func tick(_ tick: TimeInterval, percentage : Float) {
        countdownProgress.setProgress(percentage, animated: tick > 0)
        countDownLable.text = Int(tick).description
    }
    
    func becameInvalid() {
        countdownProgress.setProgress(0.0, animated: false)
        countDownLable.text = 0.description
    }
    
    func timeIsUp() {
        requestData()
    }
}

