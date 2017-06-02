//
//  ViewController.swift
//  Yomi
//
//  Created by 郡茉友子 on 2017/05/17.
//  Copyright © 2017年 郡茉友子. All rights reserved.
//

import UIKit


extension Array{
    mutating func shuffle(){
        for _ in 0..<self.count{
            self.sort{_,_ in arc4random() < arc4random()}
        }
    }
    
}
extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        let red = CGFloat(Double(r & 0xFF) / 255.0)
        let green = CGFloat(Double(g & 0xFF) / 255.0)
        let blue = CGFloat(Double(b & 0xFF) / 255.0)
        let alpha = CGFloat(Double(a & 0xFF) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


class MainGame: UIViewController {
    
    @IBOutlet weak var shimonoku: UILabel!
    @IBOutlet weak var kaminoku: UILabel!
    @IBOutlet weak var shimonokunum: UILabel!
    @IBOutlet weak var kaminokunum: UILabel!
    @IBOutlet weak var timertext: UILabel!
    @IBOutlet weak var bluetimerbar: UIProgressView!
    @IBOutlet weak var darktimerbar: UIProgressView!
    @IBOutlet weak var timerbutton: UIButton!
    @IBOutlet weak var circleprogress: KDCircularProgress!
    
    
    var index = 0
    var timercount:Double = 4.0
    var mytimer = Timer()
    var starttime:TimeInterval = 0
    let yomicards = CardInfo().yomicards
    var cardsnum:Int = 100
    var randomary = [Int](0...99)
    let myblue = UIColor(r: 0, g: 122, b: 255)   //115,175,255
    let waitblue = UIColor(r: 127, g: 189, b: 255)
    let myred = UIColor.red     //255,130,130
    let userdefaults = UserDefaults.standard
    var hudasets: [[Any]] = [[]]    //[["name",[1,1,0,1,...]]]
    var choicenum: Int = 0
    
    
    
    override func viewDidLoad() {
    
        circleprogress.set(colors: myblue)
        
        if userdefaults.object(forKey: "hudasets") == nil{
            userdefaults.register(defaults: ["hudasets": [["百枚すべて",Array(repeating: 1, count: 100)]]])
        }
        hudasets = userdefaults.object(forKey: "hudasets") as! [[Any]]
        if userdefaults.object(forKey: "choicenum") == nil{
            userdefaults.register(defaults: ["choicenum": 0])
        }
        choicenum = userdefaults.object(forKey: "choicenum") as! Int
        
        
        randomary = (hudasets[choicenum][1] as! Array).enumerated().filter{$0.1 == 1}.map{$0.0}
        cardsnum = randomary.count
        for i in 0..<randomary.count{
            randomary[i] = randomary[i] + 1
        }
        
        randomary.shuffle()
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.upSwipeView(sender:)))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.downSwipeView(sender:)))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerUpdate() {
        timercount = 4.0-(Date().timeIntervalSince1970 - starttime)
        let sec = Int(timercount)
        let msec = Int((timercount-Double(sec))*10)
        timertext.text = NSString(format:"%1d.%1d",sec,msec) as String
        timerbutton.setTitle("", for: .normal)
        
        if(1<=timercount) && (timercount<=4){
            circleprogress.angle = Double((timercount)/4.0)*360.0
        }else if(0<=timercount){
            circleprogress.set(colors: myred)
            circleprogress.angle = Double((timercount)/4.0)*360.0
        }else if(timercount<0){
            mytimer.invalidate()
            circleprogress.set(colors: myblue)
            timercount = 4.0
            timertext.text = ""
            circleprogress.angle = 360
            timerbutton.setTitle("▶︎", for: .normal)
            timerbutton.setTitleColor(waitblue, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                //upSwipeView
                if (self.index == 0) {
                    self.shimonoku.text = self.yomicards [0][1]
                    self.kaminoku.text = self.yomicards [self.randomary [0]][0]
                    self.kaminokunum.text = "(" + String(self.index+1) + ")"
                    self.index += 1
                } else if (self.index < self.cardsnum) {
                    self.shimonoku.text = self.yomicards [self.randomary [self.index - 1]][1]
                    self.kaminoku.text = self.yomicards [self.randomary [self.index]][0]
                    self.shimonokunum.text = "(" + String(self.index) + ")"
                    self.kaminokunum.text = "(" + String(self.index+1) + ")"
                    self.index += 1
                } else if (self.index == self.cardsnum) {
                    self.shimonoku.text = self.yomicards [self.randomary [self.cardsnum-1]][1]
                    self.kaminoku.text = ""
                    self.shimonokunum.text = "(" + String(self.index) + ")"
                    self.kaminokunum.text = ""
                    self.index += 1
                }
            
                self.timerbutton.isEnabled = true
                self.timerbutton.setTitleColor(self.myblue, for: .normal)
                
            }
            


        }
    }
    
    func upSwipeView(sender: UISwipeGestureRecognizer) {
        if (index == 0) {
            shimonoku.text = yomicards [0][1]
            kaminoku.text = yomicards [randomary [0]][0]
            kaminokunum.text = "(" + String(index+1) + ")"
            index += 1
        } else if (index < cardsnum) {
            shimonoku.text = yomicards [randomary [index - 1]][1]
            kaminoku.text = yomicards [randomary [index]][0]
            shimonokunum.text = "(" + String(index) + ")"
            kaminokunum.text = "(" + String(index+1) + ")"
            index += 1
        } else if (index == cardsnum) {
            shimonoku.text = yomicards [randomary [cardsnum-1]][1]
            kaminoku.text = ""
            shimonokunum.text = "(" + String(index) + ")"
            kaminokunum.text = ""
            index += 1
        }

    }
    
    func downSwipeView(sender: UISwipeGestureRecognizer) {
        if (index == 1) {
            shimonoku.text = yomicards [0][0]
            kaminoku.text = yomicards [0][1]
            shimonokunum.text = "(序歌)"
            kaminokunum.text = "(序歌)"
            index -= 1
        } else if (index == 2) {
            shimonoku.text = yomicards [0][1]
            kaminoku.text = yomicards [randomary [0]][0]
            shimonokunum.text = "(序歌)"
            kaminokunum.text = "(" + String(index-1) + ")"
            index -= 1
        } else if (index <= cardsnum+1) && (1 <= index) {
            shimonoku.text = yomicards [randomary [index - 3]][1]
            kaminoku.text = yomicards [randomary [index - 2]][0]
            shimonokunum.text = "(" + String(index-2) + ")"
            kaminokunum.text = "(" + String(index-1) + ")"
            index -= 1
        }
   
    }
        
    @IBAction func timerbutton(_ sender: UIButton) {
        timerbutton.isEnabled = false
        starttime = Date().timeIntervalSince1970
        mytimer = Timer.scheduledTimer(timeInterval:0.01, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        
    }
    @IBAction func tyuudan(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "試合を終了しますか？", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: {(action:UIAlertAction!) in self.performSegue(withIdentifier: "GameToHuda", sender: nil)}))
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

