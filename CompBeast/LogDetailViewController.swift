//
//  LogDetailViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/13/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse

class LogDetailViewController: UIViewController {

    //@IBOutlet var trainingNotes: UILabel!
    var notes: String!
    var roundsString: String!
    var minutesString: String!

    @IBOutlet var trainingNotes: UILabel!
    @IBOutlet var rounds: UILabel!
    @IBOutlet var minutes: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        
        self.trainingNotes.numberOfLines = 0
        self.trainingNotes.sizeToFit()
        
        let notesLabelText = "Training Notes: \n" + self.notes
        
        self.trainingNotes.text = notesLabelText
        
        self.rounds.text = "Rounds: " + self.roundsString
        self.minutes.text = "Minutes: " + self.minutesString
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
