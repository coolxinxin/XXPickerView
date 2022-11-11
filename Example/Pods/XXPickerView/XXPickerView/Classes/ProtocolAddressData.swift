//
//  ProtocolAddressData.swift
//  XXPickerView
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation

open class ProtocolAddressData<T>{
    
    open func getName()->String{
        return ""
    }
    
    //没有code的直接返回你的name
    open func getCode()->String{
        return ""
    }
    
   open func getChildList()->Array<T>?{
        return nil
    }
    
    required public init(){}
}
