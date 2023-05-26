//
//  FIrestoreService.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

protocol FirestoreServiceProtocol {
    //helper functions
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func makeActivityActive(activity: Activity)
    //update functions
    func updateUser(data: User.Data, chosenAvatar: String, id: String)
    func updateActivity(data: Activity.Data, id: String)
    func updatePoints(user: User, points: Int)
    func updateTier(user: User, tier: Int)
    func updateRating(user: User, rating: String)
    func updateReviewCounts(user: User, review: Int)
    //deletion functions
    func deleteActivity(activity: Activity)
    func removePlayer(activity: Activity, user: User)
    //creation functions
    func createUser(user: User, avatar: String)
    func createActivityForLater(activity: Activity)
    func createActivityNow(activity: Activity, coordinates: [CLLocationDegrees])
    func addPlayer(activity: Activity, user: User)
}

class FirestoreService: FirestoreServiceProtocol {
    
    static let shared = FirestoreService()
    let userRef = Firestore.firestore().collection("Users")
    let activityRef = Firestore.firestore().collection("Activities")
    
    func updateActivity(data: Activity.Data, id: String) {
        activityRef.document(id).updateData([
            "title" : data.title,
            "sport" : data.sport,
            "date" : data.date,
            "description" : data.description,
            "coordinates" : data.coordinates,
        ])
    }
    
    func updateUser(data: User.Data, chosenAvatar: String, id: String) {
        userRef.document(id).updateData([
            "name" : data.name,
            "profilePicString" : chosenAvatar,
        ])
    }
    
    func makeActivityActive(activity: Activity) {
        activityRef.document(activity.id).updateData([
            "currentlyActive" : true
        ])
    }
    
    func addPlayer(activity: Activity, user: User) {
        activityRef.document(activity.id).updateData([
            "players" : FieldValue.arrayUnion([user.id]),
            "playerCount" : FieldValue.increment(Int64(1))
        ])
    }
    
    func removePlayer(activity: Activity, user: User) {
        activityRef.document(activity.id).updateData([
            "players" : FieldValue.arrayRemove([user.id]),
            "playerCount" : FieldValue.increment(Int64(-1))
        ])
    }
    
    func createActivityNow(activity: Activity, coordinates: [CLLocationDegrees]) {
        Firestore.firestore().collection("Activities").document(activity.id).setData([
            "id" : activity.id,
            "title" : activity.title,
            "points" : 50,
            "sport" : activity.sport,
            "playerCount" : 1,
            "date" : Date.now,
            "description" : activity.description,
            "creator" : activity.creator,
            "players" : [activity.creator],
            "coordinates" : coordinates,
            "currentlyActive" : true
        ])
    }
    
    func createActivityForLater(activity: Activity) {
        Firestore.firestore().collection("Activities").document(activity.id).setData([
            "id" : activity.id,
            "title" : activity.title,
            "points" : 50,
            "sport" : activity.sport,
            "playerCount" : 1,
            "date" : activity.date,
            "description" : activity.description,
            "creator" : activity.creator,
            "players" : [activity.creator],
            "coordinates" : activity.coordinates,
            "currentlyActive" : false
        ])
    }
    
    func createUser(user: User, avatar: String) {
        userRef.document(user.id).setData([
            "id" : user.id,
            "name" : user.name,
            "tier" : user.tier,
            "positiveRatingCount" : user.positiveRatingCount,
            "clubs" : user.clubs,
            "followers" : user.followers,
            "achievements" : user.achievements,
            "points" : user.points,
            "profilePicString" : avatar,
            "following" : user.following,
            "numRatings" : user.numRatings,
            "rating" : user.rating,
            "emailAddress" : user.emailAddress
        ])
    }
    
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        userRef.document(id).getDocument() { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updatePoints(user: User, points: Int) {
        userRef.document(user.id).updateData(["points" : FieldValue.increment(Int64(points))])
    }
    
    func updateTier(user: User, tier: Int) {
        userRef.document(user.id).updateData(["tier" : tier])
    }
    
    func updateRating(user: User, rating: String) {
        userRef.document(user.id).updateData(["rating" : rating])
    }
    
    func updateReviewCounts(user: User, review: Int) {
        if review == 1 {
            userRef.document(user.id).updateData([
                "numRatings" : FieldValue.increment(Int64(1)),
                "positiveRatingCount" : FieldValue.increment(Int64(1)),
            ])
        } else if review == 0 {
            userRef.document(user.id).updateData([
                "numRatings" : FieldValue.increment(Int64(1)),
            ])
        }
    }
    
    func deleteActivity(activity: Activity) {
        Firestore.firestore().collection("Activities").document(activity.id).delete() { error in
            if let error = error {
                print("Error deleting document: \(error)")
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            self.userRef.whereField("emailAddress", isEqualTo: email).getDocuments() { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                for document in documentSnapshot!.documents {
                    do {
                        let user = try document.data(as: User.self)
                        completion(.success(user))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
