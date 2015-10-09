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

    init(departure: NSDate, arrival: NSDate, actualDeparture: NSDate? = nil) {
        self.departure = departure
        self.arrival = arrival
        self.actualDeparture = actualDeparture ?? departure
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!

    let trip = Trip(departure: NSDate(timeIntervalSince1970: 1444396193), arrival: NSDate(timeIntervalSince1970: 1444397193), actualDeparture: NSDate(timeIntervalSince1970: 1444396493))

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        departureTimeLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        arrivalTimeLabel.text = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)

        let durationFormatter = NSDateComponentsFormatter()
        durationFormatter.allowedUnits = [.Hour, .Minute]
        durationFormatter.unitsStyle = .Short
        durationLabel.text = durationFormatter.stringFromDate(trip.departure, toDate: trip.arrival)

        let delay = trip.actualDeparture.timeIntervalSinceDate(trip.departure)
        if delay > 0 {
            durationFormatter.unitsStyle = .Full
            delayLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), durationFormatter.stringFromTimeInterval(delay)!)
            departureTimeLabel.textColor = .redColor()
        } else {
            delayLabel.hidden = true
        }
    }

}

