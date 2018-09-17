//
//  Event.swift
//  GithubPublicEventsViewer
//
//  Created by hf on 2018/09/16.
//  Copyright © 2018年 swift-studying.com. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: String
    let type: String
    let actor: Actor
    var eventDate: Date? {
        guard let dateString = created_at else { return nil }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return format.date(from: dateString)
    }
    
    private let created_at: String?
    
    struct Actor: Codable {
        let id: Int
        let login: String
        var displayName: String { return display_login }
        var gravatarId: String { return gravatar_id }
        let url: URL?
        var avatarUrl: URL? { return URL(string: avatar_url) }
        
        private let avatar_url: String
        private let display_login: String
        private let gravatar_id: String
    }
}
