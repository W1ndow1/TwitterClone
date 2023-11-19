//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetPath: String = "tweet"
    
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in return true }
            .eraseToAnyPublisher()
    }
    
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap { try $0.data(as: TwitterUser.self)}
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        db.collection(usersPath).document(id).updateData(updateFields)
            .map{ _ in true }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool, Error> {
        db.collection(tweetPath).document(tweet.id).setData(from: tweet)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retreiveTweets forUserID: String) -> AnyPublisher<Tweet, Error> {
        db.collection(tweetPath).whereField("author.id", isEqualTo: forUserID)
            .tryMap { try $0.data(as: Tweet.self)}
            .eraseToAnyPublisher()
    }
}
