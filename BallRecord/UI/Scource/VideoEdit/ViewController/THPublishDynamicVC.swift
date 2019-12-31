//
//  THPublishDynamicVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/13.
//  Copyright © 2019 maichao. All rights reserved.
//

import QMUIKit

class THPublishDynamicVC: THBaseVC {
    
    var draftModel: THVideoDraftModel?
    var editVideoPath: String?  //  合成视频所储存的路径
    var draftId: String?    //  草稿id
    
    var uploader: VODUploadClient?
    
    let textView = QMUITextView()
    lazy var coverView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    lazy var imgBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "shipin_icon")
        return imgV
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:10"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("发布", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
        
        configUploader()
    }

}

extension THPublishDynamicVC {
    
    func configUI() {
        
        title = "发布"
        view.addSubview(textView)
        view.addSubview(coverView)
        view.addSubview(publishBtn)
        
        coverView.addSubview(imgBottomView)
        imgBottomView.addSubview(iconView)
        imgBottomView.addSubview(timeLabel)
        
        textView.placeholder = "添加你此刻的想法吧（最多100字）"
        textView.maximumTextLength = 100
        textView.font = UIFont.systemFont(ofSize: 16)
    }
    
    func configFrame() {
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(110)
        }
        
        coverView.snp.makeConstraints { (make) in
            make.left.equalTo(textView)
            make.top.equalTo(textView.snp_bottom).offset(15)
            make.height.equalTo(60)
            make.width.equalTo(coverView.snp_height).multipliedBy(1.5)
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(coverView.snp_bottom).offset(70)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
        
        imgBottomView.snp.makeConstraints { (make) in
            make.left.equalTo(coverView)
            make.right.equalTo(coverView)
            make.bottom.equalTo(coverView)
            make.height.equalTo(15)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(imgBottomView).offset(3)
            make.centerY.equalTo(imgBottomView)
            make.width.height.equalTo(14)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.right.equalTo(imgBottomView)
            make.top.bottom.equalTo(imgBottomView)
        }
        
        textView.setCorner(cornerRadius: 4)
        coverView.setCorner(cornerRadius: 4)
        publishBtn.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
        if let videoPath = self.editVideoPath {
            let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
            let duration = Int(CMTimeGetSeconds(asset.duration))
            timeLabel.text = getMMSSFromSS(totalTime: duration)
            coverView.image = THVideoEditController.getVideoCoverImage(url: videoPath)
        }
    }
    
    func configUploader() {
        
        uploader = VODUploadClient()
        
        /// 上传完成回调
        let FinishCallbackFunc: OnUploadFinishedListener = {fileInfo, result in
            
        }
        
        /// 上传失败回调
        let FailedCallbackFunc: OnUploadFailedListener = {fileInfo, code, message in
            
        }
        
        /// 上传进度回调
        let ProgressCallbackFunc: OnUploadProgressListener = {fileInfo, uploadedSize, totalSize in
            
        }
        
        /// token过期
        let TokenExpiredCallbackFunc: OnUploadTokenExpiredListener = {
            // token过期，设置新的上传凭证，继续上传
            self.uploader?.resume(withAuth: "")
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
            self.uploader?.setUploadAuthAndAddress(fileInfo, uploadAuth: "", uploadAddress: "")
        }
        
        let listener = VODUploadListener()
        listener.finish = FinishCallbackFunc
        listener.failure = FailedCallbackFunc
        listener.progress = ProgressCallbackFunc
        listener.expire = TokenExpiredCallbackFunc
        listener.retry = RetryCallbackFunc
        listener.retryResume = RetryResumeCallbackFunc
        listener.started = UploadStartedCallbackFunc
        uploader?.setListener(listener)
    }
    
    func uploadCover() {
        let filePath = ""
        let imageInfo = VodInfo()
        imageInfo.title = ""
        imageInfo.desc = ""
        imageInfo.cateId = 19
        imageInfo.tags = ""
        uploader?.addFile(filePath, vodInfo: imageInfo)
    }
    
    func uploadVideo() {
        
        let filePath = ""
        let vodInfo = VodInfo()
        vodInfo.title = ""
        vodInfo.desc = ""
        vodInfo.cateId = 19
        vodInfo.tags = ""
        uploader?.addFile(filePath, vodInfo: vodInfo)
    }
    
    
    func getMMSSFromSS(totalTime: Int) -> String {
        let minStr = NSString(format: "%02ld", totalTime%3600/60)
        let secondStr = NSString(format: "%02ld", totalTime%60)
        return NSString(format: "%@:%@", minStr, secondStr) as String
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        //  发布成功删除草稿
        THVideoDraftModel.removeDraft(draftId: draftId ?? "")
    }
    
    func publish() {
        
        uploadCover()
        uploadVideo()
        
        uploader?.start()
    }
}
