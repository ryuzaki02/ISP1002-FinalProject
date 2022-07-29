//
//  ContactListViewController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    
    private var contactListViewModel = ContactListViewModel()
    let cellIdentifier = "ContactListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        plusButton.tintColor = UIColor.customGreen
    }
    
    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.sectionHeaderHeight = 30.0
    }
    
    //MARK: - Button Actions
    @IBAction func plusButtonAction(_ sender: UIButton!) {
        openProfileViewController(profileViewState: .new)
    }
    
    //MARK: - Open Profile view controller
    private func openProfileViewController(profileViewState: AddUpdateContactViewModel.ProfileViewState, shouldPresent: Bool = true){
        let profileViewModel = AddUpdateContactViewModel(profileViewState: profileViewState)
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateContactViewController") as! AddUpdateContactViewController
        profileVC.setupData(profileViewModel: profileViewModel)
        profileVC.headerViewDelegate = self
        if shouldPresent{
            let navControl = CustomNavigationController.init(rootViewController: profileVC)
            present(navControl, animated: true, completion: nil)
        }else{
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

extension ContactListViewController: ProfileHeaderViewProtocol {
    func contactDidChange(contactModel: ContactModel, isNew: Bool) {
        
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modelArray = contactListViewModel.getContactModelArrayForIndex(index: indexPath.section) {
            openProfileViewController(profileViewState: .showOnly(contactModel: modelArray[indexPath.row]))
        }
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
