//
//  Util.swift
//  QuizChallenge
//
//  Created by Felipe Teofilo on 24/11/19.
//  Copyright © 2019 Felipe Teofilo. All rights reserved.
//

import UIKit

class Util
{
    //MARK: - Util Methods
    
    /**
     Convert  the seconds to  text
     - Parameter seconds: Seconds to convert
     - Returns : Seconds converted to text
     */
    class func secondsToText(seconds: Int) -> String
    {
        //get the minutes and seconds of game
        let iMinutes = (seconds / 60) % 60
        let iSeconds = seconds % 60
        
        //init the string to return
        let sSecondsTextToReturn = String.init(format: "%0.2d:%0.2d", iMinutes, iSeconds)
        
        //return the seconds text
        return sSecondsTextToReturn
        
    }
    
    /**
     Convert the points to text
     - Parameter totalPoints: Total points of game
     - Parameter currentPoints: The current points  of player
     - Returns : Points converted to text of game
     */
    class func pointsToText(totalPoints: Int, currentPoints: Int) -> String
    {
        //init the string to return
        let sPointsTextToReturn = String.init(format: "%0.2d/%0.2d", currentPoints, totalPoints)
        
        //return the seconds text
        return sPointsTextToReturn
    }
    
    /**
     Shows a loading screen
     - Parameter view: View to show the loading
     */
    class func showLoading(view: UIView)
    {
        //init the containr
        let container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //tag to search the loading on the hidden method
        container.tag = 1200

        //init the bacground loading view
        let loadingBackgroundView = UIView()
        loadingBackgroundView.frame = CGRect.init(x: 0, y: 0, width: 150, height: 150)
        loadingBackgroundView.center = view.center
        loadingBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingBackgroundView.clipsToBounds = true
        loadingBackgroundView.layer.cornerRadius = 10
        
        //init the title
        let lblTitleLoading = UILabel.init()
        lblTitleLoading.text = "Loading..."
        lblTitleLoading.font = .systemFont(ofSize: 17, weight: .bold)
        lblTitleLoading.sizeToFit()
        lblTitleLoading.textColor = .white
        lblTitleLoading.center = CGPoint.init(x: loadingBackgroundView.frame.size.width / 2, y: loadingBackgroundView.frame.size.height - (lblTitleLoading.center.y + 16))
        
        //init the loading
        let loadingView = UIActivityIndicatorView.init()
        loadingView.frame = CGRect.init(x: 0.0, y: 0.0, width: 70.0, height: 70.0);
        loadingView.style = .large
        loadingView.center = CGPoint.init(x: loadingBackgroundView.frame.size.width / 2,
                                          y: loadingBackgroundView.frame.size.height / 2);
        loadingView.color = .white
        
        //set the views on screen
        loadingBackgroundView.addSubview(loadingView)
        loadingBackgroundView.addSubview(lblTitleLoading)
        container.addSubview(loadingBackgroundView)
        view.addSubview(container)
        
        //set the appearence of indicator
        loadingView.largeContentTitle = "Loading..."
        
        //set to indicator hides when stoped
        loadingView.hidesWhenStopped = true
        
        //start the loading animation
        loadingView.startAnimating()
    }
    
    /**
     Hides a loading screen
     - Parameter view: View that the loading is showing
     */
    class func hideLoading(view: UIView)
    {
        //get the loading
        if let loadingView = view.viewWithTag(1200)
        {
            //stop the loading
            loadingView.removeFromSuperview()
        }
    }
    
    /**
     Handle errors from server
     - Parameter errorCommunication: Error from the communication
     - Parameter urlResponse: URLResponse from the communication
     */
    class func handleErrorCommunication(errorCommunication: Error?, urlResponse: URLResponse?) throws
    {
        //verify if a error was occurred on the communication
        guard errorCommunication == nil else
        {
            //throws the error to show to the user
            throw errorCommunication!
        }
        
        //get the http response of the communication
        let httpUrlResponse = urlResponse as? HTTPURLResponse
        
        //verify if an error was ocurred on the server
        if(httpUrlResponse?.statusCode != 200)
        {
            //throws the error to show to the user
            throw NSError.init(domain: "HTTPURLResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpUrlResponse!.statusCode)])
        }
    }
}
