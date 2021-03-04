//
//  PlayerViewMode.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 3.03.2021.
//

import Foundation

class PlayerViewModel {
    
    private let hlsVideoUrlString = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"

    var hlsVideoUrl: URL?{
        get{
            guard let url = URL(string: hlsVideoUrlString) else { return nil}
            return url
        }
    }
    
}
