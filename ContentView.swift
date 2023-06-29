import SwiftUI

struct LoginView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            if loginVM.isLoggedIn {
                NavigationLink("", destination: UserView(user: $user, isLoggedIn: $loginVM.isLoggedIn), isActive: $loginVM.isLoggedIn)
            } else {
                ZStack {
                    AppColor.mainColor.ignoresSafeArea()
                    VStack {
                        Text(loginVM.errorMessage)
                            .foregroundColor(.red)
                        TextField("Email", text: $loginVM.email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        SecureField("Password", text: $loginVM.password)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        Button(action: {
                            self.loginVM.isLoading = true
                            authenticate(email: loginVM.email, password: loginVM.password) { response in
                                self.loginVM.isLoading = false
                                switch response {
                                case .success(let data):
                                    KeychainService.saveAccessTokenToKeychain(data.accessToken)
                                    loadData(accessToken: data.accessToken) { response in
                                        DispatchQueue.main.async {
                                            switch response {
                                            case .success(let user):
                                                self.user = user
                                                self.loginVM.isLoggedIn = true
                                            case .failure(_):
                                                self.loginVM.errorMessage = "Failed to load user data"
                                            }
                                            
                                        }
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        switch error {
                                        case .invalidCredentials:
                                            self.loginVM.errorMessage = "Invalid Username or Password"
                                        default:
                                            self.loginVM.errorMessage = "Failed to authenticate"
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }) {
                            if self.loginVM.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("LOG IN")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(AppColor.accentColor)
                                    .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $loginVM.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(loginVM.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
