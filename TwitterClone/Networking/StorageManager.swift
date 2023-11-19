//
//  StorageManager.swift
//  TwitterClone
//
//  Created by window1 on 2023/11/15.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError: Error {
    case invaildImageID
}


final class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage().reference()
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else { return Fail(error: FirestorageError.invaildImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .storage.reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error>{
        return storage
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
}
