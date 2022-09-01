//
//  CanidateScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

class CanidateScreen: UIViewController {
    
    //set photo of canidate to one recieved from api call earlier
    
    var swipeindex = 0
    
    @IBOutlet var canidateName: UILabel!
    @IBOutlet var canidateParty: UIButton!
    @IBOutlet var canidateOccupation: UILabel!
    @IBOutlet var canidateImage: UIImageView!
    @IBOutlet var swipeScreen: UIView!
    @IBOutlet var textScreen: UIView!
    @IBOutlet var nextView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var screenTitle: UILabel!
    @IBOutlet var screenText: UITextView!
    @IBOutlet var incumbent: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to canidate screen")
        canidateParty.layer.cornerRadius = 15
        incumbent.layer.cornerRadius = 15
        swipeScreen.layer.cornerRadius = 15
        nextView.layer.cornerRadius = 15
        backView.layer.cornerRadius = 15
        
        //Sets party
        var party = "Nonpartisan"
        switch party {
            case "Republican Party":
                print("Republican")
                canidateParty.backgroundColor = UIColor.red
                canidateParty.setTitle("Republican", for: .normal)
            case "Democratic Party":
                print("Democrat")
                canidateParty.backgroundColor = UIColor.blue
                canidateParty.setTitle("Democrat", for: .normal)
            case "Libertarian Party":
                print("Libertarian")
                canidateParty.backgroundColor = UIColor.yellow
                canidateParty.setTitle("Libertarian", for: .normal)
            case "Green Party":
                print("Green")
                canidateParty.backgroundColor = UIColor.green
                canidateParty.setTitle("Green Party", for: .normal)
            case "Nonpartisan":
                print("Nonpartisan")
                canidateParty.backgroundColor = UIColor.gray
                canidateParty.setTitle("Nonpartisan", for: .normal)
            default:
                print("Other")
                canidateParty.backgroundColor = UIColor.gray
                canidateParty.setTitle(party, for: .normal)
        }
        
        //Sets incumbent
        var incumbent = "false"
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
        if UserDefaults.standard.string(forKey: "canidateName") != nil {
            print(self.canidateName.text)
            print(UserDefaults.standard.string(forKey: "canidateName"))
            self.canidateName.text = UserDefaults.standard.string(forKey: "canidateName")
        }
        else {
            print("Error")
        }
        
        //Sets occupation
        if UserDefaults.standard.string(forKey: "canidateOccupation") != nil {
            print(self.canidateName.text)
            print(UserDefaults.standard.string(forKey: "canidateOccupation"))
            self.canidateOccupation.text = UserDefaults.standard.string(forKey: "canidateOccupation")
        }
        else {
            print("Error")
            self.canidateOccupation.text = "Mayor"
        }
        
        //Sets image to image from url
        if let url = URL(string: "") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async {
                    self.canidateImage.contentMode = .center
                    self.canidateImage.image = UIImage(data: data)
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

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                //if swipeindex != canidatesData.count {
                  //  swipeindex = swipeindex + 1
                    //print("Insert reset to highest number in list if swiped right")
              //  else if swipeindex == canidatesData.count {
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
                    //swipeindex = canidatesData.count
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
