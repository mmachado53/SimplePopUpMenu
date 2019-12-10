//
//  PopUpMenuStyle.swift
//  Pods-SimplePopUpMenu_Example
//
//  Created by Miguel Machado on 12/10/19.
//

import Foundation
public struct PopUpMenuStyle{
    public var baseColor:UIColor = UIColor.white
    public var textColor:UIColor = UIColor.black
    public var headerColor:UIColor = UIColor.black
    public var headerTextColor:UIColor = UIColor.white
    public var selectedBackgroundColor:UIColor = UIColor.black.withAlphaComponent(0.1)
    public var itemSeparatorColor:UIColor = UIColor.black.withAlphaComponent(0.15)
    
    public init(){}
}
