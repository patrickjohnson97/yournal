//
//  Emotions.swift
//  yournal
//
//  Created by Patrick Johnson on 4/4/21.
//

import Foundation

enum Emotions: CaseIterable{
    case happy
    case mediumHappy
    case average
    case mediumSad
    case sad
    
//    func getEmotion(emotion: String) -> Emotions{
//        switch emotion{
//        case "happy": return .happy
//        case "sad": return .sad
//        case "medium-happy": return .mediumHappy
//        case "medium-sad": return .mediumSad
//        case "average": return .average
//        default: return .average
//        }
//    }
    
    func getString() -> String{
        switch self{
        case .happy: return "happy"
        case .sad: return "sad"
        case .mediumHappy: return "mediumHappy"
        case .mediumSad: return "mediumSad"
        case .average: return "average"
        }
    }
}
