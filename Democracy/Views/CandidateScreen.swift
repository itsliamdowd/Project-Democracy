//
//  CandidateScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit
import SDWebImage
import SwiftyJSON
import MapKit
import SwiftUI

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

class CandidateScreen: UIViewController {
    @IBOutlet var candidateName: UILabel!
    @IBOutlet var candidateParty: UIButton!
    @IBOutlet var candidateOccupation: UILabel!
    @IBOutlet var candidateImage: UIImageView!
    @IBOutlet weak var candidateDescription: UITextView!
    @IBOutlet var swipeScreen: UIView!
    @IBOutlet var textScreen: UIView!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var screenText: UITextView!
    @IBOutlet var incumbent: UIButton!
    @IBOutlet weak var socialMedia: UIButton!
    @IBOutlet weak var webSite: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mapsButton: UIButton!
    
    //Defines variables passed to it from other view controllers
    var candidate: BallotpediaElection.Candidate?
    var candidates = [BallotpediaElection.Candidate]()
    var homescreendata = [BallotpediaElection]()
    var electionNameData = ""
    
    //Presents ElectionScreen when back button is pressed and passes homescreendata along with it
    
    @IBAction func candidateSocialMediaButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateTwitterScreen") as? CandidateTwitterScreen {
                vc.candidate = self.candidate
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func candidateWebsiteButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateWebsiteScreen") as? CandidateWebsiteScreen {
                vc.candidate = self.candidate
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func candidatePhoneButtonPressed(_ sender: Any) {
        if candidate!.phone != "None" {
            guard let number = URL(string: "telprompt://" + candidate!.phone) else { return }
            UIApplication.shared.open(number)
        }
        else {
            print("No phone number")
        }
    }
    
