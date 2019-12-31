//
//  THMusicCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THMusicCell: UITableViewCell {
    
    var model: musicModel?
    var hasDownload: Bool = false
    var reloadBlock: (()->Void)?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "音乐"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "已下载"
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var downloadBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "music_download_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configUI() {
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(downloadBtn)
    }
    
    func configFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(titleLabel)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(30)
        }
        
        downloadBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(downloadBtn)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(detailLabel)
        }
    }
    
    func configData() {
        
    }
    
    func updateModel(model: musicModel) {
        
        self.model = model
        titleLabel.text = model.titleName
        
        if let musicUrl = URL(string: model.url) {
            let musicPath = DownloadBgmPath + "/" + musicUrl.lastPathComponent
            
            downloadBtn.isHidden = musicPath.filePathExists()
            detailLabel.isHidden = !musicPath.filePathExists()
            self.model?.hasDownload = musicPath.filePathExists()
            self.model?.musicTempPath = musicPath
        }
    }

    @objc func clickButtonEvent(sender: UIButton) {

        QMUITips.showLoading(in: UIApplication.shared.keyWindow!)
        THVideoEditController.downloadMusic(url: "http://qiniunstatic.reee.cn/backgroundMusic/reee/ECBF734800084A49A62168C70FBCA77B.mp3") { (savePath: String) in
            QMUITips.hideAllTips()
            self.model?.hasDownload = true
            self.model?.musicTempPath = savePath
            self.reloadBlock?()
        }
    }
    
    func updateSeletStatus(selected: Bool) {
        if self.model?.hasDownload ?? false {
            titleLabel.textColor = selected ? MAIN_COLOR : COLOR_999999
            detailLabel.textColor = selected ? MAIN_COLOR : COLOR_999999
        }
    }
}
