//
//  THBaseNetworkManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import Alamofire
import YYModel

let BASEURL = "http://qiuzhi.cool"//"http://ball.moonsky.cn"

typealias successHandler = (_ response: Any)->()
typealias errorHandler = (_ error: Error)->()

@objcMembers
class ResponseModel: NSObject{
    
    var code: Int = 0
    var data: Any?
    var message: String?
    var status: Int = 0
    
}

class THBaseNetworkManager: NSObject {
    
    var subUrl: String = ""
    
    var successCompletion : successHandler?
    var failureCompletion : errorHandler?
    
    /// 构造请求头
    lazy var header: HTTPHeaders = {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        let usrModel = THLoginController.instance.getTokenInfo()
        let header = HTTPHeaders(dictionaryLiteral:("version", version), ("clientDeviceId", deviceId!), ("token", usrModel.token), ("uid", usrModel.uid))
        return header
    }()
    
    var commonParam: [String: Any] = {
        var param = [String: Any]()
        let userModel = THLoginController.instance.getTokenInfo()
        if userModel.uid != "" {
            param["uid"] = userModel.uid
        }
        if userModel.token != "" {
            param["token"] = userModel.token
        }
        return param
    }()
    
    let requestContentType: [String] = ["application/json", "text/json", "text/javascript", "text/html", "text/plain"]
    
    class func shared(subUrl: String) -> THBaseNetworkManager {
        
        let tools = THBaseNetworkManager()
        tools.subUrl = subUrl
        return tools
    }
}

extension THBaseNetworkManager {
    
    func handleRequestResponse(respose: ResponseModel) {
        if respose.code == 200 {
            successCompletion?(respose.data as Any)
        } else {
            let error = NSError(domain: "", code: respose.code, userInfo: [NSLocalizedDescriptionKey: respose.message ?? ""])
            failureCompletion?(error)
        }
    }
}

extension THBaseNetworkManager {
    
    //MARK: - GET 请求
    func getRequest(params: [String : Any]? = nil, successBlock: successHandler? = nil, errorBlock: errorHandler? = nil) {
        
        successCompletion = successBlock
        failureCompletion = errorBlock

        let urlString = BASEURL + self.subUrl
        var param = commonParam
        if let dict = params {
            for (key, value) in dict {
                param[key] = value
            }
        }
        
        //使用Alamofire进行网络请求时，调用该方法的参数都是通过getRequest(urlString， params, success :, failture :）传入的，而success传入的其实是一个接受[String : AnyObject]类型 返回void类型的函数
        Alamofire.request(urlString,
                          method: .get,
                          parameters: param,
                          encoding: URLEncoding.default,
                          headers: header)
            .validate(contentType: requestContentType)
            .responseJSON { (response) in
               
                switch response.result {
                    case .success(let value):
                        print(value)
                        guard let data = ResponseModel.yy_model(withJSON: value) else { return }
                        self.handleRequestResponse(respose: data)
                        break
                       
                    case .failure(let error):
                        print(error)
                        errorBlock?(error)
                        break
                }
        }
    }

    //MARK: - POST 请求
    func postRequest(params: [String : Any]? = nil, successBlock: successHandler? = nil, errorBlock: errorHandler? = nil) {
       
        successCompletion = successBlock
        failureCompletion = errorBlock

        let urlString = BASEURL + self.subUrl
        var param = commonParam
        if let dict = params {
            for (key, value) in dict {
                param[key] = value
            }
        }
        Alamofire.request(urlString,
                          method: .post,
                          parameters: param,
                          encoding: URLEncoding.default,
                          headers: header)
            .validate(contentType: requestContentType)
            .responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                       print(value)
                       guard let data = ResponseModel.mj_object(withKeyValues: value) else { return }
                       self.handleRequestResponse(respose: data)
                       break
                      
                    case .failure(let error):
                       print(error)
                       errorBlock?(error)
                       break
                }
        }
    }
    
    
    //上传图片到服务器
    func uploadImage(imageData: Data, fileName: String, successBlock: successHandler? = nil, errorBlock: errorHandler? = nil) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            //采用post表单上传
            // 参数解释：
            //withName:和后台服务器的name要一致 fileName:自己随便写，但是图片格式要写对 mimeType：规定的，要上传其他格式可以自行百度查一下
            multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
            //如果需要上传多个文件,就多添加几个
            //multipartFormData.append(imageData, withName: "file", fileName: "123456.jpg", mimeType: "image/jpeg")
            //......
            
        }, to: "") { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { (response: DataResponse<Any>) in
                    //解包
                    guard let result = response.result.value else { return }
                    print("\(result)")
                    //须导入 swiftyJSON 第三方框架，否则报错
//                    let success = JSON(result)["success"].int ?? -1
//                    if success == 1 {
//                        print("上传成功")
//                    }else{
//                        print("上传失败")
//                    }
                }
                
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("图片上传进度: \(progress.fractionCompleted)")
                }
                break
            case .failure(let error):
                print("图片上传失败: \(error)")
                break
            @unknown default:
                break
            }
        }
    }
    
    
    
    //上传视频到服务器
    func uploadVideo(videoPath: URL, fileName: String, successBlock: successHandler? = nil, errorBlock: errorHandler? = nil) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            //采用post表单上传
            multipartFormData.append(videoPath, withName: "file", fileName: fileName, mimeType: "video/mp4")
            
        }, to: "") { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { (response: DataResponse<Any>) in
                    //解包
                    guard let result = response.result.value else { return }
                    print("\(result)")
                    //须导入 swiftyJSON 第三方框架，否则报错
//                    let success = JSON(result)["success"].int ?? -1
//                    if success == 1 {
//                        print("上传成功")
//                    }else{
//                        print("上传失败")
//                    }
                }
                
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("视频上传进度: \(progress.fractionCompleted)")
                }
                break
            case .failure(let error):
                print("视频上传失败: \(error)")
                break
            @unknown default:
                break
            }
        }
    }
    
}

class THReachability: NSObject {
    
    static let INSTANCE = THReachability()
    
    let net = NetworkReachabilityManager()
    
    override init() {
        super.init()
    }
    
    func startListening() {
        net?.listener = { status in
            
            NotificationCenter.default.post(name: NSNotification.Name(kAppNetChangeNotificationName), object: nil)
            
            if self.net?.isReachable ?? false {
                switch status{
                case .notReachable:
                    print("Reachability: the noework is not reachable")
                case .unknown:
                    print("ReachabilityIt: is unknown whether the network is reachable")
                case .reachable(.ethernetOrWiFi):
                    print("Reachability: 通过WiFi链接")
                case .reachable(.wwan):
                    print("Reachability: 通过移动网络链接")
                }
            } else {
                print("Reachability: 网络不可用")
            }
        }
        net?.startListening()
    }
}
