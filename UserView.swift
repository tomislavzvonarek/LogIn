//
//  UserView.swift
//  Authentication3
//
//  Created by Tomislav Zvonarek on 28.04.2023..
//

import SwiftUI

struct UserView: View {
    
    @Binding var user: User?
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            AppColor.mainColor.ignoresSafeArea()
            VStack(alignment: .leading) {
                List {
                    Section(header: Text("User Information")) {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(user?.name ?? "")
                        }
                        HStack {
                            Text("Surname")
                            Spacer()
                            Text(user?.surname ?? "")
                        }
                        HStack {
                            Text("Full Name")
                            Spacer()
                            Text(user?.fullName ?? "")
                        }
                    }
                    Section(header: Text("Contact")) {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user?.email ?? "")
                        }
                        HStack {
                            Text("Phone Number")
                            Spacer()
                            Text(user?.phoneNumber ?? "")
                        }
                        HStack {
                            Text("Address")
                            Spacer()
                            Text(user?.address ?? "")
                        }
                    }
                }
                .padding()
                .navigationBarTitle("User Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button("Log Out") {
                    isLoggedIn = false
                    KeychainService.deleteAccessTokenFromKeychain()
                }
                )
            }
        }
    }
}



