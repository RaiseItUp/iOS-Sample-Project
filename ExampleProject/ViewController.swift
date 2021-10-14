//
//  ViewController.swift
//  ExampleProject
//
//  Created by Luke Sadler on 14/10/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var users: [User]?
  var groupedUsers = [String: [PresentableData]]()
  var tableview = UITableView()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let json = Bundle.main.url(forResource: "MOCK_DATA", withExtension: "json")
    let data = try! Data(contentsOf: json!)
    // mock json loaded into memory as [String: Any] dict
    let userDicts = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
    
    self.users = userDicts
      .compactMap({
        // construct the users from the json data
        guard var user = User($0) else { return nil }
        
        // setup callback for when cell is tapped
        user.tapCallback = { (title, body) in
          // take in title and body, set in the `didSelectRow` delegate method
          let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
          alert.addAction(.init(title: "Okay", style: .default))
          self.present(alert, animated: true)
        }
        
        // set image here to be set in UI on the cell
        user.profileImage = UIImage(named: "CellImage")
        return user
      })
    
    // create array of uppercase alphabet
    let alphabet = "abcdefghijklmnopqrstuvwzyz".map({$0.uppercased()}).sorted()
    
    alphabet.forEach({ char in
      let letter = String(char)
      
      // find any users with the first character of their firstname starting with this letter
      if let userArray = self.users?.filter({ $0.surname.hasPrefix(letter)} ) {
        if userArray.count > 0 {
          // Add user array to the correct key in the `groupedUsers` dict
          self.groupedUsers[letter] = userArray
        }
      }
    })
    
    tableview.delegate = self
    tableview.dataSource = self
    tableview.frame = self.view.bounds
    self.view.addSubview(tableview)
    tableview.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let keys = Array(self.groupedUsers.keys).sorted()
    let section = self.groupedUsers[keys[section]]
    return section?.count ?? 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    Array(self.groupedUsers.keys).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    
    let keys = Array(self.groupedUsers.keys).sorted()
    let user = self.groupedUsers[keys[indexPath.section]]![indexPath.row]
    
    cell.textLabel?.text = "\(user.surname), \(user.forename)"
    cell.detailTextLabel?.text = user.email
    cell.imageView?.image = user.profileImage
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Array(self.groupedUsers.keys).sorted()[section]
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let keys = Array(self.groupedUsers.keys).sorted()
    let user = self.groupedUsers[keys[indexPath.section]]![indexPath.row] as! User

    user.tapCallback!("Tapped", user.alertText)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

