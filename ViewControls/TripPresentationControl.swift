//
//  TripPresentationControl.swift
//  ViewControls
//
//  Created by Lammert Westerhoff on 09/10/15.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import UIKit

class TripPresentationControl: NSObject {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!

    var trip: Trip! {
        didSet {
            dateLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
            departureTimeLabel.text = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            arrivalTimeLabel.text  = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)

            let durationFormatter = NSDateComponentsFormatter()
            durationFormatter.allowedUnits = [.Hour, .Minute]
            durationFormatter.unitsStyle = .Short
            durationLabel.text = durationFormatter.stringFromTimeInterval(trip.duration)!

            delayLabel.hidden = !trip.delayed
            if trip.delayed {
                durationFormatter.unitsStyle = .Full
                delayLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), durationFormatter.stringFromTimeInterval(trip.delay)!)
                departureTimeLabel.textColor = .redColor()
            }
        }
    }
}


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