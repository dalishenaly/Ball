//
//  THCitySelectVC.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/6.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

enum CityType {
    case province
    case city
}

class THCitySelectVC: THBaseTableViewVC {
    
    var province: String?
    var cityType: CityType?
    var cityArr = [String]()
    var citySelectBlock: ((_ city: String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        if cityType == .province {
            let path = Bundle.main.path(forResource: "Citys", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)!
            cityArr = dict["citys_order"] as! [String]
        }
        
        tableView.reloadData()
    }

}

extension THCitySelectVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCityCell") as? THCityCell
        if cell == nil {
            cell = THCityCell(style: .default, reuseIdentifier: "THCityCell")
        }
        
        cell?.titleLabel.text = cityArr[indexPath.row]
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cityType == .province {
            let path = Bundle.main.path(forResource: "Citys", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)!
            let arr = dict["citys_array"] as! [[String]]
            let vc = THCitySelectVC()
            vc.cityArr = arr[indexPath.row]
            vc.cityType = .city
            vc.province = cityArr[indexPath.row]
            vc.citySelectBlock = self.citySelectBlock
            navigationPushVC(vc: vc)
        } else {
            let city = self.province! + cityArr[indexPath.row]
            citySelectBlock?(city)
            popCitySelectVC()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        view.backgroundColor = COLOR_LINE
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: SCREEN_WIDTH - 20, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = COLOR_333333
        view.addSubview(label)
        if cityType == .province {
            label.text = "省/直辖市"
        } else {
            label.text = "地级市/区"
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


/// pop登录相关vc
func popCitySelectVC() {
    let vcArr = AppDelegate.CURRENT_NAV_VC?.viewControllers ?? []
    var vcArray = [UIViewController]()
    for vc in vcArr {
        if !(vc is THCitySelectVC) {
            vcArray.append(vc)
        }
    }
    AppDelegate.CURRENT_NAV_VC?.setViewControllers(vcArray, animated: true)
}
