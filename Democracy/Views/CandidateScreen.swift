//
//  CandidateScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

class CandidateScreen: UIViewController {
    
    //set photo of candidate to one recieved from api call earlier
    
    //var swipeindex = 0
    
    @IBOutlet var candidateName: UILabel!
    @IBOutlet var candidateParty: UIButton!
    @IBOutlet var candidateOccupation: UILabel!
    @IBOutlet var candidateImage: UIImageView!
    @IBOutlet var swipeScreen: UIView!
    @IBOutlet var textScreen: UIView!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var screenText: UITextView!
    @IBOutlet var incumbent: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to candidate screen")
        candidateParty.layer.cornerRadius = 15
        incumbent.layer.cornerRadius = 15
        swipeScreen.layer.cornerRadius = 15

        //Sets party
        var party = "Democratic Party"
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
        
        //Sets incumbent
        var incumbent = "true"
        switch incumbent {
            case "true":
                print("Incumbent")
                self.incumbent.isHidden = false
            case "false":
                print("Not incumbent")
                self.incumbent.isHidden = true
            default:
                print("Other")
                self.incumbent.isHidden = true
        }
        
        //Sets name
        if UserDefaults.standard.string(forKey: "candidateName") != nil {
            print(UserDefaults.standard.string(forKey: "candidateName"))
            self.candidateName.text = UserDefaults.standard.string(forKey: "candidateName")
        }
        else {
            print("Error")
        }
        
        //Sets occupation
        if UserDefaults.standard.string(forKey: "candidateOccupation") != nil {
            print(UserDefaults.standard.string(forKey: "candidateOccupation"))
            self.candidateOccupation.text = UserDefaults.standard.string(forKey: "candidateOccupation")
        }
        else {
            print("Error")
            self.candidateOccupation.text = "Mayor"
        }
        
        //Sets image to image from url
        if let url = URL(string: "") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async {
                    self.candidateImage.contentMode = .center
                    self.candidateImage.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipe)
        let swipeTwo = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeTwo.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeTwo)
    }

    @IBAction func twitterButtonPressed(_ sender: Any) {
        //UserDefaults.standard.set("@", forKey: "candidateSocial")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CandidateTwitterScreen")
            self.present(vc, animated: true)
        }
    }
    
    
    @IBAction func websiteButtonPressed(_ sender: Any) {
        //UserDefaults.standard.set("https://", forKey: "candidateWebsite")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CandidateWebsiteScreen")
            self.present(vc, animated: true)
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                //if swipeindex != candidatesData.count {
                  //  swipeindex = swipeindex + 1
                    //print("Insert reset to highest number in list if swiped right")
              //  else if swipeindex == candidatesData.count {
               //     swipeindex = 0
               // }
               // else {
               //     swipeindex = swipeindex + 1
               // }
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                //if swipeindex == 0 {
                    //swipeindex = candidatesData.count
                 //   print("Insert reset to highest number in list if swiped right")
                //else if swipeindex != 0 {
                //    swipeindex = swipeindex - 1
               // }
                //else {
                //    swipeindex = swipeindex - 1
               // }
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }

}
