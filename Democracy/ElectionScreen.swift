//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

extension ElectionScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button...")
        print(data[indexPath.row])
        UserDefaults.standard.set(data[indexPath.row], forKey: "canidateName")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CanidateScreen")
            self.present(vc, animated: true)
        }
    }
}

extension ElectionScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = canidateTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}


class ElectionScreen: UIViewController {
    
    var data = ["Donald Trump (R)", "Joe Biden (D)", "Loading... (O)", "Loading... (O)", "Loading... (O)"]
    
    @IBOutlet var electionName: UILabel!
    @IBOutlet var canidateTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
        if UserDefaults.standard.string(forKey: "electionName") != nil {
            self.electionName.text = UserDefaults.standard.string(forKey: "electionName")
        }
        else {
            print("Error")
        }
        canidateTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        canidateTable.dataSource = self
        canidateTable.delegate = self
    }

}
