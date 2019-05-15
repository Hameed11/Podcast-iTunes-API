//
//  CMTime.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/13/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import AVKit

extension CMTime {
    
   /* func toDisplayString() -> String {
        
        //convert time from float to Int
        let totalSeconds = Int(CMTimeGetSeconds(self)) // self is CMTime itself
        print("Total seconds:", totalSeconds)
        
        let minutes = totalSeconds / 60
        
        //use % to get seconds value
        //"%02d" how we represent a 2 digit integer
        let seconds = totalSeconds % 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatString
    }*/
    
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
    
    
    
}

