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

    var tripModel: TripViewViewModel! {
        didSet {
            dateLabel.text = tripModel.date
            departureTimeLabel.text = tripModel.departure
            arrivalTimeLabel.text  = tripModel.arrival
            durationLabel.text = tripModel.arrival

            tripModel.delay.bindAndFire { [unowned self] in
                self.delayLabel.text = $0
            }

            tripModel.delayed.bindAndFire { [unowned self] delayed in
                self.delayLabel.hidden = !delayed
                self.departureTimeLabel.textColor = delayed ? .redColor() : UIColor(red: 0, green: 0, blue: 0.4, alpha: 1.0)
            }
        }
    }
}


struct Trip {

    let departure: NSDate
    let arrival: NSDate
    let duration: NSTimeInterval

    var actualDeparture: NSDate
    var delay: NSTimeInterval {
        return self.actualDeparture.timeIntervalSinceDate(self.departure)
    }
    var delayed: Bool {
        return delay > 0
    }

    init(departure: NSDate, arrival: NSDate, actualDeparture: NSDate? = nil) {
        self.departure = departure
        self.arrival = arrival
        self.actualDeparture = actualDeparture ?? departure

        // calculations
        duration = self.arrival.timeIntervalSinceDate(self.departure)
    }
}

class TripViewViewModel {

    let date: String
    let departure: String
    let arrival: String
    let duration: String

    private static let durationShortFormatter: NSDateComponentsFormatter = {
        let durationFormatter = NSDateComponentsFormatter()
        durationFormatter.allowedUnits = [.Hour, .Minute]
        durationFormatter.unitsStyle = .Short
        return durationFormatter
        }()

    private static let durationFullFormatter: NSDateComponentsFormatter = {
        let durationFormatter = NSDateComponentsFormatter()
        durationFormatter.allowedUnits = [.Hour, .Minute]
        durationFormatter.unitsStyle = .Full
        return durationFormatter
        }()

    let delay: Dynamic<String?>
    let delayed: Dynamic<Bool>

    var trip: Trip

    init(_ trip: Trip) {
        self.trip = trip

        date = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .ShortStyle, timeStyle: .NoStyle)
        departure = NSDateFormatter.localizedStringFromDate(trip.departure, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        arrival = NSDateFormatter.localizedStringFromDate(trip.arrival, dateStyle: .NoStyle, timeStyle: .ShortStyle)

        duration = TripViewViewModel.durationShortFormatter.stringFromTimeInterval(trip.duration)!

        delay = Dynamic(trip.delayString)
        delayed = Dynamic(trip.delayed)
    }

    func changeActualDeparture(delta: NSTimeInterval) {
        trip.actualDeparture = NSDate(timeInterval: delta, sinceDate: trip.actualDeparture)

        tripUpdated()
    }

    func tripUpdated() {
        self.delay.value = trip.delayString
        self.delayed.value = trip.delayed
    }

}

extension Trip {

    private var delayString: String? {
        return delayed ? String.localizedStringWithFormat(NSLocalizedString("%@ delay", comment: "Show the delay"), TripViewViewModel.durationFullFormatter.stringFromTimeInterval(delay)!) : nil
    }
}
