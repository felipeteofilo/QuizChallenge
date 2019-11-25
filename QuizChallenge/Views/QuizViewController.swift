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
    @IBOutlet var constraintButtonStartReset: NSLayoutConstraint!
    
    //MARK: - Class Objects
    
    //Timer objects
    var timerGame: Timer!
    var iGameTime: Int = 0
    
    //Time in seconds
    let iInitialGameTime: Int = 300
    
    //Score objects
    var iScorePoints: Int = 0
    var iTotalPoints: Int = 50
    
    //TableView objects
    var arrAnswers: [String] = []
    var arrRightAnswers: [String] = []
    
    //Comunnication objects
    let iTimeOut = 60
    let urlCommunicationAnswers = URL.init(string: "https://codechallenge.arctouch.com/quiz/1")
    
    //Names of button
    let sResetName = "Reset"
    let sStartName = "Start"
    
    //MARK: - ViewController Methods
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        //starts the download of answers
        downloadAnswers()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //add observes of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //remove the observes of keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //init a view that would be used like a padding to text field
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 8, height: textFieldIInsert.frame.height))
        
        //insert the padding view on the left of textfield
        textFieldIInsert.leftView = paddingView
        textFieldIInsert.leftViewMode = .always
        
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
     On passed 1 sec of game time
     */
    @objc private func onTimerChange ()
    {
        //change the the control variable of time
        iGameTime -= 1;
        
        //case the game time was exceeded
        if(iGameTime <= 0)
        {
            //show the message of game over
            gameOver()
        }
        
        //set the text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
    }
    
    //MARK: - Game Methods
    
    /**
     Verify if a game is running
     - Returns: a boolean if the game is running
     */
    private func isGameRunning () -> Bool
    {
        //init the return with false
        var bReturn = false
        
        //if the timer is running
        if(timerGame != nil && timerGame.isValid)
        {
            //set the return to true
            bReturn = true
        }
        
        return bReturn
    }
    
    /**
     Score a point to player
     */
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
        
        //init the game with the time defined by 5 minutes
        iGameTime = iInitialGameTime;
        
        //set the initial text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
        
        //start the timer of the game
        startTimer()
        
        //set focus on textfield
        textFieldIInsert.becomeFirstResponder()
    }
    
    /**
     Reset the game
     */
    private func resetGame ()
    {
        //change the button name to start
        btnStartReset.setTitle(sStartName, for: .normal)
        
        //reset answers
        arrRightAnswers = []
        
        //reset the points
        iScorePoints = 0
        
        //set the text of score
        lblScore.text = Util.pointsToText(totalPoints: iTotalPoints, currentPoints: iScorePoints)
        
        //update the table
        tableViewWords.reloadData()
        
        //removes the focus of textfield
        textFieldIInsert.endEditing(true)
        
        //clear the textfield
        textFieldIInsert.text = ""
        
        //reset the time
        iGameTime = iInitialGameTime;
        
        //set the initial text of time left
        lblTimeLeft.text = Util.secondsToText(seconds: iGameTime)
        
        //stop the timer of the game
        stopTimer()
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
        
        //remove focus on textfield
        textFieldIInsert.endEditing(true)
        
        //stop the timer
        stopTimer()
        
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
        let sGameOverMessage = "Good job! You found all the answers on time. Keep up with the great work."
        
        //init the alert
        let alertGameWin = UIAlertController.init(title: "Congratulations", message: sGameOverMessage, preferredStyle: .alert)
        
        //init the action button
        let actionGameWin = UIAlertAction.init(title: "Play Again", style: .default)
        { actionAux in
            
            //resets the game
            self.resetGame()
        }
        
        //remove focus on textfield
        textFieldIInsert.endEditing(true)
        
        //stop the timer
        stopTimer()
        
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
     When the player click on textfield
     */
    @IBAction func beginEditing(_ textField: UITextField)
    {
        //verify if the game is running
        if(!isGameRunning())
        {
            //case the game is not running show the message of warning
            //init the alert
            let alertGameNotRunning = UIAlertController.init(title: "Attention", message: "Start the game first to write the answers!", preferredStyle: .alert)
            
            //init the action button
            let actionGameNotRunning = UIAlertAction.init(title: "OK", style: .default)
            
            //set the action button of this alert
            alertGameNotRunning.addAction(actionGameNotRunning)
            
            //stops the editing
            textField.endEditing(true)
            
            //show the alert
            show(alertGameNotRunning, sender: nil)
        }
    }
    
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
    
    //MARK: - Keyboard Methods
    
    /**
     Handle when keyboard show or hiden
     */
    @objc func handleKeyboardNotification(_ notification: Notification)
    {
        //see if notification has atributes
        if let userInfo = notification.userInfo
        {
            //get the size of keyboard
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            
            //get if the keyboard is showing or not
            let isKeybordShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            //change the position of the Scoreview
            constraintScoreView.constant = isKeybordShowing ? keyboardFrame.height : 0
            
            //change the position of the Button
            constraintButtonStartReset.constant = isKeybordShowing ? constraintButtonStartReset.constant + keyboardFrame.height : 16
            
            //make the animation be more fruid
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations:{
                
                //update screen
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    //MARK: - Communication Methods
    
    /**
     Download the question and the answer from server
     */
    private func downloadAnswers()
    {
        //init the configuration of session
        let sessionConfiguration = URLSessionConfiguration.default
        
        //set the time out
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(iTimeOut)
        
        //init the session
        let sessionDownload = URLSession.init(configuration: sessionConfiguration)
        
        //show the loading
        Util.showLoading(view: view)
        
        //hide all the views that does not need to show
        lblTitle.isHidden = true
        textFieldIInsert.isHidden = true
        tableViewWords.isHidden = true
        
        //start the communication
        let dataTask = sessionDownload.dataTask(with: urlCommunicationAnswers!) { (dataResponse, urlResponse, errorCommunication) in
            
            do
            {
                //stop the loading on the main thread
                DispatchQueue.main.sync {
                    Util.hideLoading(view: self.view)
                }
                
                try Util.handleErrorCommunication(errorCommunication: errorCommunication, urlResponse: urlResponse)
                
                //case the data was returned
                if(dataResponse != nil)
                {
                    //get the dictionary of quiz
                    let quizDictionary = try JSONSerialization.jsonObject(with: dataResponse!, options: .allowFragments) as! [String: Any]
                    
                    //get the model of quiz
                    let quizModelAux = QuizModel.init(json: quizDictionary)
                    
                    //call the completion of the communication on the main thread
                    DispatchQueue.main.sync {
                        self.communicationAnswerCompleted(quizModel: quizModelAux)
                    }
                }
            }
            catch let error
            {
                //show the error of the communication on the main thread
                DispatchQueue.main.sync { self.showAlertErrorCommunication(error: error)
                }
            }
        }
        
        //start the communication
        dataTask.resume()
    }
    
    /**
     Called when the communication suceeds
     */
    private func communicationAnswerCompleted(quizModel: QuizModel)
    {
        //show all the views that was hidden
        self.lblTitle.isHidden = false
        self.textFieldIInsert.isHidden = false
        self.tableViewWords.isHidden = false
        
        //set the question
        self.lblTitle.text = quizModel.question
        
        //set the answers
        self.arrAnswers = quizModel.answer
        
        //set the total points
        self.iTotalPoints = self.arrAnswers.count
        
        //set
        self.lblScore.text = Util.pointsToText(totalPoints: self.iTotalPoints, currentPoints: self.iScorePoints)
    }
    
    /**
     Show a laert of the error of the communication
     */
    private func showAlertErrorCommunication(error: Error)
    {
        //case the game is not running show the message of warning
        //init the alert
        let alertErrorCommunication = UIAlertController.init(title: "Attention", message: error.localizedDescription, preferredStyle: .alert)
        
        //init the action button
        let actionRetryCommunication = UIAlertAction.init(title: "Retry", style: .default, handler: { actionAux in
            
            //calls this fuction again to retry the download
            self.downloadAnswers()
        })
        
        //set the action button of this alert
        alertErrorCommunication.addAction(actionRetryCommunication)
        
        //show the alert
        self.show(alertErrorCommunication, sender: nil)
    }
}