    @IBAction func mapsButtonPressed(_ sender: Any) {
        if candidate!.address != "None" {
            let myAddress = candidate!.address
            print(candidate!.address)
            var semaphore = DispatchSemaphore (value: 0)
            var urlForData = "https://api.geoapify.com/v1/geocode/search?text=" + candidate!.address + "/&apiKey=c0b339b5bd9d47f8ae7c9461392c70cb"
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
                    mapItem.name = self.candidate!.address
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Makes candidate usable
        guard let candidate = candidate else {
            return
        }
        print("Made it to candidate screen")
        candidateParty.layer.cornerRadius = 15
        incumbent.layer.cornerRadius = 15
        swipeScreen.layer.cornerRadius = 15
        
        //Sets party label with party color
        var party = candidate.party
        print(party)
        switch party {
        case "Republican Party":
            print("Republican")
            candidateParty.backgroundColor = UIColor.red
            candidateParty.setTitle("Republican", for: .normal)
        case "Democratic Party":
            print("Democrat")
            candidateParty.backgroundColor = UIColor.blue
            candidateParty.setTitle("Democrat", for: .normal)
        case "Libertarian Party":
            print("Libertarian")
            candidateParty.backgroundColor = UIColor(red: 0.9176, green: 0.8431, blue: 0.2824, alpha: 1.0)
            candidateParty.setTitle("Libertarian", for: .normal)
            //make better color
        case "Green Party":
            print("Green")
            candidateParty.backgroundColor = UIColor(hue: 0.3861, saturation: 0.79, brightness: 0.83, alpha: 1.0)
            candidateParty.setTitle("Green Party", for: .normal)
            //make better color
        case "Nonpartisan":
            print("Nonpartisan")
            candidateParty.backgroundColor = UIColor.gray
            candidateParty.setTitle("Nonpartisan", for: .normal)
        case "No Party Affiliation":
            print("Nonpartisan")
            candidateParty.backgroundColor = UIColor.gray
            candidateParty.setTitle("Nonpartisan", for: .normal)
        default:
            print("Other")
            candidateParty.backgroundColor = UIColor.gray
            candidateParty.setTitle(party, for: .normal)
            if candidate.isIncumbent == true {
                print("Skipping")
            }
            else {
                candidateParty.sizeToFit()
                candidateParty.frame.size.width += 20
            }
        }
        
        //Sets the incumbent button to be shown or not depending on if the candidate is currently serving
        var incumbent = candidate.isIncumbent
        switch incumbent {
        case true:
            print("Incumbent")
            self.incumbent.isHidden = false
        case false:
            print("Not incumbent")
            self.incumbent.isHidden = true
        default:
            print("Other")
            self.incumbent.isHidden = true
        }
        
        //Sets name label
        if candidate.name != nil {
            print(candidate.name)
            self.candidateName.text = candidate.name
        }
        else {
            print("Error")
        }
        
        //Sets description
        if candidate.biography != nil && candidate.biography != "" {
            self.candidateDescription.text = candidate.biography + "\n\n"
        }
        else {
            print("Error")
        }
        
        //Sets organizations
        
        if candidate.organizations != nil && candidate.organizations != ["": ""] {
            var dataToAdd = "Top Organizations Supporting " + candidate.name + ":\n\n"
            var candidateOrganizations = candidate.organizations
            func topValuesFirst(){
                var highestValue = 0
                var highestValueKey = ""
                for (key, value) in candidateOrganizations {
                    if Int(value)! > highestValue {
                        highestValue = Int(value)!
                        highestValueKey = key
                    }
                }
                dataToAdd += highestValueKey + ": $" + Int(highestValue).withCommas() + "\n"
                candidateOrganizations.removeValue(forKey: highestValueKey)
                if candidateOrganizations.count > 0 {
                    topValuesFirst()
                }

            }
            topValuesFirst()
            self.candidateDescription.text = self.candidateDescription.text + dataToAdd
        }
        
        //Sets sectors
        if candidate.sectors != nil && candidate.sectors != ["": ""] {
            var additionalDataToAdd = "\nTop Sectors Supporting " + candidate.name + ":\n\n"
            var candidateSectors = candidate.sectors
            func topValuesFirst(){
                var highestValue = 0
                var highestValueKey = ""
                for (key, value) in candidateSectors {
                    if Int(value)! > highestValue {
                        highestValue = Int(value)!
                        highestValueKey = key
                    }
                }
                additionalDataToAdd += highestValueKey + ": $" + Int(highestValue).withCommas() + "\n"
                candidateSectors.removeValue(forKey: highestValueKey)
                if candidateSectors.count > 0 {
                    topValuesFirst()
                }

            }
            topValuesFirst()
            self.candidateDescription.text = self.candidateDescription.text + additionalDataToAdd
        }

        if self.candidateDescription.text == "" || self.candidateDescription.text == "\n\n" {
            self.candidateDescription.text = "No biography is available for this candidate.\n\nMake sure to check the candidate's website and social media for more information."
        }
        
        if candidate.websiteUrl == nil {
            webSite.isHidden = true
        }
        else {
            webSite.isHidden = false
        }
        
        if candidate.twitterUrl == nil || candidate.twitterUrl == "" && candidate.facebookUrl == nil {
            socialMedia.isHidden = true
        }
        else {
            socialMedia.isHidden = false
        }
        
        if candidate.phone == nil || candidate.phone == "" || candidate.phone == "None" {
            callButton.isHidden = true
        }
        else {
            callButton.isHidden = false
        }
        
        if candidate.address == nil || candidate.address == "" || candidate.address == "None" {
            mapsButton.isHidden = true
        }
        else {
            mapsButton.isHidden = false
        }
        
        candidateOccupation.isHidden = true

        // Make sure a valid URL exists
        if let url = candidate.imageUrl {
            //Sets image to the candidate's image and caches the image for later use
            candidateImage.sd_setImage(with: candidate.imageUrl)
            candidateImage.contentMode = .scaleAspectFill
            candidateImage.layer.cornerRadius = 10
            candidateImage.layer.cornerCurve = .continuous
            candidateImage.layer.masksToBounds = true
        }
        else {
            // Show image unavailable SwiftUI view
            let unavailableView = UIHostingController(rootView: ImageUnavailableView()).view! // We are sure that the view exists
            let parentView = candidateImage.superview! // We are sure there's always a parent view
            parentView.insertSubview(unavailableView, belowSubview: candidateImage)
            candidateImage.removeFromSuperview()

            // Set constraints for the new unavailable view
            unavailableView.translatesAutoresizingMaskIntoConstraints = false
            let safeArea = parentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                unavailableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                         constant: 19),
                unavailableView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                     constant: 30),
            ])
        }

        TranslateManager.shared.addViews(views: [candidateName, candidateParty, candidateOccupation, candidateDescription, screenText, screenTitle, self.incumbent])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }
}

//MARK: - API and parsing
extension CandidateScreen {
    private func loadFundingData() {

    }
}
