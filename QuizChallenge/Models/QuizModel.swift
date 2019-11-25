//
//  QuizModel.swift
//  QuizChallenge
//
//  Created by Felipe Teofilo on 24/11/19.
//  Copyright © 2019 Felipe Teofilo. All rights reserved.
//

import Foundation

class QuizModel
{
    var question: String
    var answer: [String]
    
    init(json: [String: Any])
    {
        //set the objets
        question = json["question"] as! String
        answer = json["answer"] as! [String]
    }
}
