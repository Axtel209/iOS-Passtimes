//
//  CreateEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase
import FSCalendar
import GooglePlaces

class CreateEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var sportCollection: UICollectionView!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var eventTitle: UITextField!
    @IBOutlet var eventLocation: UITextField!
    @IBOutlet var maxPlayers: UITextField!
    @IBOutlet var startTime: UITextField!
    @IBOutlet var endTime: UITextField!
    @IBOutlet var titleCount: UILabel!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var sportsArray: [Sport] = []
    var isSelected: Bool = false
    var selectedIndexPath: IndexPath = []
    var listeners: [ListenerRegistration] = []
    let timePicker = UIDatePicker()
    let numberPicker = UIPickerView()
    let pickerData = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50]

    var startDate = Date()
    var endDate = Date()
    var startTimeInMillis: Int = 0
    var endTimeInMillis: Int = 0
    var date = Date()

    var isEditingEvent: Bool = false
    var editingEvent: Event!

    var coordinates = CLLocationCoordinate2D(latitude: 28.595914, longitude: -81.301503)

    override func viewDidLoad() {
        super.viewDidLoad()



        // CollectionView Setup
        sportCollection.register(UINib.init(nibName: "PickSport", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        sportCollection.delegate = self
        sportCollection.dataSource = self
        sportCollection.backgroundColor = UIColor.clear

        if isEditingEvent {
            populateEditingEvent()
        }

        calendarSetUp()

        mDb = DatabaseUtils.sharedInstance
        mDb.readDecuments(from: .sports, returning: Sport.self) { (objectArray) in
            self.sportsArray = objectArray
            self.sportCollection.reloadData()
        }

        hideKeyboardWhenTappedAround()

        eventTitle.inputAccessoryView = toolbarAccessoryView()
        eventLocation.inputAccessoryView = toolbarAccessoryView()

        numberPicker.delegate = self
        numberPicker.dataSource = self
        numberPicker.backgroundColor = UIColor.white

        maxPlayers.inputView = numberPicker
        maxPlayers.inputAccessoryView = toolbarAccessoryView()

        timePicker.datePickerMode = .time
        timePicker.frame = CGRect(x: 0.0, y: self.view.frame.height - 150.0, width: self.view.frame.width, height: 150.0)
        timePicker.backgroundColor = UIColor.white

        startTime.inputView = timePicker
        startTime.inputAccessoryView = toolbarAccessoryView()

        endTime.inputView = timePicker
        endTime.inputAccessoryView = toolbarAccessoryView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

    func populateEditingEvent() {
        self.eventTitle.text = editingEvent.title
        self.eventLocation.text = editingEvent.location
        self.startTime.text = CalendarUtils.getHoursFromDateTimestamp(editingEvent.startDate)
        self.endTime.text = CalendarUtils.getHoursFromDateTimestamp(editingEvent.endDate)
        self.calendar.today = Date(timeIntervalSince1970: Double(editingEvent.startDate / 1000))
        self.maxPlayers.text = String(editingEvent.maxAttendees)

        startTimeInMillis = self.editingEvent.startDate
        endTimeInMillis = self.editingEvent.endDate
    }

    func calendarSetUp() {
        calendar.setScope(.week, animated: false)
        calendar.firstWeekday = CalendarUtils.getFirstWeekday()
    }

    @objc func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
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

        //self.view.isUserInteractionEnabled = false
        let activityIndicator = ActivityIndicatorUtils.activityIndicatorMake(view: self.view)

        if isEditingEvent {
            if startTimeInMillis > endTimeInMillis {
                SnackbarUtils.snackbarMake(message: "Please enter a end time later than the end time", title: nil)
                return
            } else if startTimeInMillis == endTimeInMillis {
                SnackbarUtils.snackbarMake(message: "Please enter an end time greater than the strat time", title: nil)
                return
            } else if CalendarUtils.dateToMillis(date) > startTimeInMillis {
                SnackbarUtils.snackbarMake(message: "Plase enter a strat time later than the current time", title: nil)
                return
            }

            activityIndicator.startAnimating()

            self.editingEvent.title = self.eventTitle.text!
            self.editingEvent.location = self.eventLocation.text!
            self.editingEvent.startDate = startTimeInMillis
            self.editingEvent.endDate = endTimeInMillis
            self.editingEvent.maxAttendees = Int(self.maxPlayers.text!)!
            self.editingEvent.latitude = coordinates.latitude
            self.editingEvent.longitude = coordinates.longitude

            let updatedEvent = try? FirestoreEncoder().encode(editingEvent)

            mDb.updateDocument(withReference: editingEvent.id, from: .events, data: updatedEvent!) { (success) in
                if success {
                    activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    SnackbarUtils.snackbarMake(message: "Please check your internet connection", title: nil)
                }
            }
            //self.mDb.updateDocument(withReference: player.id, from: .players, data: ["favorites": FieldValue.arrayUnion(sportRefs)], completion: { (success) in
        } else {
            // Validate empty form
            if let title = eventTitle.text , !title.isEmpty, let location = eventLocation.text , !location.isEmpty, let max = maxPlayers.text, !max.isEmpty, let start = startTime.text, !start.isEmpty, let end = endTime.text, !end.isEmpty, isSelected {

                if startTimeInMillis > endTimeInMillis {
                    SnackbarUtils.snackbarMake(message: "Please enter a start time later than the end time", title: nil)
                    return
                } else if startTimeInMillis == endTimeInMillis {
                    SnackbarUtils.snackbarMake(message: "Please enter an end time greater than the strat time", title: nil)
                    return
                } else if CalendarUtils.dateToMillis(date) > startTimeInMillis {
                    SnackbarUtils.snackbarMake(message: "Plase enter a strat time later than the current time", title: nil)
                    return
                }

                let playerRef = mDb.documentReference(docRef: player.id, from: .players)
                let event = Event(eventHost: playerRef, sport: sportsArray[selectedIndexPath.row].category, sportThumbnail: sportsArray[selectedIndexPath.row].active, title: title, latitude: coordinates.latitude, longitude: coordinates.longitude, location: location, startDate: startTimeInMillis, endDate: endTimeInMillis, maxAttendees: Int(max)!, attendees: [playerRef])

                activityIndicator.startAnimating()
                mDb.addDocument(withId: event.id, object: event, to: .events) { (success) in
                    if(success) {
                        // Add EventRef to player attending
                        let eventRef = self.mDb.documentReference(docRef: event.id, from: .events)
                        self.mDb.updateDocument(withReference: player.id, from: .players, data: ["attending": FieldValue.arrayUnion([eventRef])], completion: { (success) in
                            if success {
                                activityIndicator.stopAnimating()
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                // Error trying to add Eventref to player attending
                                SnackbarUtils.snackbarMake(message: "Please check your internet connection", title: nil)
                            }
                        })
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

        if let editEvent = editingEvent {
            if editingEvent.sport == sport.category {
                cell.isActive = true
            }
        }

        cell.configureCell(with: sport)


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingEvent {
            SnackbarUtils.snackbarMake(message: "Can't change sport when editing", title: nil)
            return
        }

        // Toggle selected sport
        if(!isSelected) {
            isSelected = true
        }

        // If there is a sport selected change back to idle
        if(!selectedIndexPath.isEmpty) {
            if let selectedSport = collectionView.cellForItem(at: selectedIndexPath) as? PickSportCollectionViewCell {
                selectedSport.isActive = false
                selectedSport.configureCell(with: sportsArray[selectedIndexPath.row])
            }
        }

        let cell = collectionView.cellForItem(at: indexPath) as! PickSportCollectionViewCell
        cell.isActive = true
        cell.configureCell(with: sportsArray[indexPath.row])

        // Set the currently selected to be the already selected
        selectedIndexPath = indexPath
    }

}

extension CreateEventViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Make endtime 1 hour after start time
        if textField == startTime {
            if startTimeInMillis > 0 {
                timePicker.date = Date(timeIntervalSince1970: Double(startTimeInMillis) / 1000)
            }
        } else if textField == endTime {
            if startTimeInMillis > 0 {
                // Add one hour to startTime
                timePicker.date = Date(timeIntervalSince1970: Double((startTimeInMillis + 3600000) / 1000))
            }
        } else if textField == eventLocation {
            let autoComplete = GMSAutocompleteViewController()
            autoComplete.delegate = self
            self.present(autoComplete, animated: true, completion: nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let timePickerDate = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: timePickerDate)
//        date = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: date)!

        if textField == startTime {
            startDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: startDate)!
            startTimeInMillis = CalendarUtils.dateToMillis(startDate)
            startTime.text = CalendarUtils.getHoursFromDateTimestamp(startTimeInMillis)
        } else if textField == endTime {
            endDate = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: endDate)!
            endTimeInMillis = CalendarUtils.dateToMillis(endDate)
            endTime.text = CalendarUtils.getHoursFromDateTimestamp(endTimeInMillis)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let title = eventTitle.text else { return true }
        let count = title.count + string.count - range.length

        if count <= 20 {
            titleCount.text = "\(count)/20"
        }

        return count <= 20
    }

}

extension CreateEventViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.today = date

        let components = Calendar.current.dateComponents([.day], from: date)
        print(components.day!)
        //self.startDate = Calendar.current.date(bySetting: .day, value: components.day!, of: self.startDate)!
        //self.date = Calendar.current.date(from: components)!
        var startDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate)
        startDateComponents.day = components.day
        self.startDate = Calendar.current.date(from: startDateComponents)!

        var endDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        endDateComponents.day = components.day
        self.endDate = Calendar.current.date(from: endDateComponents)!
    }

}

extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        maxPlayers.text = String(pickerData[row])
    }

}

extension CreateEventViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.eventLocation.text = place.name
        self.coordinates = place.coordinate
        print(place.name)
        print(place.formattedAddress!)
        print(String(describing: place.attributions))
        self.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("AutoComplete was cancelled")
        self.dismiss(animated: true, completion: nil)
    }




}
