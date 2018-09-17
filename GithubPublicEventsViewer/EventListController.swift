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
    var fetchCount = 0
    
    private var url: URL {
       return URL(string: "https://api.github.com/events")!
    }
    
    var numberOfFetchdEvents: Int {
        return fetchedEvents.count
    }
    
    func fetch(index: Int) -> Event? {
        return fetchedEvents[index]
    }
    
    func fetch(page: UInt = 0, completion: (([Event]) -> Void)?) {
        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        component?.query = "page=\(page)"
        
        URLSession.shared.dataTask(
        with: component!.url!) { [weak self] (data_, response_, error_) in
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
                self?.fetchedEvents.append(contentsOf: events)
                completion?(self?.fetchedEvents ?? [])
                return
            } catch {
                
                completion?([])
                return
            }
        }.resume()
    }
}
