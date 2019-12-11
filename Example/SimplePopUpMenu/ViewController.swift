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
    
    let likeIconImage:UIImage = UIImage(named: "like_icon")!
    let heartIconImage:UIImage = UIImage(named: "heart_icon")!
    var darkPopupStyle:PopUpMenuStyle = PopUpMenuStyle()
    var customPopupStyle:PopUpMenuStyle = PopUpMenuStyle()

    override func viewDidLoad() {
        super.viewDidLoad()
        darkPopupStyle.baseColor = UIColor.black.withAlphaComponent(0.8)
        darkPopupStyle.textColor = UIColor.white
        darkPopupStyle.itemSeparatorColor = UIColor.white
        darkPopupStyle.selectedBackgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        
        customPopupStyle.selectedBackgroundColor = UIColor.white.withAlphaComponent(0.3)
        customPopupStyle.headerColor = UIColor.black.withAlphaComponent(0.1)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func directionAction(_ sender:UIButton){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()
        let tintedIcons:Bool
        var noIcons:Bool = false
        let buttonText:String = sender.title(for: .normal)?.lowercased() ?? ""
        let permittedArrowDirection:UIPopoverArrowDirection
        if buttonText.contains("left") {
            tintedIcons = true
            noIcons = true
            p.visibleHeader = true
            permittedArrowDirection = .left
        }else if buttonText.contains("right"){
            tintedIcons = true
            p.visibleHeader = false
            permittedArrowDirection = .right
        }else if buttonText.contains("up"){
            noIcons = true
            tintedIcons = false
            p.visibleHeader = false
            permittedArrowDirection = .up
        }else if buttonText.contains("down"){
            tintedIcons = false
            p.visibleHeader = true
            permittedArrowDirection = .down
        }else{
            tintedIcons = false
            p.visibleHeader = false
            permittedArrowDirection = .any
        }
        
        customPopupStyle.baseColor = sender.backgroundColor ?? customPopupStyle.baseColor
        customPopupStyle.textColor = sender.titleColor(for: .normal) ?? customPopupStyle.textColor
        
        
        
        p.title = "Title"
        p.style = customPopupStyle
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item A",uiImage: noIcons ? nil : likeIconImage,tintImage: tintedIcons)
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item B", uiImage: noIcons ? nil : heartIconImage,tintImage: tintedIcons)
        var items:[PopUpMenuItem] = []
        items.append(a)
        items.append(b)
        if noIcons {
            items.append(PopUpMenuItem(title: "Item C"))
            items.append(PopUpMenuItem(title: "Item D"))
            items.append(PopUpMenuItem(title: "Item E"))
            items.append(PopUpMenuItem(title: "Item F"))
            items.append(PopUpMenuItem(title: "Item G"))
        }
        p.showMenu(menuIdentifier: "menu1", viewController: self, items: items, sourceView: sender,permittedArrowDirections: permittedArrowDirection)
        p.setHandler { (selected) in
            print("SELECTED \(selected)")
        }
    }

    @IBAction func navItemActionBlackStyle(_ sender:UIBarButtonItem){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()        
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item C", uiImage: heartIconImage,tintImage: true)
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item D",uiImage: likeIconImage,tintImage: true)
        p.style = darkPopupStyle
        p.showMenu(menuIdentifier: "menu2", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .up)
        p.delegate = self
    }
    
    @IBAction func navItemActionGlobalStyle(_ sender:UIBarButtonItem){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item C", uiImage: heartIconImage,tintImage: true)
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item D",uiImage: likeIconImage,tintImage: true)
        p.showMenu(menuIdentifier: "menu2", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .up)
        p.delegate = self
    }
    
}

extension ViewController : PopUpMenuDelegate{
    func popupmenu(selectItem: Int, menuIdentifier: String) {
        print("MENU TYPE \(menuIdentifier), selected: \(selectItem)")
    }
    
    
}

