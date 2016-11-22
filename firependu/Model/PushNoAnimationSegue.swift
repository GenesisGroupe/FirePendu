//
//  PushNoAnimationSegue.swift
//  Etam
//
//  Created by Genesis-PC on 21/07/2016.
//  Copyright © 2016 ETAM. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        source.navigationController?.pushViewController(self.destination, animated: false)
    }
}
