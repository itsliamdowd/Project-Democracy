//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//
import UIKit
import SDWebImage
import Foundation
import CoreLocation

extension ElectionScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected a candidate")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if self.candidates[indexPath.row].isIncumbent == true && level == "state" || level == "federal" {
            var semaphore = DispatchSemaphore (value: 0)
            var urlForData = ""
            if self.level == "federal" {
                urlForData = "https://project-democracy.herokuapp.com/api/getInfo/" + self.candidates[indexPath.row].name + "/federal/"
            }
            else if self.level == "state" {
                urlForData = "https://project-democracy.herokuapp.com/api/getInfo/" + self.candidates[indexPath.row].name + "/state/"
            }
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
                  let json = try JSONSerialization.jsonObject(with: data, options: [])
                  if let array = json as? [Any] {
                    print(array[0])
                    if self.level == "state" {
                        if array[0] != nil && array[0] as! String != "" {
                            var phoneNumber = array[0] as! String
                            self.candidates[indexPath.row].phone = phoneNumber
                        }
                        if array[1] != nil && array[1] as! String != "" {
                            var address = array[1] as! String
                            self.candidates[indexPath.row].address = address
                        }
                    }
                    else if self.level == "federal" {
                        if array[0] != nil && array[0] as! String != "" {
                            var phoneNumber = array[0] as! String
                            self.candidates[indexPath.row].phone = phoneNumber
                        }
                        if array[2] != nil && array[2] as! String != "" {
                            var address = array[2] as! String
                            self.candidates[indexPath.row].address = address
                        }
                        if array[3] != nil {
                            var organizations = array[3]
                            self.candidates[indexPath.row].organizations = organizations as! [String : String]
                        }
                        if array[4] != nil {
                            var sectors = array[4]
                            self.candidates[indexPath.row].sectors = sectors as! [String : String]
                        }
                    }
                  } else {
                    print("not an array")
                  }
                } catch {
                  print(error.localizedDescription)
                }
              semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
        else if self.candidates[indexPath.row].isIncumbent == false {
            print("Isn't incumbent")
        }
        var imageUrl = self.candidates[indexPath.row].imageUrl
        SDWebImageManager.shared.loadImage(
                with: imageUrl,
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
                            vc.candidate = self.candidates[indexPath.row]
                            vc.candidates = self.candidates
                            vc.homescreendata = self.homescreendata
                            vc.electionNameData = self.electionNameData
                            for indexPath in tableView.indexPathsForSelectedRows ?? [] {
                                self.candidateTable.deselectRow(at: indexPath, animated: true)
                            }
                            self.present(vc, animated: true)
                        }
                }
        }
    }
}

enum CandidateDatasetElement: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(CandidateDatasetElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CandidateDatasetElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

typealias CandidateDataset = [String: [CandidateDatasetElement]]

extension ElectionScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = candidateTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if candidates[indexPath.row].isIncumbent == false {
            cell.textLabel?.text = candidates[indexPath.row].name
            return cell
        }
        else {
            cell.textLabel?.text = candidates[indexPath.row].name + " - Incumbent"
            return cell
        }
    }
}

class ElectionScreen: UIViewController {
    var candidates = [BallotpediaElection.Candidate]()
    var homescreendata = [BallotpediaElection]()
    var electionNameData = ""
    var openSecretsData = [OpenSecretsModel]()
    var level = ""
    var allCandidates = [BallotpediaElection.Candidate]()
    
    @IBOutlet var electionName: UILabel!
    @IBOutlet var candidateTable: UITableView!
    @IBOutlet weak var electionDescription: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as? HomeScreen {
                vc.homescreendata = self.homescreendata
                vc.allCandidates = self.allCandidates
                self.present(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
        var existingIndex = UserDefaults.standard.integer(forKey: "index")
        existingIndex = existingIndex + 1
        UserDefaults.standard.set(existingIndex, forKey: "index")
        if self.electionNameData != nil {
            self.electionName.text = self.electionNameData
        }
        else {
            print("Error")
            self.electionName.text = "Election"
        }
        candidateTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        candidateTable.dataSource = self
        candidateTable.delegate = self
    }

    // Reverse geocode to get user's address
     func getAddressFromLocation() async -> String? {
        if UserDefaults.standard.string(forKey: "latitude") != nil && UserDefaults.standard.string(forKey: "longitude") != nil {
            let latitude = UserDefaults.standard.string(forKey: "latitude")
            let longitude = UserDefaults.standard.string(forKey: "longitude")
            let location = CLLocation(latitude: CLLocationDegrees(Double(latitude!)!), longitude: CLLocationDegrees(Double(longitude!)!))
            let geoCoder = CLGeocoder()
            guard let placemark = try? await geoCoder.reverseGeocodeLocation(location).first,
                  let streetAddy = placemark.name,
                  let city = placemark.locality,
                  let state = placemark.administrativeArea
            else {
                return nil
            }

            return "\(streetAddy) \(city) \(state)"

        }
         return nil
    }
}
