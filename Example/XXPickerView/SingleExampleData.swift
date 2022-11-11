//
//  SingleExampleData.swift
//  XXPickerView_Example
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation
import XXPickerView

class SingleExampleData : PortocolSingleData{
    var contentName = ""
    var contentCode = ""
    
    required init(_ contentCode: String, _ contentName: String){
        self.contentName = contentName
        self.contentCode = contentCode
    }
    
    func getName()->String{
        return contentName
    }
    
    func getCode()->String{
        return contentCode
    }
}

func genEducation() ->Array<SingleExampleData> {
    var data = Array<SingleExampleData>()
    data.append(SingleExampleData("1", "小学"))
    data.append(SingleExampleData("2", "初中"))
    data.append(SingleExampleData("3", "高中"))
    data.append(SingleExampleData("4", "专科"))
    data.append(SingleExampleData("5", "本科"))
    data.append(SingleExampleData("6", "研究生"))
    return data
}
