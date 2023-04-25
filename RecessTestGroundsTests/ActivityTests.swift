//
//  Activity.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-21.
//

import XCTest
import FirebaseFirestoreSwift

final class ActivityTests: XCTestCase {

    func testInit() {
            let sport = "Soccer"
            let maxPlayers = 10
            let date = Date()
            let description = "Friendly match"
            let coordinates = [37.7749, -122.4194]
            let creator = "userID"
            
            let activity = Activity(sport: sport, maxPlayers: maxPlayers, date: date, description: description, coordinates: coordinates, creator: creator)
            
            XCTAssertEqual(activity.sport, sport)
            XCTAssertEqual(activity.maxPlayers, maxPlayers)
            XCTAssertEqual(activity.date, date)
            XCTAssertEqual(activity.description, description)
            XCTAssertEqual(activity.coordinates, coordinates)
            XCTAssertEqual(activity.creator, creator)
            XCTAssertEqual(activity.playerCount, 1)
            XCTAssertFalse(activity.currentlyActive)
            XCTAssertEqual(activity.points, 50)
        }

        func testAddPlayer() {
            var activity = createSampleActivity()
            let user = User(name: "John Doe", email: "john@example.com", avatar: "avatar")
            
            activity.addPlayer(user)
            
            XCTAssertEqual(activity.playerCount, 2)
            XCTAssertTrue(activity.players.contains(user.id))
        }

        func testRemovePlayer() {
            var activity = createSampleActivity()
            let user = User(name: "Jane Doe", email: "jane@example.com", avatar: "avatar")
            
            activity.addPlayer(user)
            activity.removePlayer(user)
            
            XCTAssertEqual(activity.playerCount, 1)
            XCTAssertFalse(activity.players.contains(user.id))
        }
        
        private func createSampleActivity() -> Activity {
            return Activity(sport: "Soccer", maxPlayers: 10, date: Date(), description: "Friendly match", coordinates: [37.7749, -122.4194], creator: "userID")
        }

}
