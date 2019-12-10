//
//  ViewController.swift
//  SimplePopUpMenu
//
//  Created by mmachado53 on 12/09/2019.
//  Copyright (c) 2019 mmachado53. All rights reserved.
//

import UIKit
import SimplePopUpMenu
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sampleClick(_ sender:UIButton){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()
        let uno:PopUpMenuItem = PopUpMenuItem(title: "Hola mundo1")
        let dos:PopUpMenuItem = PopUpMenuItem(title: "Hola mundo3")
        p.presentSelf(identifier: "menu1", viewController: self, items: [uno,dos], sourceView: sender,permittedArrowDirections: .down,sourceRect:CGRect(x: sender.frame.width / 2, y: 0, width: 0, height: 0) )
    }

}

