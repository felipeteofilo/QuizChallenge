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
        let sPointsTextToReturn = String.init(format: "%0.2d:%0.2d", currentPoints, totalPoints)
        
        //return the seconds text
        return sPointsTextToReturn
        
    }
}
