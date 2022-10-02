//
//  CandidateScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit
import SDWebImage

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
    
    //Defines variables passed to it from other view controllers
    var candidate: BallotpediaElection.Candidate?
    var candidates = [BallotpediaElection.Candidate]()
    var homescreendata = [BallotpediaElection]()
    
    //Presents ElectionScreen when back button is pressed and passes homescreendata along with it
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ElectionScreen") as? ElectionScreen {
                vc.candidates = self.candidates
                vc.homescreendata = self.homescreendata
                self.present(vc, animated: true)
            }
       }
    }
    
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
                candidateParty.backgroundColor = UIColor.yellow
                candidateParty.setTitle("Libertarian", for: .normal)
                //make better color
            case "Green Party":
                print("Green")
                candidateParty.backgroundColor = UIColor.green
                candidateParty.setTitle("Green Party", for: .normal)
                //make better color
            case "Nonpartisan":
                print("Nonpartisan")
                candidateParty.backgroundColor = UIColor.gray
                candidateParty.setTitle("Nonpartisan", for: .normal)
            default:
                print("Other")
                candidateParty.backgroundColor = UIColor.gray
                candidateParty.setTitle(party, for: .normal)
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
//        if candidate.about != nil {
//            print(candidate.about)
//            self.candidateDescription.text = candidate.about
//        }
//        else {
//            print("Error")
//        }
//        
//        //Sets occupation
//        if candidate.occupation != nil {
//            print(candidate.occupation)
//            self.candidateOccupation.text = candidate.occupation
//        }
//        else {
//            print("Error")
//            self.candidateOccupation.text = "Mayor"
//        }
        
        //Sets image to the candidate's image and caches the image for later use
        candidateImage.sd_setImage(with: candidate.imageUrl)
    }
    
    //Displays the candidate's social media page
    @IBAction func twitterButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CandidateTwitterScreen")
            self.present(vc, animated: true)
        }
    }
    
    //Displays the candidate's website
    @IBAction func websiteButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CandidateWebsiteScreen")
            self.present(vc, animated: true)
        }
    }
}
