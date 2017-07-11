//
//  NoteData.swift
//  Notes
//
//  Created by Manas Mishra on 11/07/17.
//  Copyright © 2017 Manas. All rights reserved.
//

import UIKit
import RealmSwift

class NoteData: Object {
    dynamic var title = ""
    dynamic var detail = ""
    dynamic var dateUpdated = Date()
    dynamic var priorityOfNote = 1

}
