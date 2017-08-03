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

    func removeEvent(eventID: String, onCompletion: @escaping ((Bool) -> Void)) {
        _ = Constants.Refs.databaseEvents.child(eventID).removeValue(completionBlock: { [weak self] Error, _ in
            if Error != nil {
                onCompletion(false)
            } else {
                if let events = self?.events.enumerated() {
                    for (index, event) in events {
                        if event.eventID == eventID {
                            self?.events.remove(at: index)
                        }
                    }
                }
                onCompletion(true)
            }
        })
    }

    func getCount() -> Int {
        return events.count
    }

    func addEventToDatabase(eventToAdd: Event) {
        let ref = Constants.Refs.databaseEvents.childByAutoId()

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CET")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let eventDateString = formatter.string(from: eventToAdd.dateTime)

        let message = [
            "name": eventToAdd.name,
            "placeName": eventToAdd.place,
            "description": eventToAdd.description,
            "date": eventDateString,
            "latitude": eventToAdd.coordinates.latitude.description,
            "longitude": eventToAdd.coordinates.longitude.description,
            "userID": eventToAdd.creatorID,
        ]

        ref.setValue(message)
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

    func getPeople(key: String, onCompletion: @escaping ((Person) -> Void)) {

        let query = Constants.Refs.databaseGuests.child(key)

        DispatchQueue.global().async {
            _ = query.observe(.childAdded, with: { [weak self] snapshot in
                if let data = snapshot.value as? [String: String],
                    let name = data["userName"],
                    let surname = data["userSurname"],
                    let email = data["userEmail"],
                    let photoURLString = data["userPhotoURL"],
                    !email.isEmpty {
                    let personID = snapshot.key
                    DispatchQueue.main.async {
                        let person = Person(name: name, surname: surname, email: email, photoURLString: photoURLString, personID: personID)
                        self?.people.append(person)
                        onCompletion(person)
                    }
                }
            })
        }
    }

    func getCount() -> Int {
        return people.count
    }

    func joinTheEvent(eventID: String) {
        if let userID = FacebookUser.fbUser?.userID {
            let ref = Constants.Refs.databaseGuests.child(eventID).child(userID)

            let message = [
                "userEmail": FacebookUser.fbUser?.eMail,
                "userName": FacebookUser.fbUser?.firstName,
                "userSurname": FacebookUser.fbUser?.lastName,
                "userPhotoURL": FacebookUser.fbUser?.userPhotoURL,
            ]

            ref.setValue(message)
        }
    }

    func removeFromEvent(eventID: String, onCompletion: @escaping ((Bool) -> Void)) {
        if let userID = FacebookUser.fbUser?.userID {
            _ = Constants.Refs.databaseGuests.child(eventID).child(userID).removeValue(completionBlock: { [weak self] Error, _ in
                if Error != nil {
                    onCompletion(false)
                } else {
                    if let people = self?.people.enumerated() {
                        for (index, person) in people {
                            if person.personID == userID {
                                self?.people.remove(at: index)
                            }
                        }
                        onCompletion(true)
                    }
                }
            })
        }
    }
}
