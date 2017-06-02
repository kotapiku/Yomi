
//
//  HudaSet.swift
//  Yomi
//
//  Created by 郡茉友子 on 2017/05/23.
//  Copyright © 2017年 郡茉友子. All rights reserved.
//

import Foundation
import UIKit

class HudaSet: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var hudasettable: UITableView!
    @IBOutlet weak var helpbutton: UIBarButtonItem!
        
    let userdefaults = UserDefaults.standard
    var hudasets: [[Any]] = [[]]    //[["name",[1,1,0,1,...]]]
    var choicenum: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpbutton.image = UIImage.imageWithIonicon(ionicon.iOSHelpOutline, color: UIColor(r: 0, g: 122, b: 255), iconSize: 30.0, imageSize: CGSize(width: 25, height: 30))
        
        
        hudasettable.dataSource = self
        hudasettable.delegate = self
        
        if userdefaults.object(forKey: "hudasets") == nil{
            userdefaults.register(defaults: ["hudasets": [["百枚すべて",Array(repeating: 1, count: 100)]]])
        }
            hudasets = userdefaults.object(forKey: "hudasets") as! [[Any]]
        if userdefaults.object(forKey: "choicenum") == nil{
            userdefaults.register(defaults: ["choicenum": 0])
        }
            choicenum = userdefaults.object(forKey: "choicenum") as! Int
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hudasets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = hudasettable.cellForRow(at: indexPath){
            if indexPath.row != choicenum{
                cell.accessoryType = .checkmark
                hudasettable.cellForRow(at: IndexPath(row: choicenum, section: 0))?.accessoryType = .none
                userdefaults.set(indexPath.row, forKey: "choicenum")
                choicenum = indexPath.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row != choicenum{
            hudasets.remove(at: indexPath.row)
            userdefaults.set(hudasets, forKey: "hudasets")
            hudasettable.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "HudaCell")
        cell.textLabel?.font = UIFont(name: "Hiragino Sans", size:18.0)
        cell.textLabel?.text = hudasets[indexPath.row][0] as? String
        if indexPath.row == choicenum{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
        
    }

    //MARK: Action
    @IBAction func helpbutton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HudaToHelp", sender: nil)
    }
    @IBAction func addbutton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "HudaToChoice", sender: nil)
    }
    @IBAction func gamestartbutton(_ sender: UIButton) {
        performSegue(withIdentifier: "GameStart", sender: nil)
    }
    
}
