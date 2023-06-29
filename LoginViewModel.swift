//
//  LoginViewModel.swift
//  Authentication3
//
//  Created by Tomislav Zvonarek on 28.04.2023..
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    var isLoading = false
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var showAlert = false
}




