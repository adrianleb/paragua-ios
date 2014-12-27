//
//  SessionManager.swift
//  Insights
//
//  Created by Adrian le Bas on 27/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import Foundation

private let _SessionManagerSharedInstance = SessionManager()

class SessionManager  {
    let ref = Firebase(url: "https://insights.firebaseio.com")
    var authData = FAuthData?()
    
    class var sharedInstance : SessionManager {
        return _SessionManagerSharedInstance
    }
    
    func performFacebookCheck(completion: ((Bool) -> Void)?) {
        FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: {
            session, state, error in
            if error != nil {
                println("Facebook login failed. Error \(error)")
            } else if state ==  FBSessionState.Open {
                let accessToken = session.accessTokenData.accessToken
                println("what")
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            println("finally fb \(authData)")
                            completion!(false)
                        } else {
                            let newUser = [
                                "provider": authData.provider,
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            self.ref.childByAppendingPath("users")
                                .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            completion!(true)
                            //                            self.performSegueWithIdentifier("push", sender: self)
                        }
                })
            }
        } )
        
        
    }
    func logout() {
        self.ref.unauth()
    }
    
    func checkSession(completion: ((Bool) -> Void)?) {
        
        self.ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated with Firebase
                self.authData = authData
                println("what??????? \(authData), www, \(self.authData!)")
                completion!(true)
                
            } else {
                println(authData)
                self.performFacebookCheck({(result: Bool) in
                    completion!(result)
    
                })   // Do any additional setup after loading the view.

                // No user is logged in
            }
        })
        
    }
    
    
}
