//
//  CreateEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FSCalendar

class CreateEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var sportCollection: UICollectionView!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var eventTitle: UITextField!
    @IBOutlet var eventLocation: UITextField!
    @IBOutlet var startTime: UITextField!
    @IBOutlet var endTime: UITextField!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var sportsArray: [Sport] = []
    var isSelected: Bool = false
    var selectedIndexPath: IndexPath = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mDb = DatabaseUtils.sharedInstance
        mDb.readDecuments(from: .sports, returning: Sport.self) { (objectArray) in
            self.sportsArray = objectArray
            self.sportCollection.reloadData()
        }

        // CollectionView Setup
        sportCollection.register(UINib.init(nibName: "PickSport", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        sportCollection.delegate = self
        sportCollection.dataSource = self
        sportCollection.backgroundColor = UIColor.clear

        calendarSetUp()

        startTime.addTarget(self, action: #selector(timeSelector(textField:)), for: UIControl.Event.touchDown)

    }

    func calendarSetUp() {
        //calendar.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        //calendar.layer.borderWidth = 1
        //calendar.scrollEnabled = false
        calendar.setScope(.week, animated: false)
        calendar.firstWeekday = CalendarUtils.getFirstWeekday()
    }

    @objc func timeSelector(textField: UITextField) {
        
    }

    @IBAction func closeCreateView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createEvent(_ sender: Any) {
        guard let player = AuthUtils.currentUser()
            else {
                SnackbarUtils.snackbarMake(message: "There was an authentification ERROR", title: nil)
                return
        }

        // Validate empty form
        if let title = eventTitle.text , !title.isEmpty, let location = eventLocation.text , !location.isEmpty, let start = startTime.text, !start.isEmpty, let end = endTime.text, !end.isEmpty, isSelected {

            let playerRef = mDb.documentReference(docRef: player.id, from: .players)
            let event = Event(eventHost: playerRef, sport: sportsArray[selectedIndexPath.row].category, sportThumbnail: sportsArray[selectedIndexPath.row].active, title: title, latitude: 1.1, longitude: 1.1, location: location, startDate: 1, endDate: 1, maxAttendees: 5, attendees: [playerRef])

            mDb.addDocument(withId: event.id, object: event, to: .events) { (success) in
                if(success) {
                    // Event added to Firestore
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // There was an error adding the event to Firestore
                    SnackbarUtils.snackbarMake(message: "Something went wront", title: nil)
                }
            }
        } else {
            SnackbarUtils.snackbarMake(message: "Please make sure eveything is filled", title: nil)
        }
    }

}

extension CreateEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArray.count
    }

    // Set CollectionViewCell dimentions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PickSportCollectionViewCell

        let sport = sportsArray[indexPath.row]

        cell.configureCell(with: sport, isActive: false)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Toggle selected sport
        if(!isSelected) {
            isSelected = true
        }

        // If there is a sport selected change back to idle
        if(!selectedIndexPath.isEmpty) {
            if let selectedSport = collectionView.cellForItem(at: selectedIndexPath) as? PickSportCollectionViewCell {
                selectedSport.configureCell(with: sportsArray[selectedIndexPath.row], isActive: false)
            }
        }

        let cell = collectionView.cellForItem(at: indexPath) as! PickSportCollectionViewCell
        cell.configureCell(with: sportsArray[indexPath.row], isActive: true)

        // Set the currently selected to be the already selected
        selectedIndexPath = indexPath
    }

}
