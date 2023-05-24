//
//  ActivityTests.swift
//  RecessTestGroundsTests
//
//  Created by Torri Ray Porter Jr on 2023-05-24.
//
import XCTest

// Add your Activity struct here

class ActivityTests: XCTestCase {
    func testAddPlayer() {
        var activity = Activity(title: "Test activity", sport: "Basketball", date: Date(), coordinates: [0.0, 0.0], creator: "CreatorId")
        let user = User(name: "name", email: "email", avatar: "avatar")
        // Before adding the user, playerCount should be 1 (only creator)
        XCTAssertEqual(activity.playerCount, 1)
        // Add user
        activity.addPlayer(user)
        // After adding the user, playerCount should be 2
        XCTAssertEqual(activity.playerCount, 2)
        // User should be in the player list
        XCTAssertTrue(activity.players.contains(user.id))
    }
    
    func testRemovePlayer() {
        let user = User(name: "name", email: "email", avatar: "avatar")
        var activity = Activity(title: "Test activity", sport: "Basketball", date: Date(), coordinates: [0.0, 0.0], creator: "CreatorId")
        // Add user
        activity.addPlayer(user)
        XCTAssertEqual(activity.playerCount, 2)
        // Remove user
        activity.removePlayer(user)
        // After removing the user, playerCount should be 1
        XCTAssertEqual(activity.playerCount, 1)
        // User should not be in the player list
        XCTAssertFalse(activity.players.contains(user.id))
    }
    
    func testActivityInitialization() {
        let activity = Activity(title: "Test activity", sport: "Basketball", date: Date(), coordinates: [0.0, 0.0], creator: "CreatorId")

        XCTAssertEqual(activity.title, "Test activity")
        XCTAssertEqual(activity.sport, "Basketball")
        XCTAssertEqual(activity.creator, "CreatorId")
        XCTAssertEqual(activity.playerCount, 1)
        XCTAssertEqual(activity.players.first, "CreatorId")
        XCTAssertEqual(activity.currentlyActive, false)
        XCTAssertEqual(activity.points, 50)
    }
}

