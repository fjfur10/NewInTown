//
//  ViewController.swift
//  GetMeHelp
//
//  Created by Francis Furnelli on 12/18/20.
//

import UIKit
import RadarSDK
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var optionPicker: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!

    var locationManager = CLLocationManager()
    
    var pickerData = [String : String]()
    var placeArr = [RadarPlace]()
    let test = ["Test"]
    var lat = 1.0
    var long = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["Doctors" : "doctor", "Medical Centers" : "medical-center", "Medical Services" : "medical-service", "Pharmacies" : "pharmacy"]
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        titleLabel.text = "GetMeHelp!"
        titleLabel.isHidden = false
        optionPicker.dataSource = self
        optionPicker.delegate = self
        tableView.dataSource = self
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data =  Array(pickerData.keys)
        return data[row]
    }
    
    @IBAction func didTouchDoneButton(_ sender: UIButton) {
        let loc = CLLocation(latitude: lat, longitude: long)
        let vals = Array(pickerData.values)
        Radar.searchPlaces(
          near: loc,
          radius: 1000, // meters
            chains: nil,
            categories: [vals[optionPicker.selectedRow(inComponent: 0)]],
          groups: nil,
          limit: 10
        ) { (status, location, places) in
          // do something with places
            self.placeArr = places!
            for place in self.placeArr {
                print(place.name)
            }
            self.tableView.reloadData()
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = Double(locValue.latitude)
        long = Double(locValue.longitude)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
                
        let text = placeArr[indexPath.row].name
                
        cell.textLabel?.text = text
                
        return cell
    }
    
}

