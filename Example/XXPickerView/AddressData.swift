//
//  AddressData.swift
//  XXPickerView_Example
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//
import Foundation
import XXPickerView


class AddressData : ProtocolAddressData<AddressData>{
    
    var name : String?
    
    var code : String?
    
    var parentId :String?
    
    var childList : Array<AddressData>?
    
    override func getCode() -> String {
        return code ?? ""
    }
    
    override func getName() -> String {
        return name ?? ""
    }
    
    override func getChildList() -> Array<AddressData>? {
        return childList
    }
    
    required init(_ name: String, _ code: String,_ childList:Array<AddressData>? = nil){
        super.init()
        self.name = name
        self.code = code
        self.childList = childList
    }
    
    required init() {
    }

}
