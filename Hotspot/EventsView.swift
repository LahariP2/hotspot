//
//  EventsView.swift
//  WeceHacks
//
//  Created by Lahari on 4/30/22.
//

import SwiftUI
import Amplify

struct EventsView: View {

    @StateObject var viewModel: EventsView.ViewModel = .init()
    @State private var checkedinEvent = ""
    @State private var pointsEarned = 0
    @State private var doneForToday = false
    @State private var addEventName = ""
    @State private var addEventLoc = ""
    @State private var addEventDetails = ""

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                List(viewModel.events) { event in
                    VStack {
                        Text(String(describing: event.name))
                        Text(String(describing: event.date))
                        Text(String(describing: event.location))
                        Text(String(describing: event.details))
                        Text("Points: \(String(describing: event.points))")
                        Button("Check in") {
                            if (pointsEarned == 2) {
                                doneForToday = true
                            } else {
                                checkedinEvent = event.name
                                alertTF(title: "Check in to: \(checkedinEvent)", message: "Enter code", hintText: "Ex: 1234", primaryTitle: "Check-in", secondaryTitle: "Cancel") { code in
                                    print("Entered: \(code)")
                                    if (code == event.code) {
                                        print("Good job!")
                                        pointsEarned += 1
                                    } else {
                                        print("Wrong!")
                                    }
                                } secondaryAction: {
                                    print("Cancelled")
                                }
                            }
                        }
                        .alert(isPresented: $doneForToday) {
                            Alert(title: Text("Check-in"), message: Text("You already checked in to the event"), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [[.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .cyan].randomElement()!, .white]), startPoint: .top, endPoint: .bottom))
                }
            }
            
            .navigationBarItems(leading:
                HStack {
                    Text("Points: \(pointsEarned)")
                }, trailing:
                HStack {
                Button("Add event", action: {
                        alertTF(title: "Add Event", message: "Enter event name", hintText: "WECE Hacks", primaryTitle: "Enter", secondaryTitle: "Cancel") { name in
                            addEventName = name
                            alertTF(title: "Location", message: "Enter event location", hintText: "ECEB", primaryTitle: "Enter", secondaryTitle: "Cancel") { loc in
                                addEventLoc = loc
                                alertTF(title: "Details", message: "Enter event details", hintText: "Hackathon!", primaryTitle: "Enter", secondaryTitle: "Cancel") { details in
                                    addEventDetails = details
                                    viewModel.addEvent(name: addEventName, loc: addEventLoc, details: addEventDetails)
                                } secondaryAction: { print("Cancelled") }
                            } secondaryAction: { print("Cancelled") }
                        } secondaryAction: { print("Cancelled") }
                    })
                })
            
            .navigationBarTitle("Events")
        }
        .onAppear(perform: viewModel.getEvents)
    }

}

extension EventsView {
    class ViewModel: ObservableObject {
        @Published var test: [String] = ["hi", "how","are","you"]
        @Published var events: [Event] = []

        func getEvents() {
            Amplify.DataStore.query(Event.self) {
                [weak self] result in
                switch result {
                case .success(let events):
                    self?.events = events
                case .failure(let error):
                    print(error)
                }
            }
        }

        func addEvent(name: String, loc: String, details: String) -> Void {
            let newEvent = Event(
                name: name,
                date: .now(),
                location: loc,
                details: details,
                points: 1,
                code: "6892"
            )
            Amplify.DataStore.save(newEvent) { [weak self] result in
                switch result {
                case .success(let savedEvent):
                    print("Saved event: \(savedEvent.id)")
                    self?.getEvents()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}


extension View {
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: {_ in secondaryAction()}))
                        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: {_ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
                        
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

// Alert source: https://www.youtube.com/watch?v=1FqRNf2WbJE
