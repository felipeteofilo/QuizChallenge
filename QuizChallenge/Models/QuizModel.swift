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
    
    init(json: [String: Any]) throws
    {
        //verify if the objects expected was received
        if let questionAux = json["question"] as? String
        {
            //set the objets
            question = questionAux
        }
        else
        {
            //throws the error
            throw NSError.init(domain: "ModelError", code: 0, userInfo: [NSLocalizedDescriptionKey: "The data received doesn't contains the \"question\" attribute"])
        }
        
        if let answerAux = json["answer"] as? [String]
        {
            //set the objets
            answer = answerAux
        }
        else
        {
            //throws the error
            throw NSError.init(domain: "ModelError", code: 0, userInfo: [NSLocalizedDescriptionKey: "The data received doesn't contains the \"answer\" attribute"])
        }
    }
}
