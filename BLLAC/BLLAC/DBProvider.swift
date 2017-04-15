//
//  DBProvider.swift
//  BLLAC
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider();
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
    var clientRef: FIRDatabaseReference {
        return dbRef.child(Constants.CLIENT);
    }
    var apptRef: FIRDatabaseReference {
        return dbRef.child(Constants.APPOINTMENTS)
    }
    var apptAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.ACCEPTED)
    }
    
} // class

