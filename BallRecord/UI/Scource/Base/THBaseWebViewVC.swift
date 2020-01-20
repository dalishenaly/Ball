//
//  THBaseWebViewVC.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/2.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit
import WebKit

class THBaseWebViewVC: THBaseVC {
    
    // MARK: - Lazy
    // mainWebView
    lazy var mainWebView: WKWebView = {
        let mainWebView = WKWebView()
        mainWebView.navigationDelegate = self
        mainWebView.uiDelegate = self
        return mainWebView
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2))
        progressBar.progress = 0.0
        progressBar.alpha = 0
        progressBar.progressTintColor = MAIN_COLOR
        return progressBar
    }()
    
    
    var currentUrlStr: String = ""          // 当前范围的请求url
    var navTitle: String = ""               // 目前用于处理文章详情的固定title
    
    
    // MARK: - LifeCycle
    init(urlString: String) {
        
        currentUrlStr = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.configureFrame()
        self.configureData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.mainWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        self.mainWebView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.progressBar.alpha = 0
        self.mainWebView.stopLoading()
        self.mainWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.mainWebView.removeObserver(self, forKeyPath: "title")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    deinit {
        self.progressBar.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 返回
    override func goBackItemClicked() {
        if self.mainWebView.canGoBack {
            self.mainWebView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - Configure
extension THBaseWebViewVC {
    func configureUI() {
        if navTitle != "" {
            self.title = navTitle
        }
        
        view.addSubview(mainWebView)
        view.addSubview(progressBar)
        
    }
    
    func configureFrame() {
        
        mainWebView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func configureData() {
         self.loadUrl(urlString: self.currentUrlStr)
    }
}

// MARK: - Method
extension THBaseWebViewVC {
    
    // loadURL
    func loadUrl(urlString: String) {
        let urlStr: String = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlStr)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30.0)

        self.mainWebView.load(request as URLRequest)
    }
}



// MARK: - observeValue
extension THBaseWebViewVC {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            
            progressBar.alpha = 1.0
            progressBar.setProgress(Float(mainWebView.estimatedProgress), animated: true)
            
            //进度条的值最大为1.0
            if(self.mainWebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                    self.progressBar.alpha = 0.0
                    
                }, completion: { (finished:Bool) -> Void in
                    self.progressBar.progress = 0
                })
            }
        } else if (keyPath == "title"){
            if (object as? WKWebView == self.mainWebView) {
                if navTitle == "" {
                    self.navigationItem.title = self.mainWebView.title;
                }
            }else{
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
}


// MARK: - WKUIDelegate, WKNavigationDelegate
extension THBaseWebViewVC: WKUIDelegate, WKNavigationDelegate {
    // WKWebView创建初始化加载的一些配置
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        // 如果是跳转一个新页面
        if (navigationAction.targetFrame?.isMainFrame == nil) {
            webView.load(navigationAction.request)
        }
        
        return nil;
    }
    
    // iOS9.0中新加入的,处理WKWebView关闭的时间
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    // 处理网页js中的提示框,若不使用该方法,则提示框无效
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
       
    }
    
    // 处理网页js中的确认框,若不使用该方法,则确认框无效
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    // 处理网页js中的文本输入
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    
    // WKNavigationDelegate
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestURLStr: String = (navigationAction.request.url?.absoluteString)!
        if navTitle == "" {
            self.navigationItem.title = webView.title
        }
               
        self.currentUrlStr = requestURLStr
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
    
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }
    
    // 处理网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if webView.title != nil && !(webView.title?.isEmpty)! && navTitle == "" {
            self.navigationItem.title = webView.title
        }
    }
    
    // 处理网页加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 处理网页返回内容时发生的失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 处理网页进程终止
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.mainWebView.reload()
    }
    
}
