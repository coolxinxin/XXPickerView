//
//  ViewController.swift
//  XXPickerView
//
//  Created by coolxinxin on 11/10/2022.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import UIKit
import XXPickerView

class ViewController: UIViewController {
    
    private lazy var btBirthday = UIButton()
    private lazy var btAddress = UIButton()
    private lazy var btEducation = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(btBirthday)
        btBirthday.frame =  CGRect.init(x: 20, y: 100, width: 200, height: 50)
        btBirthday.setTitle("Select Birthday", for: .normal)
        btBirthday.setTitleColor(UIColor.blue, for: .normal)
        btBirthday.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btBirthday.addTarget(self, action: #selector(selectBirthday), for: .touchUpInside)
        
        self.view.addSubview(btAddress)
        btAddress.frame =  CGRect.init(x: 20, y: 150, width: 200, height: 50)
        btAddress.setTitle("Select Address", for: .normal)
        btAddress.setTitleColor(UIColor.blue, for: .normal)
        btAddress.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btAddress.addTarget(self, action: #selector(selectAddress), for: .touchUpInside)
        
        self.view.addSubview(btEducation)
        btEducation.frame =  CGRect.init(x: 20, y: 200, width: 200, height: 50)
        btEducation.setTitle("Select Education", for: .normal)
        btEducation.setTitleColor(UIColor.blue, for: .normal)
        btEducation.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btEducation.addTarget(self, action: #selector(selectEducation), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   private var dateStr:String = ""
    
    @objc func selectBirthday(){
        let date = self.stringToDate(dateStr) ?? Date()
        DatePickerView(title: "??????????????????",date:date,dateResultBlock: {date in
            if(date != nil){
                self.btBirthday.setTitle(self.dateToString(date!), for: .normal)
                self.dateStr = self.dateToString(date!)
            }
        }).show()
    }
    
    private var provinceCode = ""
    private var cityCode = ""
    
    @objc func selectAddress(){
        var data = Array<AddressData>()
        var jxCity = Array<AddressData>()
        jxCity.append(AddressData("??????","11"))
        jxCity.append(AddressData("??????","12"))
        jxCity.append(AddressData("??????","13"))
        data.append(AddressData("??????","1",jxCity))
        var hnCity = Array<AddressData>()
        hnCity.append(AddressData("??????","20"))
        hnCity.append(AddressData("??????","21"))
        hnCity.append(AddressData("??????","22"))
        data.append(AddressData("??????","2",hnCity))
        var gdCity = Array<AddressData>()
        gdCity.append(AddressData("??????","30"))
        gdCity.append(AddressData("??????","31"))
        gdCity.append(AddressData("??????","32"))
        data.append(AddressData("??????","3",gdCity))
        var hbCity = Array<AddressData>()
        hbCity.append(AddressData("??????","40"))
        hbCity.append(AddressData("??????","41"))
        hbCity.append(AddressData("??????","42"))
        data.append(AddressData("??????","4",hbCity))
        AddressPickerView<AddressData,AddressData>(title: "??????????????????", dataSource: data, selectProvinceCode: provinceCode, selectCityCode: cityCode, callback: {(province,city) in
            let provinceName = province?.getName() ?? ""
            let cityName = city?.getName() ?? ""
            self.btAddress.setTitle("\(provinceName)-\(cityName)", for: .normal)
            self.provinceCode = province?.getCode() ?? ""
            self.cityCode = city?.getCode() ?? ""
        }).show()
    }
    
    private var educationCode = ""
    
    @objc func selectEducation(){
        SinglePickerView<SingleExampleData>(title: "??????????????????", dataSource: genEducation(), selectCode: educationCode, callback: {result in
            let education = result?.getName() ?? ""
            self.btEducation.setTitle("\(education)", for: .normal)
            self.educationCode = result?.getCode() ?? ""
        }).show()
    }
    
    func stringToDate(_ str:String) ->Date?{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = Locale.init(identifier: "en")
        return format.date(from: str)
    }
    
    func dateToString(_ date:Date) ->String{
        let format = DateFormatter()
        format.locale = Locale.init(identifier: "en")
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: date)
    }

}

