//
//  ContactListViewController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    private var contactListViewModel = ContactListViewModel()
    let cellIdentifier = "ContactListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.sectionHeaderHeight = 30.0
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ContactListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactListViewModel.contactsDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(contactListViewModel.sectionHeaderArray[section]).uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListViewModel.getContactModelArrayForIndex(index: section)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactListTableViewCell,
              let model = contactListViewModel.getContactModelArrayForIndex(index: indexPath.section)?[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.nameLabel.text = (model.firstName ?? "") + " " + (model.lastName ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionHeaderArray = contactListViewModel.sectionHeaderArray
        return sectionHeaderArray
    }
}
