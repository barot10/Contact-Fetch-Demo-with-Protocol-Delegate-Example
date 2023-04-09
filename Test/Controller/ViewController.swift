//
//  ViewController.swift
//  Test
//
//  Created by Parth Barot on 2/19/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewContacts: UITableView!
    
    let dataSource = FetchContactModel()
    var contacts = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewContacts.delegate = self
        tableViewContacts.dataSource = self
        dataSource.delegate = self
        
        DispatchQueue.global().async {
            self.dataSource.fetchContacts()
        }
        
        // Do any additional setup after loading the view.
    }


}

extension ViewController: FetchContactModelDelegate {

    func didRecieveDataUpdate(data: [ContactModel]) {
        self.contacts = data
        DispatchQueue.main.async {
            self.tableViewContacts.reloadData()
        }
    }

    func showSettingAlert(_ completionHandler: @escaping (Bool) -> Void) {
       
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        cell.contact = self.contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
