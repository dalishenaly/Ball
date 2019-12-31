//
//  THAliVideoUploader.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THAliVideoUploader: NSObject {
    
    class func uploadFile(filePath: String, finishBlock: @escaping OnUploadFinishedListener, processBlock: @escaping OnUploadProgressListener, failedBlock: @escaping OnUploadFailedListener) {
        
        let uploader = VODUploadClient()
        
        /// 上传完成回调
        let FinishCallbackFunc: OnUploadFinishedListener = finishBlock
        
        /// 上传失败回调
        let FailedCallbackFunc: OnUploadFailedListener = failedBlock
        
        /// 上传进度回调
        let ProgressCallbackFunc: OnUploadProgressListener = processBlock
        
        /// token过期
        let TokenExpiredCallbackFunc: OnUploadTokenExpiredListener = {
            // token过期，设置新的上传凭证，继续上传
            uploader.resume(withAuth: "")
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
            uploader.setUploadAuthAndAddress(fileInfo, uploadAuth: "", uploadAddress: "")
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
        
        
        let filePath = ""
        let imageInfo = VodInfo()
        imageInfo.title = ""
        imageInfo.desc = ""
        imageInfo.cateId = 19
        imageInfo.tags = ""
        uploader.addFile(filePath, vodInfo: imageInfo)
        uploader.start()
    }

}
