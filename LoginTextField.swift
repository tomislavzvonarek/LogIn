import SwiftUI

struct LoginView: View {
    @State private var email: String = "info@mediatorium.co"
    @State private var password: String = "info123"
    @State private var isLoggedIn: Bool = false
    @State private var errorMessage: String = ""
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                NavigationLink("", destination: UserView(user: $user, isLoggedIn: $isLoggedIn), isActive: $isLoggedIn)
            } else {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    
                    MaterialDesignTextField(label: "Email", text: $email)
                        .padding()
                    
                    MaterialDesignTextField(label: "Password", text: $password)
                        .padding()
                        .
                        
                    
                    Button(action: {
                        authenticate(email: email, password: password) { response in
                            switch response {
                            case .success(let data):
                                KeychainService.saveAccessTokenToKeychain(data.accessToken)
                                loadData(accessToken: data.accessToken) { response in
                                    switch response {
                                    case .success(let user):
                                        self.user = user
                                        self.isLoggedIn = true
                                    case .failure(let failure):
                                        break
                                        // TODO: Handle error
                                    }
                                }
                            case .failure(let failure):
                                break
                                // TODO: Show error
                            }
                        }
                    }) {
                        Text("Log in")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
    
