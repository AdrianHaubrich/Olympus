//
//  FirestoreSubscription.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreSubscription {
    
    static func subscribe(id: String, docPath: String) -> AnyPublisher<DocumentSnapshot, Never> {
        let subject = PassthroughSubject<DocumentSnapshot, Never>()
        
        let docRef = Firestore.firestore().document(docPath)
        let listener = docRef.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot {
                subject.send(snapshot)
            }
        }
        
        documentListeners[id] = DocumentListener(document: docRef, listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
}

// MARK: - Subscribe to Query
extension FirestoreSubscription {
    
    static func subscribe(to query: Query,
                          with id: String) -> AnyPublisher<QuerySnapshot, Never> {
        
        let subject = PassthroughSubject<QuerySnapshot, Never>()
        let listener = query.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot {
                subject.send(snapshot)
            }
        }
        
        // Add to Dict
        queryListeners[id] = QueryListener(query: query, listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
}

// MARK: - Unsubscribe / Cancel
extension FirestoreSubscription {
    
    static func cancel(id: String, isQuery: Bool? = nil) {
        if (isQuery == true) {
            queryListeners[id]?.listener.remove()
            queryListeners[id]?.subject.send(completion: .finished)
            queryListeners[id] = nil
        } else {
            documentListeners[id]?.listener.remove()
            documentListeners[id]?.subject.send(completion: .finished)
            documentListeners[id] = nil
        }
    }
    
}


private var documentListeners: [String: DocumentListener] = [:]
private var queryListeners: [String: QueryListener] = [:]

private struct DocumentListener {
    let document: DocumentReference
    let listener: ListenerRegistration
    let subject: PassthroughSubject<DocumentSnapshot, Never>
}

private struct QueryListener {
    let query: Query
    let listener: ListenerRegistration
    let subject: PassthroughSubject<QuerySnapshot, Never>
}

// MARK: Usage
//class ViewController: UIViewController {
//
//@IBOutlet weak var label: UILabel!
//
//var cancellables: Set<AnyCancellable> = []
//
//struct SubscriptionID: Hashable {}
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    // Do any additional setup after loading the view.
//
//    FirestoreSubscription.subscribe(id: SubscriptionID(), docPath: "labels/title")
//        .compactMap(FirestoreDecoder.decode(LabelDoc.self))
//        .receive(on: DispatchQueue.main)
//        .map(\LabelDoc.value)
//        .assign(to: \.text, on: label)
//        .store(in: &cancellables)
//}
//}

// Refer to: https://stackoverflow.com/a/69366330/8665577
