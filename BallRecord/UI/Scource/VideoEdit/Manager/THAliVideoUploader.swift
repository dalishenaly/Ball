//
//  THAliVideoUploader.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit


@objc protocol THAliVideoUploaderDelegate {
    
    func uploadFinishCallbackFunc(fileInfo: UploadFileInfo?, result: VodUploadResult?, videoId: String?)
    func uploadFailedCallbackFunc(fileInfo: UploadFileInfo?, code: String?, message: String?, videoId: String?)
    func uploadProgressCallbackFunc(fileInfo: UploadFileInfo?, uploadedSize: Int, totalSize: Int, videoId: String?)
    func uploadTokenExpiredCallbackFunc(completion: ((_ videoId: String)->Void)?, videoId: String?)

}


class THAliVideoUploader: NSObject {
    
    weak var delegate: THAliVideoUploaderDelegate?
    
    let uploader = VODUploadClient()
    var videoId: String?
    
    static let instance = THAliVideoUploader()
    
    override init() {
        super.init()
        
    }
    
    func uploadFile(filePath: String, uploadAuth: String, uploadAddress: String, videoId: String) {
        self.videoId = videoId
        /// 上传完成回调
        let FinishCallbackFunc: OnUploadFinishedListener = {fileInfo, result in
            self.delegate?.uploadFinishCallbackFunc(fileInfo: fileInfo, result: result, videoId: self.videoId)
        }
        
        /// 上传失败回调
        let FailedCallbackFunc: OnUploadFailedListener = {fileInfo, code, message in
            self.delegate?.uploadFailedCallbackFunc(fileInfo: fileInfo, code: code, message: message, videoId: self.videoId)
        }
        /// 上传进度回调
        let ProgressCallbackFunc: OnUploadProgressListener = {fileInfo, uploadedSize, totalSize in
            self.delegate?.uploadProgressCallbackFunc(fileInfo: fileInfo, uploadedSize: uploadedSize, totalSize: totalSize, videoId: self.videoId)
        }
        
        /// token过期
        let TokenExpiredCallbackFunc: OnUploadTokenExpiredListener = {
            // token过期，设置新的上传凭证，继续上传
            self.delegate?.uploadTokenExpiredCallbackFunc(completion: { (auth) in
                self.uploader.resume(withAuth: auth)
            }, videoId: self.videoId)
        }
        
        /// 上传开始重试回调
        let RetryCallbackFunc: OnUploadRertyListener = {
            
        }
        
        /// 上传结束重试，继续上传回调
        let RetryResumeCallbackFunc: OnUploadRertyResumeListener = {
            print(#function)
        }
        /**
        开始上传回调
        上传地址和凭证方式上传需要调用setUploadAuthAndAddress:uploadAuth:uploadAddress:方法设置上传地址和凭证
        @param fileInfo 上传文件信息
        */
        let UploadStartedCallbackFunc: OnUploadStartedListener = { fileInfo in
            // 设置上传地址 和 上传凭证
            self.uploader.setUploadAuthAndAddress(fileInfo, uploadAuth: uploadAuth, uploadAddress: uploadAddress)
        }
        
        let listener = VODUploadListener()
        listener.finish = FinishCallbackFunc
        listener.failure = FailedCallbackFunc
        listener.progress = ProgressCallbackFunc
        listener.expire = TokenExpiredCallbackFunc
        listener.retry = RetryCallbackFunc
        listener.retryResume = RetryResumeCallbackFunc
        listener.started = UploadStartedCallbackFunc
        uploader.setListener(listener)
        
        
//        let filePath = ""
        let vodInfo = VodInfo()
//        vodInfo.title = ""
//        vodInfo.desc = ""
//        vodInfo.cateId = 19
//        vodInfo.tags = ""
        uploader.addFile(filePath, vodInfo: vodInfo)
        uploader.start()
    }

}
