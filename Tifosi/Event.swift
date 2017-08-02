//
//  Event.swift
//  Tifosi
//
//  Created by COBE Osijek on 31/07/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation

struct Event {
    let name: String
    let place: String
    let dateTime: Date
    let coordinates: (latitude: Double, longitude: Double)
    let description: String
    let creatorID: String
    let eventID: String
}

class EventManager {

    var events: [Event] = []

    func getEvents(onCompletion: @escaping ((Bool) -> Void)) {
        let query = Constants.Refs.databaseEvents.queryLimited(toLast: 10)

        DispatchQueue.global().async {
            _ = query.observe(.childAdded, with: { [weak self] snapshot in
                if let data = snapshot.value as? [String: String],
                    let date = data["date"],
                    let description = data["description"],
                    let latitude = data["latitude"],
                    let longitude = data["longitude"],
                    let name = data["name"],
                    let placeName = data["placeName"],
                    let userID = data["userID"],
                    !userID.isEmpty {
                    let eventID = snapshot.key
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    // TO-DO: Fix the explicit unwrapping
                    DispatchQueue.main.async {
                        if let dateFormatted = formatter.date(from: date) {
                            let event = Event(name: name, place: placeName, dateTime: dateFormatted, coordinates: (latitude: Double(latitude)!, longitude: Double(longitude)!), description: description, creatorID: userID, eventID: eventID)
                            self?.events.append(event)
                            onCompletion(true)
                        }
                    }
                }
            })
        }
    }

    func getCount() -> Int {
        return events.count
    }
}

struct Person {
    let name: String
    let surname: String
    let email: String
    let photoURLString: String
    let personID: String
}

class EventPeopleManager {

    var people: [Person] = []

    func getPeople(key: String, onCompletion: @escaping ((Bool) -> Void)) {
        
        let query = Constants.Refs.databaseEvents.child(key).child("guests")

        DispatchQueue.global().async {
            _ = query.observe(.childAdded, with: { [weak self] snapshot in
                if let data = snapshot.value as? [String: String],
                    let name = data["userName"],
                    let surname = data["userSurname"],
                    let email = data["userID"],
                    let photoURLString = data["userPhotoURL"],
                    !email.isEmpty {
                    let personID = snapshot.key
                    // TO-DO: Fix the explicit unwrapping
                    DispatchQueue.main.async {
                        let person = Person(name: name, surname: surname, email: email, photoURLString: photoURLString, personID: personID)
                        self?.people.append(person)
                        onCompletion(true)
                    }
                }
            })
        }
    }

    func getCount() -> Int {
        return people.count
    }
}
