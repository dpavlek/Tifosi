//
//  Article.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class Article{
    
    var photo: UIImage?
    var name: String
    var description: String
    
    init?(name: String, photo: UIImage?, description: String) {
        
        guard (!name.isEmpty && !description.isEmpty) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.description = description
        
    }
}
