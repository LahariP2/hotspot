//
//  LeaderboardView.swift
//  AWSgamify3
//
//  Created by Shreyah Prasad on 4/30/22.
//

import SwiftUI
import Amplify

struct LeaderboardView: View {
    @StateObject var viewModel: LeaderboardView.ViewModel = .init()
    @State var progressValue: Double = 0.0
    
    let blueWhite = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.white]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        // add ranking number
        //var i = 0
        //NavigationView {
            
        
        
        
            ZStack {
                blueWhite
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("LeaderBoard")
                        .font(.largeTitle)
                        .bold()
                        .padding(50)
                    
                    List(viewModel.userPoints) { user in
                        //VStack {
                            HStack {
                                //Text(String(i))
                                //Spacer()
                                Text(user.UserEmail ?? "L")
                                Spacer()
                                Text(String(user.Points!))
                            }
                        //}
                    }.onAppear(perform: viewModel.getTopUsers).padding(.bottom)
                    
                    
                    Text("Your Points")
                        .font(.largeTitle)
                        .bold()
                    ZStack {
//
                        List(viewModel.yourPoints) { user in
                            VStack {
                                Text(String(user.Points!))
                                    .font(.largeTitle)
                                    .bold()
                                //self.progressValue = Double(user.Points!/20)
                            }
                        }.onAppear(perform: viewModel.getYourPoints)
                        
                        
                        ProgressBar(progress: self.$progressValue)
                            .frame(width: 160.0, height: 160.0)
                            .padding(20).onAppear() {
                            }
                        
//                        Text("")
//                            .font(.largeTitle)
//                            .bold()
                    }
                    
                    /*
                    List(viewModel.yourPoints) { user in
                        VStack {
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 160.0, height: 160.0)
                                .padding(20).onAppear() {
                                    self.progressValue = 7 //viewModel.getYourPoints()
                                }
                            
                            Text(String(user.Points!))
                                .font(.largeTitle)
                                .bold()
                                //.foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.blue)
                                .cornerRadius(30)
                                .padding(.bottom)
                        }
                    }//.onAppear(perform: viewModel.getYourPoints)
                    
                    */
                }
            } //.navigationTitle("Leader Board")
        //}
        //.onAppear(perform: viewModel.getTopUsers)
        //blueWhite
        //.edgesIgnoringSafeArea(.all)
    }
}

struct ProgressBar: View {
    @Binding var progress: Double
    var color: Color = Color.blue
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(Double(self.progress), 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                //.animation(.easeInOut(duration: 2.0))
        }
    }
}

extension LeaderboardView {
    class ViewModel: ObservableObject {
        @Published var userPoints: [UserPoints] = []
        @Published var yourPoints: [UserPoints] = []
        
        // limit to 10
        func getTopUsers() {
            Amplify.DataStore.query(UserPoints.self, sort: .descending(UserPoints.keys.Points)) { [weak self] result in
                switch result {
                case .success(let userPoints):
                    self?.userPoints = userPoints
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func getYourPoints() { //inputEmail: String
            let inputEmail = ""
            Amplify.DataStore.query(UserPoints.self, where: UserPoints.keys.UserEmail == inputEmail) { [weak self] result in
                switch result {
                case .success(let points):
                    self?.yourPoints = points
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func addUser(inputEmail: String, inputPoints: Int) {
            let newUserPoint = UserPoints(UserEmail: inputEmail, Points: inputPoints)
            Amplify.DataStore.save(newUserPoint) { [weak self] result in
                switch result {
                case .success(let savedUP):
                    print("Saved UP: \(String(describing: savedUP.UserEmail))")
                    self?.getTopUsers()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
