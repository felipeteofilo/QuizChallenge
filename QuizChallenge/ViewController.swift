//
//  ViewController.swift
//  QuizChallenge
//
//  Created by Felipe Teofilo on 23/11/19.
//  Copyright © 2019 Felipe Teofilo. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: - View Objects
    
    //Views of screen
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var textFieldIInsert: UITextField!
    @IBOutlet var tableViewWords: UITableView!
    @IBOutlet var lblScore: UILabel!
    @IBOutlet var lblTimeLeft: UILabel!
    @IBOutlet var btnStartReset: UIButton!
    
    //MARK: - Class Objects
    
    //Timer objects
    var timerGame: Timer!
    var iGameTime: Int = 0
    let iInitialGameTime: Int = 300
    
    //Score objects
    var iScorePoints: Int = 0
    var iTotalPoints: Int = 0
    
    //Names of button
    let sResetName = "Reset"
    let sStartName = "Start"
    
    //MARK: - ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //start the initial texts of screen
        lblTimeLeft.text = secondsToText(iInitialGameTime)
        lblScore.text = "0/50"
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
        lblTimeLeft.text = secondsToText(iGameTime)
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
        lblTimeLeft.text = secondsToText(iGameTime)
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
        lblTimeLeft.text = secondsToText(iGameTime)
    }
    
    //MARK: - Util Methods
    
    /**
     Convert  the seconds to  text
     - Parameter seconds: Seconds to convert
     - Returns : Seconds converted to text
     */
    private func secondsToText(_ seconds: Int) -> String
    {
        //get the minutes and seconds of game
        let iMinutes = (seconds / 60) % 60
        let iSeconds = seconds % 60
        
        //init the string to return
        let sSecondsTextToReturn = String.init(format: "%0.2d:%0.2d", iMinutes, iSeconds)
        
        //return the seconds text
        return sSecondsTextToReturn
        
    }
    
    //MARK: - Game Methods
    
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
}

