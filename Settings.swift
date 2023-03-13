//
//  Settings.swift
//  FindNumber
//
//  Created by Pavel Serada on 3/4/23.
//

import Foundation

enum KeysUserDefaults{
    static let gameSettings = "gameSettings"
    static let gameRecord = "gameRecord"
}

struct GameSettings: Codable{
    var timerState: Bool
    var timeForGame: Int
}

class Settings{
    static var shared = Settings()
    
   private let defaultSettings = GameSettings(timerState: true, timeForGame: 30)
    
    var currentSettings: GameSettings {
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.gameSettings) as? Data{
                return try! PropertyListDecoder().decode(GameSettings.self, from: data)
            }
            else{
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.gameSettings)
                }
                return defaultSettings
            }
        }
        
        set{
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.gameSettings)
            }
        }
    }
    
    func resetSettings(){
        currentSettings = defaultSettings;
    }
    
}
