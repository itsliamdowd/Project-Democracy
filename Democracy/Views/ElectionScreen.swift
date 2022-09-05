//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

extension ElectionScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button")
        //removes party from candidate name
        print(data[indexPath.row])
        var dataSplit = data[indexPath.row].split(separator: " ")
        var dataTwo = ""
        var i = 0
        for dataOne in dataSplit {
            i = i+1
            if i == dataSplit.count {
                print("pass")
            }
            else if i == 1 {
                dataTwo = String(dataOne)
                print("pass")
            }
            else if i != dataSplit.count &&  i != 1 {
                dataTwo = dataTwo + " " + dataOne
                print("else if")
            }
            else {
                dataTwo = dataTwo + " " + dataOne
                print("else")
            }
        }
            
        UserDefaults.standard.set(dataTwo, forKey: "candidateName")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen")
            self.present(vc, animated: true)
        }
    }
}

extension ElectionScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = candidateTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

class ElectionScreen: UIViewController {
    
    var data = ["Donald Trump (R)", "Joe Biden (D)", "Loading (O)", "Loading (O)", "Loading (O)"]
    
    @IBOutlet var electionName: UILabel!
    @IBOutlet var candidateTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
        if UserDefaults.standard.string(forKey: "electionName") != nil {
            self.electionName.text = UserDefaults.standard.string(forKey: "electionName")
        }
        else {
            print("Error")
        }
        candidateTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        candidateTable.dataSource = self
        candidateTable.delegate = self
    }

}
