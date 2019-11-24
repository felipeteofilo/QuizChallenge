//
//  QuizViewController.swift
//  QuizChallenge
//
//  Created by Felipe Teofilo on 23/11/19.
//  Copyright © 2019 Felipe Teofilo. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK: - View Objects
    
    //Views of screen
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var textFieldIInsert: UITextField!
    @IBOutlet var tableViewWords: UITableView!
    @IBOutlet var lblScore: UILabel!
    @IBOutlet var lblTimeLeft: UILabel!
    @IBOutlet var btnStartReset: UIButton!
    
    //Constraint from views
    @IBOutlet var constraintScoreView: NSLayoutConstraint!
    
    //MARK: - Class Objects
    
    //Timer objects
    var timerGame: Timer!
    var iGameTime: Int = 0
    let iInitialGameTime: Int = 300
    
    //Score objects
    var iScorePoints: Int = 0
    var iTotalPoints: Int = 0
    
    //TableView objects
    var arrAnswers: [String] = []
    var arrRightAnswers: [String] = []
    
    //Names of button
    let sResetName = "Reset"
    let sStartName = "Start"
    
    //MARK: - ViewController Methods
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrAnswers.append("int");
        arrAnswers.append("float");
        arrAnswers.append("double");
        
        iTotalPoints = arrAnswers.count
        
        //start the initial texts of screen
        lblTimeLeft.text = Util.secondsToText(seconds: iInitialGameTime)
        lblScore.text = Util.pointsToText(totalPoints: iTotalPoints, currentPoints: iScorePoints)
        btnStartReset.setTitle(sStartName, for: .normal)
    }
    
    //MARK: - Button Methods
    
    /**
     On click in the start or reset button
     */
    @IBAction func onClickStartReset(_ buttonStartReset: UIButton)
    {
        //case the button clicked is the reset
        if (buttonStartReset.title(for: .normal) == sResetName)
        {
            //reset the game
            resetGame()
        }
        else if (buttonStartReset.title(for: .normal) == sStartName)
        {
            //case the button clicked is the start
            //init the game
            initGame()
        }
    }
    
    //MARK: - Timer Methods
    
    /**
     Init the game time
     */
    private func startTimer ()
    {
        //create the timer that will be fired from 1 sec to 1 sec
        timerGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerChange), userInfo: nil, repeats: true)
        
        //init the game with the time defined by 5 minutes
        iGameTime = iInitialGameTime;
        
        //set the initial text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
    }
    
    /**
     Stop the game timer
     */
    private func stopTimer ()
    {
        //case the timer exists
        if(timerGame != nil)
        {
            //cancel the timer
            timerGame.invalidate();
            timerGame = nil;
        }
    }
    
    /**
     Resets the game timer
     */
    private func resetTimer ()
    {
        //cancel the timer
        stopTimer()
        
        //reset the time
        iGameTime = iInitialGameTime;
        
        //set the initial text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
    }
    
    /**
     On passed 1 sec of game time
     */
    @objc private func onTimerChange ()
    {
        //change the the control variable of time
        iGameTime -= 1;
        
        //case the game time was exceeded
        if(iGameTime <= 0)
        {
            //stop the timer
            stopTimer()
            
            //show the message of game over
            gameOver()
        }
        
        //set the text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
    }
    
    //MARK: - Game Methods
    
    private func scorePoint()
    {
        //adds the text on the array of right answers and clear the textfield
        arrRightAnswers.append(textFieldIInsert.text!)
        textFieldIInsert.text = ""
        
        //adds a point to the player
        iScorePoints += 1
        
        //set the text of points
        lblScore.text = Util.pointsToText(totalPoints: iTotalPoints, currentPoints: iScorePoints)
        
        //now we reload the tableview of right answers
        tableViewWords.reloadData()
        
        //verify if the game was over
        if(iScorePoints == iTotalPoints)
        {
            //show the message of game win
            gameWin()
        }
    }
    
    /**
     Init the game
     */
    private func initGame ()
    {
        //change the button name to reset
        btnStartReset.setTitle(sResetName, for: .normal)
        
        //start the timer of the game
        startTimer()
    }
    
    /**
     Reset the game
     */
    private func resetGame ()
    {
        //change the button name to start
        btnStartReset.setTitle(sStartName, for: .normal)
        
        //reset the timer of the game
        resetTimer()
    }
    
    /**
     Show the message of game over
     */
    private func gameOver ()
    {
        //init the message of game over
        let sGameOverMessage = "Sorry, time is up! You got \(iScorePoints) out of \(iTotalPoints) answers."
        
        //init the alert
        let alertGameOver = UIAlertController.init(title: "Time finished", message: sGameOverMessage, preferredStyle: .alert)
        
        //init the action button
        let actionGameOver = UIAlertAction.init(title: "Try Again", style: .default)
        { actionAux in
            
            //resets the game
            self.resetGame()
        }
        
        //set the action button of this alert
        alertGameOver.addAction(actionGameOver)
        
        //show the alert
        show(alertGameOver, sender: nil)
    }
    
    /**
     Show the message of game win
     */
    private func gameWin ()
    {
        //init the message of game win
        let sGameOverMessage = "Good job! You found all the answers on time.Keep up with the great work."
        
        //init the alert
        let alertGameWin = UIAlertController.init(title: "Congratulations", message: sGameOverMessage, preferredStyle: .alert)
        
        //init the action button
        let actionGameWin = UIAlertAction.init(title: "Play Again", style: .default)
        { actionAux in
            
            //resets the game
            self.resetGame()
        }
        
        //set the action button of this alert
        alertGameWin.addAction(actionGameWin)
        
        //show the alert
        show(alertGameWin, sender: nil)
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRightAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //init the indentifier of cell
        let sIdentifierCell = "CellAnswer"
        
        //get the right answer
        let sRightAnswer = arrRightAnswers[indexPath.row]
        
        //get the reusable cell
        var cellAux = tableView.dequeueReusableCell(withIdentifier: sIdentifierCell)
        
        //if the reusable cell is not instatiated
        if (cellAux == nil)
        {
            //case the cell was not reusable, create a new one
            cellAux = UITableViewCell.init(style: .default, reuseIdentifier: sIdentifierCell)
        }
        
        //set the right answer to show
        cellAux!.textLabel?.text = sRightAnswer
        
        return cellAux!
    }
    
    //MARK: - TextField Methods
    
    /**
    When the player click on retun of keyboard
    */
    @IBAction func onReturnClicked(_ textField: UITextField)
    {
        //case the return button was clicked, cancel the writing
        textField.endEditing(true);
    }
    
    /**
    When the text was changed
    */
    @IBAction func changedText(_ textField: UITextField)
    {
        //if the text changed is not alrealdy on the array of right answers
        if(!arrRightAnswers.contains(textField.text!))
        {
            //if the text changed is a right answer
            if(arrAnswers.contains(textField.text!))
            {
                //score a point to the player
                scorePoint()
            }
        }
    }
}

