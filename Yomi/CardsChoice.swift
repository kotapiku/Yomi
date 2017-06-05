//
//  cardschoice.swift
//  Yomi
//
//  Created by 郡茉友子 on 2017/05/19.
//  Copyright © 2017年 郡茉友子. All rights reserved.
//

import Foundation
import UIKit

class CardsChoice: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var selectbutton: UIBarButtonItem!
    @IBOutlet weak var cardtable: UITableView!
    @IBOutlet weak var narabi: UISegmentedControl!
    @IBOutlet weak var backbutton: UIBarButtonItem!
    
    let cards = CardInfo().cards
    var cardnarabi:[Int] = [Int](0...99)
    var choicecards:[Int] = Array(repeating: 1, count: 100)     //[0,0,1,1,1,0,...]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        narabi.addTarget(self, action: #selector(CardsChoice.narabiChanged(segcon:)), for: UIControlEvents.valueChanged)
        selectbutton.tintColor = UIColor.red
        backbutton.image = UIImage.imageWithIonicon(ionicon.iOSArrowBack, color: UIColor(r: 0, g: 122, b: 255), iconSize: 35.0, imageSize: CGSize(width: 15, height: 30))
        
        cardtable.dataSource = self
        cardtable.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func narabiChanged(segcon: UISegmentedControl){
        
        switch segcon.selectedSegmentIndex {
        case 0:
            cardnarabi = CardInfo().utabangonum
            
        case 1:
            cardnarabi = CardInfo().musumenum
      
        default:
            print("Error")
        }
        self.cardtable.reloadData()
    }
    
   //MARK: tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                choicecards[cardnarabi[indexPath.row]] = 0
                selectbutton.title = "全て選択"
                selectbutton.tintColor = UIColor(r: 0, g:122, b: 255)
            }else{
                cell.accessoryType = .checkmark
                choicecards[cardnarabi[indexPath.row]] = 1
                if choicecards.index(of: 0) == nil{
                    selectbutton.title = "全て選択解除"
                    selectbutton.tintColor = UIColor.red
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        cell.textLabel?.text = cards[cardnarabi[indexPath.row]][0] + cards[cardnarabi[indexPath.row]][1]
        if choicecards[cardnarabi[indexPath.row]] == 1{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    //MARK: Action
    @IBAction func registerbutton(_ sender: UIBarButtonItem) {
        let userdefaults = UserDefaults.standard
        var hudasets: [[Any]] = [[]]    //[["name",[1,1,0,1,...]]]
        let alert = UIAlertController(title: "新規札セット登録", message: "", preferredStyle: .alert)
        
        if userdefaults.object(forKey: "hudasets") == nil{
            userdefaults.register(defaults: ["hudasets": [["百枚すべて",Array(repeating: 1, count: 100)]]])
        }
        hudasets = userdefaults.object(forKey: "hudasets") as! [[Any]]
        
        alert.addAction(UIAlertAction(title: "登録", style: .default,handler: {
            (action:UIAlertAction!) -> Void in
            if let settexts = alert.textFields{
                for settext in settexts{
                    if settext.text != "" && self.choicecards.index(of: 1) != nil{
                        hudasets += [[settext.text!,self.choicecards]]
                        userdefaults.set(hudasets, forKey: "hudasets")
                        
                        let hdvc = self.storyboard!.instantiateViewController(withIdentifier: "Huda")
                        hdvc.modalTransitionStyle = .crossDissolve
                        
                        self.present(hdvc, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "札セット名"
        })
        
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func selectbutton(_ sender: UIBarButtonItem) {
        if choicecards.index(of: 0) == nil{
            for i in [Int](0...99){
                cardtable.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
            }
            choicecards = Array(repeating: 0, count: 100)
            selectbutton.title = "全て選択"
            selectbutton.tintColor = UIColor(r: 0, g:122, b: 255)
        }else{
            let changenum = choicecards.enumerated().filter{$0.1 == 0}.map{$0.0}
            for i in changenum{
                cardtable.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .checkmark
            }
            choicecards = Array(repeating: 1, count: 100)
            selectbutton.title = "全て選択解除"
            selectbutton.tintColor = UIColor.red
        }
    }
    
    @IBAction func backbutton(_ sender: UIBarButtonItem) {
        let hdvc = storyboard!.instantiateViewController(withIdentifier: "Huda")
        hdvc.modalTransitionStyle = .crossDissolve
        
        self.present(hdvc, animated: true, completion: nil)
    }
 
}

