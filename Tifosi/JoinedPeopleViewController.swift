//
//  JoinedPeopleViewController.swift
//  Tifosi
//
//  Created by COBE Osijek on 02/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class JoinedPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var peopleWhoJoined = EventPeopleManager()

    var currentEvent: Event?

    @IBOutlet weak var joinedPeopleTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        peopleWhoJoined.getPeople(key: (currentEvent?.eventID)!) { _ in
            self.joinedPeopleTableView.reloadData()
        }
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleWhoJoined.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? JoinedPersonTableViewCell else {
            fatalError("Cell is not JoinedPersonTableViewCell")
        }

        let fbImageURL = URL(fileURLWithPath: peopleWhoJoined.people[indexPath.row].photoURLString)
        let fbImageData = try? Data(contentsOf: fbImageURL)
        let fbImage = UIImage(data: fbImageData!)

        cell.facebookName.text = peopleWhoJoined.people[indexPath.row].name + " " + peopleWhoJoined.people[indexPath.row].surname
        cell.facebookImage.image = fbImage

        return cell
    }
}
