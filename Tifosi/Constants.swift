//
//  Constants.swift
//  Tifosi
//
//  Created by COBE Osijek on 27/07/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation
import Firebase

struct Constants {

    struct Refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
        static let databaseEvents = databaseRoot.child("events")
        static let storage = Storage.storage().reference(forURL: "gs://tifosi-a5cbe.appspot.com/")
    }

    static let f1CalendarUrl = URL(string: "https://ergast.com/api/f1/current.json")!
}
