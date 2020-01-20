//
//  THLocationManager.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/6.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

let LocationCity = "LocationCity"

class THLocationManager: NSObject {

    var reverseCount = 0
    let manager = CLLocationManager()
    var isCoding: Bool = false
    var isSelectedCity: Bool = false
    
    var longitude: CLLocationDegrees?   //经度
    var latitude: CLLocationDegrees?
    
    internal static let instance = THLocationManager()
    
    private override init(){
        print("create 单例")
    }
}

extension THLocationManager {
    ///GPS定位
    func getLocation() {
        reverseCount = 0
        
        if self.isCoding {
            return
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            
            if #available(iOS 8, *) {
                manager.requestWhenInUseAuthorization()
            }
            print(CLLocationManager.locationServicesEnabled())
            manager.startUpdatingLocation()
        } else {
            //  未打开定位
            responseLocationFailed(false)
        }
    }
    
    
    func reverseGeocode(_ location: CLLocation) {
        
        manager.stopUpdatingLocation()
        
        let revGeo = CLGeocoder()
        revGeo.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error == nil, (placemarks?.count)! > 0 {
                
                let placeMark = placemarks?.last
                let longitude = location.coordinate.longitude
                let latitude = location.coordinate.latitude
                let str = placeMark?.addressDictionary?["FormattedAddressLines"] as! NSArray
                let string = str.firstObject as! String
                var city = placeMark?.addressDictionary?["City"] as! String
                let pl = placemarks?.first
                
                self.longitude = longitude
                self.latitude = latitude
//                print(longitude, latitude, string, city)
//                print(pl ?? "全国")
                
                if city.contains("市") {
                    city = city.replacingOccurrences(of: "市", with: "")
                }
                
                //  成功
                if !self.isSelectedCity {
//                    let cityModel = CYGLocationCityModel()
//                    cityModel.city = city
//                    cityModel.cityId = ""
//                    cityModel.address = string
//                    cityModel.latitude = latitude
//                    cityModel.longitude = longitude
//                    CYGLoginRegisterManager.sharedInstance.cityInfo = cityModel
                }
//                NotificationCenter.default.post(name: NSNotification.Name(kCYGLocationResult), object: city)
                
                self.isCoding = false
            } else {
                //  失败
                self.responseLocationFailed(true)
                self.isCoding = false
            }
            
        }
    }
    
    func responseLocationFailed(_ isAuthorized: Bool) {
        
        //  定位失败
        if !isSelectedCity {
//            let cityModel = CYGLocationCityModel()
//            cityModel.city = "全国"
//            cityModel.cityId = "-1"
//            CYGLoginRegisterManager.sharedInstance.cityInfo = cityModel
        }
//        NotificationCenter.default.post(name: NSNotification.Name(kCYGLocationResult), object: "全国")
        
        if isAuthorized {
            let alertController = UIAlertController(title: "网络不可用，请检查网络连接是否正常",
                                                    message: nil,
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.getCurrentVC().present(alertController, animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "开启定位服务",
                                                    message: "请在系统设置中开启定位服务【设置】-【隐私】-【定位服务】中打开开关，并允许销售管理使用定位服务",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "立即开启", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(okAction)
//            self.getCurrentVC().present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    func getCurrentVC()->UIViewController{
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }

}

// MARK: - CLLocationManagerDelegate
extension THLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.isCoding {
            return
        } else {
            reverseGeocode(locations.last!)
            self.isCoding = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == .authorizedAlways) ||
            (CLLocationManager.authorizationStatus() == .notDetermined) {
            self.reverseCount += 1
            if self.reverseCount < 3 {
                manager.startUpdatingLocation()
            } else {
                //  已经允许定位
                self.responseLocationFailed(true)
            }
        } else {
            //  未允许定位
            self.responseLocationFailed(false)
        }
    }
}


// MARK: - 地图标点的方法
//extension THLocationManager {
//    /// 显示地图actionsheet
//    ///
//    /// - Parameters:
//    ///   - latitude: 纬度
//    ///   - longitude: 经度
//    ///   - address: title，地址
//    ///   - addressDes: detailtitle 详细地址
//    ///   - viewController: 当前的vc
//
//    func openMap(latitude: Double, longitude: Double, address: String, addressDes: String, viewController: UIViewController) {
//
//        let canOpenGaoDeMap : Bool = UIApplication.shared.canOpenURL(NSURL(string:"iosamap://")! as URL)
//        let canOpenBaiDuMap : Bool = UIApplication.shared.canOpenURL(NSURL(string:"baidumap://")! as URL)
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        let appleAction = UIAlertAction(title: "苹果", style: .default, handler: {
//            (actioon:UIAlertAction) ->Void in
//            self.openAppleMap(latitude: latitude,longitude: longitude,address: address,addressDes: addressDes)
//        })
//        alertController.addAction(appleAction)
//
//        let gaoDeAction = UIAlertAction(title: "高德", style: .default, handler:{
//            (action:UIAlertAction) ->Void in
//
//            self.openGaoDeMap(latitude: latitude,longitude: longitude,address: address,addressDes: addressDes, canOpenAMap: canOpenGaoDeMap)
//        })
//        alertController.addAction(gaoDeAction)
//
//        let baiDuAction = UIAlertAction(title: "百度", style: .default, handler: {
//            (action:UIAlertAction) -> Void in
//
//            self.openBaiDuMap(latitude: latitude, longitude: longitude, address: address, addressDes: addressDes, canOpenBaiduMap: canOpenBaiDuMap)
//        })
//        alertController.addAction(baiDuAction)
//
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//
//    // 打开苹果地图
//    func openAppleMap(latitude:Double, longitude:Double, address:String, addressDes:String) {
//        let loc : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//        let mapItem : MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: loc,addressDictionary: nil))
//        MKMapItem.openMaps(with: [mapItem], launchOptions: [:])
//    }
//
//    // 打开百度地图
//    func openBaiDuMap(latitude:Double, longitude:Double, address:String, addressDes:String, canOpenBaiduMap: Bool) {
//        var urlStr: NSString = ""
//        let x = longitude , y = latitude
//        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
//        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)
//
//        let lon = z * cos(theta) + 0.0065
//        let lat = z * sin(theta) + 0.006
//
//        if canOpenBaiduMap {
//            urlStr = "baidumap://map/marker?location=\(lat),\(lon)&title=\(address)&content=\(addressDes)&src=webapp.marker.rrqc.renrenqicheCTest" as NSString
//        } else {
//            urlStr = "http://api.map.baidu.com/marker?location=\(lat),\(lon)&title=\(address)&content=\(addressDes)&output=html&src=webapp.marker.rrqc.renrenqicheCTest" as NSString
//        }
//
//        let url = NSURL(string:urlStr.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url! as URL)
//        }
//    }
//
//    // 打开高德地图
//    func openGaoDeMap(latitude:Double, longitude:Double, address:String, addressDes:String, canOpenAMap: Bool) {
//        var urlStr: NSString = ""
//
//        if canOpenAMap {
//            urlStr = "iosamap://viewMap?sourceApplication=applicationName&poiname=\(address)&lat=\(latitude)&lon=\(longitude)&dev=1" as NSString
//        } else {
//            urlStr = "http://uri.amap.com/marker?position=\(longitude),\(latitude)&name=\(address)&src=人人汽车&coordinate=gaode&callnative=0" as NSString
//        }
//
//        let url = NSURL(string:urlStr.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url! as URL)
//        }
//    }
//}
