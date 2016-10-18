//
//  PLSignUpHelpers.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum SignupDataSource {
    case SourceFacebook(Facebook)
    case SourceManual(Manual)
}

struct PLSignUpData {
    
    var source: SignupDataSource

    var params: [String : AnyObject] {
        switch source {
            case .SourceManual(let manual): return manual.params
            case .SourceFacebook(let facebook): return facebook.params
        }
    }
    
    var picture: UIImage? {
        switch source {
            case .SourceManual(let manual): return manual.picture
            case .SourceFacebook(_): return nil
        }
    }
    
}

struct Facebook {
    var fbid: String
    var username: String
    var email: String
    var pictureURLString: String
    var params: [String : AnyObject] {
        let params = [PLKeys.fbid.string : fbid,
                      PLKeys.username.string : username,
                      PLKeys.email.string : email,
                      PLKeys.picture_url.string : pictureURLString]
        return params
    }
}

struct Manual {
    var username: String
    var email: String
    var password: String
    var picture: UIImage?
    var params: [String : AnyObject] {
        let params = [PLKeys.username.string : username,
                      PLKeys.email.string : email,
                      PLKeys.password.string : password]
        return params
    }
}

