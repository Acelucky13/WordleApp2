//
//  WordGenerator.swift
//  Wordle
//
//  Created by Mari Batilando on 2/20/23.
//

import Foundation

enum WordTheme: String {
  case normal, animals, countries
  
  func possibleWords(numLetters: Int) -> [String] {
    switch self {
    case .normal:
      return normalWords(with: numLetters)
    case .animals:
      return animalWords(with: numLetters)
    case .countries:
      return countryWords(with: numLetters)
    }
  }
  
  func normalWords(with numLetters: Int) -> [String] {
    if numLetters == kMinLetters {
      return ["SEED", "GOAT", "LOAD"]
    } else if numLetters == kMinLetters + 1 {
      return ["GRAPE", "SMART", "PIZZA"]
    } else if numLetters == kMinLetters + 2 {
      return ["PENCIL", "COFFEE", "ROCKET"]
    } else if numLetters == kMaxLetters {
      return ["BICYCLE", "WEEKEND", "LIBRARY"]
    }
    return []
  }
  
  func animalWords(with numLetters: Int) -> [String] {
    if numLetters == kMinLetters {
      return ["SEAL", "DEER", "FROG"]
    } else if numLetters == kMinLetters + 1 {
      return ["HORSE", "PANDA", "ZEBRA"]
    } else if numLetters == kMinLetters + 2 {
      return ["JAGUAR", "PELICAN", "DOLPHIN"]
    } else if numLetters == kMaxLetters {
      return ["ELEPHANT", "GIRAFFE", "PLATYPUS"]
    }
    return []
  }
  
  func countryWords(with numLetters: Int) -> [String] {
    if numLetters == kMinLetters {
      return ["PERU", "CUBA", "MALI"]
    } else if numLetters == kMinLetters + 1 {
      return ["INDIA", "CHILE", "QATAR"]
    } else if numLetters == kMinLetters + 2 {
      return ["BELIZE", "BRAZIL", "GREECE"]
    } else if numLetters == kMaxLetters {
      return ["AMERICA", "GERMANY", "JAMAICA"]
    }
    return []
  }
}

class WordGenerator {
  static func generateGoalWord(with theme: WordTheme) -> [String] {
    let numLetters = SettingsManager.shared.settingsDictionary[kNumLettersKey] as! Int
    let randomWord = theme.possibleWords(numLetters: numLetters).randomElement()!
    return randomWord.map { String($0) }
  }
}

