//
//  User.swift
//  ExampleProject
//
//  Created by Luke Sadler on 14/10/2021.
//

import Foundation
import UIKit

protocol PresentableData {
  var forename: String { get }
  var surname: String { get }
  var email: String { get }
  var profileImage: UIImage? { get }
  var alertText: String { get }
}

struct User: PresentableData {
  var id: Int
  var forename: String
  var surname: String
  var email: String
  var gender: String
  var ip_address: String
  
  var tapCallback: ((String, String) -> Void)?
  var profileImage: UIImage?
  
  init?(_ value: [String: Any]) {
    
    guard let id = value["id"] as? Int else { return nil }
    guard let firstName = value["first_name"] else { return nil }
    guard let surname = value["last_name"] else { return nil }
    guard let email = value["email"] else { return nil }
    guard let gender = value["gender"] else { return nil }
    guard let ipAddress = value["ip_address"] else { return nil }
    
    self.id = id
    self.forename = firstName as? String ?? ""
    self.surname = surname as? String ?? ""
    self.email = email as? String ?? ""
    self.gender = gender as? String ?? ""
    self.ip_address = ipAddress as? String ?? ""
  }
  
  var alertText: String {
    return "You have tapped on \(self.surname), \(self.forename)"
  }
  
}
