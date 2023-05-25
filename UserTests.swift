//
//  UserTests.swift
//  RecessTestGroundsTests
//
//  Created by Torri Ray Porter Jr on 2023-05-25.
//

import XCTest

final class UserTests: XCTestCase {
    
    var user: User!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        user = User(name: "Test User", email: "test@email.com", avatar: "pic1")
    }
    
    override func tearDownWithError() throws {
        user = nil
        try super.tearDownWithError()
    }
    
    func testAddRating() {
        user.addRating(1)
        XCTAssertEqual(user.numRatings, 1)
        XCTAssertEqual(user.positiveRatingCount, 1)
    }
    
    func testUpdateRating() {
        let updatedRating = user.updateRating(1)
        XCTAssertEqual(user.rating, "100.0")
        XCTAssertEqual(updatedRating, "100.0")
    }
    
    func testAddPoints() {
        user.addPoints(200)
        XCTAssertEqual(user.points, 200)
        XCTAssertEqual(user.tier, 4)
    }
    
    func testEquality() {
        var anotherUser = User(name: "Test", email: "test@example.com", avatar: "TestAvatar")
        anotherUser.id = user.id
        XCTAssertEqual(user, anotherUser)
    }
    
    func testFollowingAndFollowers() {
        user.followers.append("user1")
        user.following.append("user2")
        XCTAssertEqual(user.followers.count, 1)
        XCTAssertEqual(user.following.count, 1)
    }
}
