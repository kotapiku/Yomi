//
//  Help.swift
//  Yomi
//
//  Created by 郡茉友子 on 2017/06/02.
//  Copyright © 2017年 郡茉友子. All rights reserved.
//

import Foundation
import UIKit

class Help: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func helptohudabutton(_ sender: UIBarButtonItem) {
        let hdvc = storyboard!.instantiateViewController(withIdentifier: "Huda")
        hdvc.modalTransitionStyle = .crossDissolve
        
        self.present(hdvc, animated: true, completion: nil)
    }
    
}
