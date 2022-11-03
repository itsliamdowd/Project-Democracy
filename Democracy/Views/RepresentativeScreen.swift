//
//  RepresenativeScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 11/1/22.
//


import UIKit
import SDWebImage
import SwiftyJSON
import MapKit
import SwiftUI

class RepresentativeScreen: UIViewController {
    @IBOutlet weak var representativeName: UILabel!
    @IBOutlet weak var representativeParty: UIButton!
    @IBOutlet weak var representativeOffice: UILabel!
    @IBOutlet weak var representativeImage: UIImageView!
    @IBOutlet weak var billsButton: UIButton!
    @IBOutlet weak var representativeDescription: UITextView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var screenText: UITextView!
    @IBOutlet weak var webSite: UIButton!
    @IBOutlet weak var socialMedia: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var swipeScreen: UIView!
    
    //Defines variables passed to it from other view controllers
    var representative: Current.Representative?
    var homescreendata = [BallotpediaElection]()
    var allCandidates = [BallotpediaElection.Candidate]()
    var arrayOfRepresentatives = [Current.Representative]()
    var electionNameData = ""
    
    //Presents ElectionScreen when back button is pressed and passes homescreendata along with it
    
    @IBAction func representativeSocialMediaButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "RepresentativeTwitterScreen") as? RepresentativeTwitterScreen {
                vc.representative = self.representative!
                self.present(vc, animated: true)
            }
       }
    }
    
    @IBAction func representativeWebsiteButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "RepresentativeWebsiteScreen") as? RepresentativeWebsiteScreen {
                vc.representative = self.representative!
                self.present(vc, animated: true)
            }
       }
    }
    
    @IBAction func representativePhoneButtonPressed(_ sender: Any) {
        if representative?.phone != "None" {
            guard let number = URL(string: "telprompt://" + (representative?.phone!)!) else { return }
            UIApplication.shared.open(number)
        }
        else {
            print("No phone number")
        }
    }
    
    @IBAction func mapsButtonPressed(_ sender: Any) {
        if representative?.address != "None" {
            let myAddress = representative?.address
            print(representative?.address)
            var semaphore = DispatchSemaphore (value: 0)
            var urlForData = "https://api.geoapify.com/v1/geocode/search?text=" + (representative?.address!)! + "/&apiKey=c0b339b5bd9d47f8ae7c9461392c70cb"
            var urlString = urlForData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            var request = URLRequest(url: URL(string: urlString!)!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
              }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let features = json["features"] as! [[String: Any]]
                    let properties = features[0]["properties"] as! [String: Any]
                    let lat = properties["lat"] as! Double
                    let lon = properties["lon"] as! Double
                    let regionDistance:CLLocationDistance = 100
                    let coordinates = CLLocationCoordinate2DMake(lat, lon)
                    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                    let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                    ]
                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = self.representative?.address
                    mapItem.openInMaps(launchOptions: options)
                } catch {
                  print("Error")
                  print(error.localizedDescription)
                }
              semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
        else {
            print("No address")
        }
    }
    
    @IBAction func billsButtonPressed(_ sender: Any) {
        print("HERE2323")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Makes representative usable
        //guard let representative = representative else {
        //    return
        //}
        print("Made it to representative screen")
        guard let representative = representative else {
            return
        }
        representativeParty.layer.cornerRadius = 15
        swipeScreen.layer.cornerRadius = 15
        billsButton.layer.cornerRadius = 15
        
        //Sets party label with party color
        var party = representative.party
        print(party)
        switch party {
            case "Republican Party":
                print("Republican")
                representativeParty.backgroundColor = UIColor.red
            representativeParty.setTitle("Republican", for: .normal)
            case "Democratic Party":
                print("Democrat")
                representativeParty.backgroundColor = UIColor.blue
                representativeParty.setTitle("Democrat", for: .normal)
            case "Libertarian Party":
                print("Libertarian")
                representativeParty.backgroundColor = UIColor(red: 0.9176, green: 0.8431, blue: 0.2824, alpha: 1.0)
                representativeParty.setTitle("Libertarian", for: .normal)
                //make better color
            case "Green Party":
                print("Green")
                representativeParty.backgroundColor = UIColor(hue: 0.3861, saturation: 0.79, brightness: 0.83, alpha: 1.0)
                representativeParty.setTitle("Green Party", for: .normal)
                //make better color
            case "Nonpartisan":
                print("Nonpartisan")
                representativeParty.backgroundColor = UIColor.gray
                representativeParty.setTitle("Nonpartisan", for: .normal)
            case "No Party Affiliation":
                print("Nonpartisan")
                representativeParty.backgroundColor = UIColor.gray
                representativeParty.setTitle("Nonpartisan", for: .normal)
            default:
                print("Other")
                representativeParty.backgroundColor = UIColor.gray
                representativeParty.setTitle(party, for: .normal)
                representativeParty.sizeToFit()
                representativeParty.frame.size.width += 20
        }
        
        //Sets name label
        if representative.name != nil {
            print(representative.name)
            self.representativeName.text = representative.name
        }
        else {
            print("Error")
        }
        
        //Sets description
        if representative.biography != nil && representative.biography != "" {
            self.representativeDescription.text = representative.biography! + "\n\n"
        }
        else {
            print("Error")
        }
        
        //Sets organizations
        
        if representative.organizations != nil && representative.organizations != ["": ""] {
            var dataToAdd = "Top Organizations Supporting " + representative.name + ":\n\n"
            var representativeOrganizations = representative.organizations
            func topValuesFirst(){
                var highestValue = 0
                var highestValueKey = ""
                for (key, value) in representativeOrganizations {
                    if Int(value)! > highestValue {
                        highestValue = Int(value)!
                        highestValueKey = key
                    }
                }
                dataToAdd += highestValueKey + ": $" + Int(highestValue).withCommas() + "\n"
                representativeOrganizations.removeValue(forKey: highestValueKey)
                if representativeOrganizations.count > 0 {
                    topValuesFirst()
                }

            }
            topValuesFirst()
            self.representativeDescription.text = self.representativeDescription.text + dataToAdd
        }
        
        //Sets sectors
        if representative.sectors != nil && representative.sectors != ["": ""] {
            var additionalDataToAdd = "\nTop Sectors Supporting " + representative.name + ":\n\n"
            var representativeSectors = representative.sectors
            func topValuesFirst(){
                var highestValue = 0
                var highestValueKey = ""
                for (key, value) in representativeSectors {
                    if Int(value)! > highestValue {
                        highestValue = Int(value)!
                        highestValueKey = key
                    }
                }
                additionalDataToAdd += highestValueKey + ": $" + Int(highestValue).withCommas() + "\n"
                representativeSectors.removeValue(forKey: highestValueKey)
                if representativeSectors.count > 0 {
                    topValuesFirst()
                }

            }
            topValuesFirst()
            self.representativeDescription.text = self.representativeDescription.text + additionalDataToAdd
        }
        
        if self.representativeDescription.text == "" || self.representativeDescription.text == "\n\n" {
            self.representativeDescription.text = "No biography is available for this representative.\n\nMake sure to check the representative's website and social media for more information."
        }
        
        if representative.url == nil {
            webSite.isHidden = true
        }
        else {
            webSite.isHidden = false
        }
        
        if representative.twitterUrl == nil || representative.twitterUrl == "" && representative.facebookUrl == nil {
            socialMedia.isHidden = true
        }
        else {
            socialMedia.isHidden = false
        }
        
        if representative.phone == nil || representative.phone == "" || representative.phone == "None" {
            callButton.isHidden = true
        }
        else {
            callButton.isHidden = false
        }
        
        if representative.address == nil || representative.address == "" || representative.address == "None" {
            mapsButton.isHidden = true
        }
        else {
            mapsButton.isHidden = false
        }
        
        if representative.level != nil {
            DispatchQueue.main.async {
                self.representativeOffice.text = representative.level
            }
        }
        else {
            representativeOffice.isHidden = true
        }
        
        // Make sure a valid URL exists
        guard let url = representative.imageUrl
        else {
            // Show image unavailable SwiftUI view
            let unavailableView = UIHostingController(rootView: ImageUnavailableView()).view! // We are sure that the view exists
            let parentView = representativeImage.superview! // We are sure there's always a parent view
            parentView.insertSubview(unavailableView, belowSubview: representativeImage)
            representativeImage.removeFromSuperview()

            // Set constraints for the new unavailable view
            unavailableView.translatesAutoresizingMaskIntoConstraints = false
            let safeArea = parentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                unavailableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                         constant: 19),
                unavailableView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                     constant: 30),
            ])
            return
        }
        //Sets image to the representative's image and caches the image for later use
        representativeImage.sd_setImage(with: representative.imageUrl)
        representativeImage.contentMode = .scaleAspectFill
        representativeImage.layer.cornerRadius = 10
        representativeImage.layer.cornerCurve = .continuous
        representativeImage.layer.masksToBounds = true
    }
}

//MARK: - API and parsing
extension RepresentativeScreen {
    private func loadFundingData() {

    }
}
