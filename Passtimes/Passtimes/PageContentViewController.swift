//
//  PageContentViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    /* Outlets */
    @IBOutlet var message: UILabel!

    /* Member Variables */
    var pageIndex: Int?
    var contentMessage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentMessage = contentMessage {
            message.text = contentMessage
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
