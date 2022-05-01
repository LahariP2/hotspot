//
//  AuthView.swift
//  AWSgamify3
//
//  Created by Shreyah Prasad on 4/30/22.
//

// shrey20, Test202$$
// Amplify.Auth.signOut()

import SwiftUI
import Amplify
import Combine

struct AuthView: View {
    @State var viewModel: AuthView.ViewModel = .init()
    @State private var showSignUp = false
    @StateObject var leaderboardViewModel: LeaderboardView.ViewModel = .init()
    @State private var signedIn = false
    
    @State private var presentAlert = false
    
    let blueWhite = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.white]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        /*
        TabView {
            LeaderboardView()
                .tabItem {
                    Label("Events", systemImage: "list.dash")
                }
            
            LeaderboardView()
                .tabItem {
                    Label("Starred Events", systemImage: "star")
                }
            
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "crown")
                }
            
        }
         */
        
        if signedIn {
            Text("You are signed in!")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // sign out:
            Button("sign out", action: {
                viewModel.signOut()
            }).padding()
            
        } else {
        
        //NavigationView {
            ZStack {
                blueWhite
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    /*
                    TextField("Username", text: $viewModel.username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                     */
                    
                    if showSignUp {
                        Text("Sign Up")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .colorInvert()
                            
                    } else {
                        Text("Login here")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .colorInvert()
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(30)
                        
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(30)
                    
                    if showSignUp {
                            
                        Button("Sign Up", action: {
                            viewModel.signUp()
                        })
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .padding(.bottom)
                        .opacity(0.85)
                        
                        TextField("Confirmation Code", text: $viewModel.confirmationCode)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(30)
                            
                        Button("Confirm", action: {
                            viewModel.confirm()
                            // create row in user points table
                            leaderboardViewModel.addUser(inputEmail: viewModel.email, inputPoints: 0)
                        })
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .opacity(0.85)
                        
                        Button("Already have an account? Login here", action: {
                            showSignUp = false
                        }).padding()
                        
                    } else {
                        Button("Sign In", action: {
                            viewModel.signIn()
                            viewModel.checkSessionStatus()
                            signedIn = viewModel.isSignedIn
                            if signedIn {
                                // change view to events home
                                //Events2View()
                            }
                        })
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .opacity(0.85)
                        
                        Button("Don't have an account? Sign Up here", action: {
                            showSignUp = true
                        }).padding()
                    }
                }
            }
        }
        //}.navigationBarHidden(true) // nav stack
    }
}

extension AuthView {
    class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var password: String = ""
        @Published var email: String = ""
        @Published var confirmationCode: String = ""
        @Published var isSignedIn = false
        
        func signOut() {
            Amplify.Auth.signOut() { result in
                switch result {
                case .success(let res):
                    print(res)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func signUp() {
            let emailAttribute = AuthUserAttribute(.email, value: email)
            let options = AuthSignUpRequest.Options(userAttributes: [emailAttribute])
            
            Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            ) { result in
                switch result {
                case .success(let signUpResult):
                    print(signUpResult.nextStep)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func confirm() {
            Amplify.Auth.confirmSignUp(for: email, confirmationCode:  confirmationCode) { result in
                switch result {
                case .success(let confirmResult):
                    print(confirmResult)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func signIn() {
            Amplify.Auth.signIn(username: email, password: password) { result in
                switch result {
                case .success(let signInResult):
                    print("AWS is signed in: ")
                    print(signInResult.isSignedIn)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func checkSessionStatus() -> Bool {
            _ = Amplify.Auth.fetchAuthSession { [weak self] result in
                switch result {
                case .success(let session):
                    print(session)
                    DispatchQueue.main.async {
                        self?.isSignedIn = session.isSignedIn
                    }
                    print("CHECK SESSION SIGN IN")
                    print(session.isSignedIn)
                    self?.isSignedIn = session.isSignedIn
                case .failure(let error):
                    print(error)
                }
            }
            //print("test sign in: ")
            //print(isSignedIn)
            return isSignedIn
        }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
