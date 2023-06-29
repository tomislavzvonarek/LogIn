//
//  UserData.swift
//  Authentication3
//
//  Created by Tomislav Zvonarek on 28.04.2023..
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let surname: String
    let fullName: String
    let roleId: Int
    let imageId: Int
    let address: String
    let phoneNumber: String
    let oib: String
    let email: String
    let statusId: Int
    let accessLiburnija: Bool
    let accessParking: Bool
    let accessZadar: Bool
    let checked: Bool
    let status: String?
    let cards: [String]
}
