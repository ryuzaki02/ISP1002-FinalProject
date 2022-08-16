//
//  ContactListViewController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import UIKit

class ContactListViewController: UIViewController {
    
    // MARK: - Outlets
    //
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    //
    private var contactListViewModel = ContactListViewModel()
    let cellIdentifier = "ContactListTableViewCell"
    
    // MARK: - View Controller life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        addKeyboardTapGesture()
        plusButton.tintColor = UIColor.customGreen
    }
    
    // MARK: - Setup methods
    //
    // Method to setup table view
    //
    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.sectionHeaderHeight = 30.0
    }
    
    //MARK: - Button Actions
    //
    // Method to handle plus button action
    // params: sender: UIButton
    // return: nothing
    //
    @IBAction func plusButtonAction(_ sender: UIButton!) {
        openProfileViewController(profileViewState: .new)
    }
    
    //MARK: - Open Profile view controller
    //
    // Method to open profile view controller
    // params: profileViewState: AddUpdateContactViewModel.ProfileViewState, shouldPresent: Boolean
    // return: nothing
    //
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
    
    // Method to add keyboard gesture to view
    // params: nothing
    // return: nothing
    //
    private func addKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // Method to dismiss keyboard
    // params: nothing
    // return: nothing
    //
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ContactListViewController: ProfileHeaderViewProtocol {
    // Method to listen contact did changed
    // params: contactModel: ContactModel, isNew: Boolean
    // return: nothing
    //
    func contactDidChange(contactModel: ContactModel, isNew: Bool) {
        isNew ? DatabaseManager.shared.saveContactToDBFor(model: contactModel) : DatabaseManager.shared.updateContact(model: contactModel)
        contactListViewModel.getData()
        contactsTableView.reloadData()
    }
}

extension ContactListViewController: UITableViewDelegate {
    // Delegate method to handle table view row tap selection
    // params: tableView: UITableView, indexPath: IndexPath
    // return: nothing
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modelArray = contactListViewModel.getContactModelArrayForIndex(index: indexPath.section) {
            openProfileViewController(profileViewState: .showOnly(contactModel: modelArray[indexPath.row]))
        }
    }
}

extension ContactListViewController: UITableViewDataSource {
    // Data source method to handle number of sections for tableview
    // params: tableView: UITableView
    // return: Integer
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactListViewModel.contactsDict.keys.count
    }
    
    // Data source method to handle header titles for section
    // params: tableView: UITableView, section: Integer
    // return: String (Optional)
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(contactListViewModel.sectionHeaderArray[section]).uppercased()
    }
    
    // Data source method to handle number of rows in section
    // params: tableView: UITableView, section: Integer
    // return: Integer
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListViewModel.getContactModelArrayForIndex(index: section)?.count ?? 0
    }
    
    // Data source method to handle cell for row at index path
    // params: tableView: UITableView, indexPath: Indexpath
    // return: UITableViewCell
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactListTableViewCell,
              let model = contactListViewModel.getContactModelArrayForIndex(index: indexPath.section)?[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.nameLabel.text = (model.firstName ?? "") + " " + (model.lastName ?? "")
        return cell
    }
    
    // Data source method to handle height for row at index path
    // params: tableView: UITableView, indexPath: Indexpath
    // return: CGFloat
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // Data source method to handle section index titles
    // params: tableView: UITableView
    // return: Array of Strings (Optional)
    //
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionHeaderArray = contactListViewModel.sectionHeaderArray
        return sectionHeaderArray
    }
    
    // Data source method to handle swipe to delete for table view
    // params: tableView: UITableView, commit: UITableViewCell.EditingStyle, indexPath: Indexpath
    // return: nothing
    //
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let modelArray = contactListViewModel.getContactModelArrayForIndex(index: indexPath.section) {
                let model = modelArray[indexPath.row]
                DatabaseManager.shared.deleteContact(contactId: model.contactId)
                contactListViewModel.getData()
                if modelArray.count > 1 {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }
            }
        }
    }
}

extension ContactListViewController: UISearchBarDelegate {
    // Delegate method to handle search bar searching operation
    // params: searchBar: UISearchBar, searchText: String
    // return: nothing
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contactListViewModel.getData(searchText: searchText)
        contactsTableView.reloadData()
    }
}
