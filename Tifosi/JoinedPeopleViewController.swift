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

        joinedPeopleTableView.delegate = self
        joinedPeopleTableView.dataSource = self

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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JoinedPersonTableViewCell", for: indexPath) as? JoinedPersonTableViewCell else {
            fatalError("Cell is not JoinedPersonTableViewCell")
        }

        DispatchQueue.global().async {
            if let fbImageURL = URL(string: self.peopleWhoJoined.people[indexPath.row].photoURLString) {
                if let fbImageData = try? Data(contentsOf: fbImageURL) {
                    if let fbImage = UIImage(data: fbImageData) {
                        DispatchQueue.main.async {
                            cell.facebookImage.image = fbImage
                        }
                    }
                }
            }
        }

        cell.facebookName.text = peopleWhoJoined.people[indexPath.row].name + " " + peopleWhoJoined.people[indexPath.row].surname

        return cell
    }
}
