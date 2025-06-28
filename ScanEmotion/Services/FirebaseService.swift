//
//  FirebaseService.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 16.06.2025.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCrashlytics

enum FirestoreCollectionEnum: String {
    case users = "users"
    case user = "user"
    case userDetail = "user-detail"
    case measurements = "measurements"
}

protocol FirebaseServiceProtocol {
    //MARK: - Auth
    func signInWithGoogle() async -> FirebaseUser?
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void)
    func checkUserSession() async -> FirebaseUser?
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) async
    func signUp(email: String, password: String, name: String, completion: @escaping(Result<Bool,Error>)-> Void) async
    func addUserToFirebase(uid: String, name: String, surname: String, email: String ) async
    
    //MARK: - Firestore
    func addMeasurementToFirebase(uid: String,measurement: Measurement) async -> String
    func getAllMeasurements(uid: String) async -> [Measurement]
    func getMeasurementByID(uid:String ,id: String) async -> Measurement?
    func updateMeasurementByID(uid:String, documentId: String, measurement: Measurement) async -> Bool
}

public class FirebaseService: FirebaseServiceProtocol {
    static let shared = FirebaseService()
    
    private let firestoreDb: Firestore
    private var isConfigReady: Bool = false

    init(firestoreDb: Firestore = Firestore.firestore()) {
        self.firestoreDb = firestoreDb
    }
    
    //MARK: - SIGN IN
    
    func signInWithGoogle() async -> FirebaseUser? {
        do {
            // 1. Root VC'yi UI thread üzerinden al
            let rootViewController = await getRootViewController();

            guard let presentingVC = rootViewController else {
                log("No root view controller", isError: true)
                return nil
            }

            // 2. Client ID çek
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                log("Missing Firebase client ID", isError: true)
                return nil
            }

            // 3. Google Sign-In yapılandırması
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            // 4. Google Sign-In başlat
            let signInResult: GIDSignInResult = try await withCheckedThrowingContinuation { continuation in
                Task { @MainActor in
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController! ) { result, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let result = result {
                            continuation.resume(returning: result)
                        } else {
                            continuation.resume(throwing: NSError(domain: "GoogleSignIn", code: -1))
                        }
                    }
                }
            }

            // 5. Credential oluştur ve Firebase login işlemi
            let user = signInResult.user
            guard let idToken = user.idToken?.tokenString else {
                log("Missing idToken",isError: true)
                return nil
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            let authResult = try await Auth.auth().signIn(with: credential)
            log("Firebase Sign-In successful: \(authResult.user.email ?? "no email")", isError: false)

            return FirebaseUser(user: authResult.user)

        } catch {
            log("SignInWithGoogle Error: \(error.localizedDescription)", isError: true)
            return nil
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            log("Successfully signed out", isError: false)
            completion(.success(true))
        } catch {
            log("Sign out failed: \(error.localizedDescription)", isError: true)
            completion(.failure(error))
        }
    }
    
    func checkUserSession() async -> FirebaseUser? {
        let currentUser = Auth.auth().currentUser
        if let currentUser {
            return FirebaseUser(user: currentUser)
        } else {
            return nil
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) async {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            log(email,isError: false)
            log(password,isError: false)
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = authResult?.user {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı."])))
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<Bool, Error>) -> Void) async {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                log("Kullanıcı oluşturulamadı: \(error.localizedDescription)",isError: true)
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "SignUpError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı."])))
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    log("Profil adı kaydedilemedi: \(error.localizedDescription)",isError: true)
                    completion(.failure(error))
                    return
                }
                
                log(" Kullanıcı oluşturuldu ve displayName eklendi.", isError: true)
                completion(.success(true))
            }
        }
    }
    
    func addUserToFirebase(uid: String, name: String, surname: String, email: String ) async {
        return await withCheckedContinuation { continuation in
            
            let dictionary: [String: Any] = [
                "name": name,
                "surname": surname,
                "email": email
            ]
            
            firestoreDb
                .collection(FirestoreCollectionEnum.users.rawValue)
                .document(uid)
                .collection(FirestoreCollectionEnum.user.rawValue)
                .addDocument(data: dictionary) { error in
                    if let error = error {
                        log("❌ Ölçüm eklenemedi: \(error.localizedDescription)", isError: true)
                    } else {
                        let documentId = Firestore.firestore().collection("users").document(uid).collection("user").document().documentID
                        log("✅ Ölçüm başarıyla eklendi", isError: false)
                    }
                }
        }
    }
    
    @MainActor
    func addMeasurementToFirebase(uid: String, measurement: Measurement) async -> String {
        return await withCheckedContinuation { continuation in
            firestoreDb
                .collection(FirestoreCollectionEnum.users.rawValue)
                .document(uid)
                .collection(FirestoreCollectionEnum.measurements.rawValue)
                .addDocument(data: measurement.asDictionary) { error in
                    if let error = error {
                        log("❌ Ölçüm eklenemedi: \(error.localizedDescription)", isError: true)
                        continuation.resume(throwing: .transferRepresentation)
                    } else {
                        let documentId = Firestore.firestore().collection("users").document(uid).collection("measurements").document().documentID
                        log("✅ Ölçüm başarıyla eklendi", isError: false)
                        continuation.resume(returning: documentId)
                    }
                }
        }
    }
    
    func getAllMeasurements(uid: String) async -> [Measurement] {
        do {
            let snapshot = try await firestoreDb
                .collection(FirestoreCollectionEnum.users.rawValue)
                .document(uid)
                .collection(FirestoreCollectionEnum.measurements.rawValue)
                .getDocuments()
            
            let todos = snapshot.documents.compactMap { document -> Measurement? in
                do {
                    let todo = try document.data(as: Measurement.self)
                    return todo
                } catch {
                    log(error.localizedDescription, isError: true)
                    return nil
                }
            }
            return todos
        } catch {
            log(error.localizedDescription,isError: true)
            return []
        }
    }
    
    func getMeasurementByID(uid:String ,id: String) async -> Measurement? {
        do {
            let documentSnapshot = try await firestoreDb
                       .collection(FirestoreCollectionEnum.users.rawValue)
                       .document(uid)
                       .collection(FirestoreCollectionEnum.measurements.rawValue)
                       .document(id)
                       .getDocument()
            
            return try? documentSnapshot.data(as: Measurement.self)
        } catch {
            log(error.localizedDescription,isError: true)
            return nil
        }
    }
    
    func updateMeasurementByID(uid:String, documentId: String, measurement: Measurement) async -> Bool {
        do {
            try await firestoreDb
                .collection(FirestoreCollectionEnum.users.rawValue)
                .document(uid)
                .collection(FirestoreCollectionEnum.measurements.rawValue)
                .document(documentId)
                .updateData([
                    "isDeleted": measurement.isDeleted
                ])
                
            return true
        } catch {
            log(error.localizedDescription,isError: true)
            return false
        }
    }
}


private func log(_ message: String, isError: Bool = false) {
#if DEBUG
    print(isError ? "❌" : "✅", message)
#else
     Crashlytics.crashlytics().log(message)
#endif
}

extension FirebaseService {
    var currentUID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
}
