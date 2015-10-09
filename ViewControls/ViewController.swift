//
//  ViewController.swift
//  ViewControls
//
//  Created by Lammert Westerhoff on 09/10/15.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class Trip {

    let departure: NSDate
    let arrival: NSDate
    let actualDeparture: NSDate
    let delay: NSTimeInterval
    let delayed: Bool
    let duration: NSTimeInterval

    init(departure: NSDate, arrival: NSDate, actualDeparture: NSDate? = nil) {
        self.departure = departure
        self.arrival = arrival
        self.actualDeparture = actualDeparture ?? departure

        // calculations
        duration = self.arrival.timeIntervalSinceDate(self.departure)
        delay = self.actualDeparture.timeIntervalSinceDate(self.departure)
        delayed = delay > 0
    }
}

class TripViewViewModel {

    let date: String
    let departure: String
    let arrival: String
    let duration: String
    let delay: String?
    let delayHidden: Bool
    let departureTimeColor: UIColor

    init(_ trip: Trip) {
        date = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        departure = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        arrival = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)

        let durationFormatter = NSDateComponentsFormatter()
        durationFormatter.allowedUnits = [.Hour, .Minute]
        durationFormatter.unitsStyle = .Short
        duration = durationFormatter.stringFromTimeInterval(trip.duration)!

        delayHidden = !trip.delayed
        if trip.delayed {
            durationFormatter.unitsStyle = .Full
            delay = String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), durationFormatter.stringFromTimeInterval(trip.delay)!)
            departureTimeColor = .redColor()
        } else {
            self.delay = nil
            departureTimeColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!

    let tripModel = TripViewViewModel(Trip(departure: NSDate(timeIntervalSince1970: 1444396193), arrival: NSDate(timeIntervalSince1970: 1444397193), actualDeparture: NSDate(timeIntervalSince1970: 1444396493)))

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = tripModel.date
        departureTimeLabel.text = tripModel.departure
        arrivalTimeLabel.text = tripModel.arrival
        durationLabel.text = tripModel.duration
        delayLabel.text = tripModel.delay
        delayLabel.hidden = tripModel.delayHidden
        departureTimeLabel.textColor = tripModel.departureTimeColor
    }

}

