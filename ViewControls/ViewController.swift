//
//  ViewController.swift
//  ViewControls
//
//  Created by Lammert Westerhoff on 09/10/15.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tripPresentationControl: TripPresentationControl!

    let trip = Trip(departure: NSDate(timeIntervalSince1970: 1444396193), arrival: NSDate(timeIntervalSince1970: 1444397193), actualDeparture: NSDate(timeIntervalSince1970: 1444396493))

    override func viewDidLoad() {
        super.viewDidLoad()

        tripPresentationControl.trip = trip
    }

}
