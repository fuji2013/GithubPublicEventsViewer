//
//  EventListController.swift
//  GithubPublicEventsViewer
//
//  Created by hf on 2018/09/16.
//  Copyright © 2018年 swift-studying.com. All rights reserved.
//

import Foundation

class EventListController {
    private var fetchedEvents = [Event]()
    
    private var url: URL {
       return URL(string: "https://api.github.com/events")!
    }
    
    func fetch(completion: (([Event]) -> Void)?) {
        URLSession.shared.dataTask(
        with: url) { (data_, response_, error_) in
            guard let httpUrlResponse = response_ as? HTTPURLResponse else {
                completion?([])
                return
            }
            
            guard 200..<300 ~= httpUrlResponse.statusCode else {
                completion?([])
                return
            }
            
            guard let data = data_ else {
                completion?([])
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let events: [Event] = try decoder.decode([Event].self, from: data)
                completion?(events)
                return
            } catch {
                completion?([])
                return
            }
        }.resume()
    }
}
