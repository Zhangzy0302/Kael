import SwiftUI
import WebKit

struct FhHhckauedaWebview: UIViewRepresentable {
    
    let fhHhckauedaWebNav: String
    @EnvironmentObject var navi: KawuxhaFgfNaviManager
    @EnvironmentObject var uejaLIcjagIpa: HglijlkKuxaIAPManager
    @EnvironmentObject var bcjeiLAcxiaUserVM: PwixzLkciemUserViewModel
    
    static weak var currentWebView: WKWebView?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, navi: navi, ipaRecharge: uejaLIcjagIpa, userVM: bcjeiLAcxiaUserVM)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let contentController = WKUserContentController()
        
        // ✅ 按文档注册事件
        let handlers = [
            "userListUpdate",
            "postsUpdate",
            "commentsUpdate",
            "chatsUpdate",
            "messagesUpdate",
            "close",
            "logout",
            "payment"
        ]
        
        handlers.forEach {
            contentController.add(context.coordinator, name: $0)
        }
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        
        // ✅ 注入 JS 数据
        let js = context.coordinator.generateInitialJS()
//        print(js)
        let script = WKUserScript(
            source: js,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        contentController.addUserScript(script)
        
        let fhHuhckauedaWebView = WKWebView(frame: .zero, configuration: config)
        
        fhHuhckauedaWebView.uiDelegate = context.coordinator
        fhHuhckauedaWebView.navigationDelegate = context.coordinator
        fhHuhckauedaWebView.isOpaque = false
        fhHuhckauedaWebView.backgroundColor = .clear
        fhHuhckauedaWebView.scrollView.backgroundColor = .clear
        fhHuhckauedaWebView.scrollView.contentInsetAdjustmentBehavior = .never
        fhHuhckauedaWebView.scrollView.contentInset = .zero
        fhHuhckauedaWebView.scrollView.isScrollEnabled = false
        fhHuhckauedaWebView.scrollView.scrollIndicatorInsets = .zero
        fhHuhckauedaWebView.allowsBackForwardNavigationGestures = true
        
        FhHhckauedaWebview.currentWebView = fhHuhckauedaWebView
        
        let url = URL(string: "https://app.fbspecck.link/\(fhHhckauedaWebNav)")!
        fhHuhckauedaWebView.load(URLRequest(url: url))
        
        return fhHuhckauedaWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
}

@MainActor
class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    
    // MARK: - Dependencies
    private let storage = KaelIwuzHacStorageManager.shared
    
    var parent: FhHhckauedaWebview
    var navi: KawuxhaFgfNaviManager
    var ipaRecharge: HglijlkKuxaIAPManager
    var userVM: PwixzLkciemUserViewModel
    
    // MARK: - Init
    init(_ parent: FhHhckauedaWebview,
         navi: KawuxhaFgfNaviManager,
         ipaRecharge: HglijlkKuxaIAPManager,
         userVM: PwixzLkciemUserViewModel) {
        
        self.parent = parent
        self.navi = navi
        self.ipaRecharge = ipaRecharge
        self.userVM = userVM
    }
    
    // MARK: - 权限（自动允许）
    func webView(
        _ fhHuhckauedaWebView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }
    
    func webView(_ fhHuhckauedaWebView: WKWebView, didFinish navigation: WKNavigation!) {
        
        fhHuhckauedaWebView.evaluateJavaScript("window.currentUser") { result, error in
//            print("🧪 currentUser:", result ?? "nil")
        }
    }
    
    // MARK: - Web -> Native 入口
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        guard let action = WebAction(rawValue: message.name) else {
            print("❌ 未知事件:", message.name)
            return
        }
        
        handle(action: action, body: message.body)
    }
}

// MARK: - Action Enum
extension Coordinator {
    
    enum WebAction: String {
        case close
        case userListUpdate
        case postsUpdate
        case commentsUpdate
        case chatsUpdate
        case messagesUpdate
        case logout
        case payment
    }
}

// MARK: - Action Dispatcher
extension Coordinator {
    
    private func handle(action: WebAction, body: Any) {
        switch action {
        case .close:
            handleClose()
            
        case .userListUpdate:
            handleUserUpdate(body)
            
        case .postsUpdate:
            handlePostUpdate(body)
            
        case .commentsUpdate:
            handleCommentUpdate(body)
            
        case .chatsUpdate:
            handleChatUpdate(body)
            
        case .messagesUpdate:
            handleMessageUpdate(body)
            
        case .logout:
            handleLogout(body)
            
        case .payment:
            handlePayment(body)
        }
    }
}

// MARK: - Actions
extension Coordinator {
    
    private func handleClose() {
        navi.pop()
    }
    
    private func handleUserUpdate(_ body: Any) {
        guard let users = extractArray(body, key: "users") else { return }
        storage.saveUsers(PwixzLkciemUser.fromJsonArray(users))
    }
    
    private func handlePostUpdate(_ body: Any) {
        guard let posts = extractArray(body, key: "posts") else { return }
        storage.saveWorks(RwyclaHurgrVideo.fromJsonArray(posts))
    }
    
    private func handleCommentUpdate(_ body: Any) {
        guard let comments = extractArray(body, key: "comments") else { return }
        storage.saveComments(NauxuJFeComment.fromJsonArray(comments))
    }
    
    private func handleChatUpdate(_ body: Any) {
        guard let chats = extractArray(body, key: "chats") else { return }
        storage.saveChatRooms(MxhwiUAhxgswChatRoom.fromJsonArray(chats))
    }
    
    private func handleMessageUpdate(_ body: Any) {
        guard let messages = extractArray(body, key: "messages") else { return }
        storage.saveChatMessageList(MxhwiUAhxgswMessage.fromJsonArray(messages))
    }
    
    private func handleLogout(_ body: Any) {
        guard let dict = body as? [String: Any],
              let isLogout = dict["isLogout"] as? Bool else {
            print("logout 数据错误")
            return
        }
        
        if isLogout {
            // TODO: 删除账号逻辑
            
            userVM.deleteAccountPwixzLkciem()
            print("delete")
        } else {
            print("logout")
            storage.setCurrentUserId("95959")
            userVM.loadLoginPwixzLkciemUser()
        }
        
        navi.popToRoot()
    }
    
    private func handlePayment(_ body: Any) {
        guard let dict = body as? [String: Any],
              let payKey = dict["payKey"] as? String else {
            print("payment 数据错误")
            return
        }
        
        startIAP(payKey: payKey)
    }
}

// MARK: - IAP
extension Coordinator {
    
    /// 同步当前用户到 H5
        func syncCurrentUserToH5() {
            guard let currentUser = storage.getUserById(userId: storage.getCurrentUserId()) else {
                print("❌ 当前用户为空，无法同步到 H5")
                return
            }
            
            // 转成 H5 需要的 TargetUser JSON
            let targetUser = currentUser.toTargetUser()
            let userJSON = encode(targetUser, defaultValue: "{}")
            
            // 转义 \ 和 "
            let escapedJSON = userJSON
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "\"", with: "\\\"")
            
            // JS 调用 updateCurrentUser(JSON)
            let js = "updateCurrentUser(JSON.parse(\"\(escapedJSON)\"));"
            print("🔹 同步 JS:", js)
            
            DispatchQueue.main.async {
                if let fhHuhckauedaWebView = FhHhckauedaWebview.currentWebView {
                    fhHuhckauedaWebView.evaluateJavaScript(js) { result, error in
                        if let error = error {
                            print("❌ 同步当前用户到 H5 出错:", error.localizedDescription)
                        } else {
                            print("✅ 当前用户信息同步到 H5 成功")
                        }
                    }
                } else {
                    print("❌ WebView 尚未创建，无法同步 H5")
                }
            }
        }
    
    private func startIAP(payKey: String) {
        ipaRecharge.xnswALjhwieRecharge(payKey) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let diamond):
                self.userVM.increaseUserDiamond(diamond: diamond)
                self.userVM.loadLoginPwixzLkciemUser()
                syncCurrentUserToH5()
                                            
            case .failed(let msg):
                TuxaliFvswlaHUD.toast(.error(msg))
                
            case .cancelled, .pending:
                break
            }
        }
    }
}

// MARK: - JSON Helpers
extension Coordinator {
    
    /// 通用数组解析
    private func extractArray(_ body: Any, key: String) -> [[String: Any]]? {
        guard let dict = body as? [String: Any],
              let array = dict[key] as? [[String: Any]] else {
            print("❌ \(key) 数据错误:", body)
            return nil
        }
        return array
    }
    
    /// 通用编码
    private func encode<T: Encodable>(_ obj: T, defaultValue: String = "[]") -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // 👈 先加这个
        
        guard let data = try? encoder.encode(obj),
              let json = String(data: data, encoding: .utf8) else {
            return defaultValue
        }
        return json
    }
}

// MARK: - JS 注入
extension Coordinator {
    
    func generateInitialJS() -> String {
        
        let currentUser = storage.getUserById(userId: storage.getCurrentUserId())
        
        let currentUserJSON = currentUser
            .map { encode($0.toTargetUser(), defaultValue: "{}") }
            ?? "{}"
        
        return """
        try {
            window.currentUser = JSON.parse('\(escapeForJS(currentUserJSON))');
            window.userList = JSON.parse('\(escapeForJS(encode(storage.getUsers().map { $0.toTargetUser() })))');
            window.postList = JSON.parse('\(escapeForJS(encode(storage.getWorks().map { $0.toTargetPost() })))');
            window.commentList = JSON.parse('\(escapeForJS(encode(storage.getAllComments().map { $0.toTargetComment() })))');
            window.chatList = JSON.parse('\(escapeForJS(encode(storage.getChatRooms().map { $0.toTargetChatRoom() })))');
            window.messageList = JSON.parse('\(escapeForJS(encode(storage.getAllMessages().map { $0.toTargetMessage() })))');
            window.other = \(buildOtherConfig());
        } catch(e) {
            console.error("❌ 注入失败:", e);
        }
        """
    }
    
    func escapeForJS(_ json: String) -> String {
        return json
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
    }
    
    private func buildOtherConfig() -> String {
        
        let obj: [String: Any] = [
            "postTheme": ["Hobbies","Inspire"],
            "reportContent": [
                "Harassment",
                "Malicious fraud",
                "Pornography",
                "Malicious insults",
                "False Information"
            ],
            "coinsSetting": eoquaAfporjxuwProducts.map {
                [
                    "key": $0.wisxaHRjeUfrKeyId,
                    "cions": $0.wisxaHRjeUfrGetDiamond,
                    "money": $0.wisxaHRjeUfrPrice
                ]
            }
        ]
        
        let json = encodeAny(obj) // 👇 需要这个方法
        
        return "JSON.parse('\(escapeForJS(json))')"
    }
    
    func encodeAny(_ obj: Any) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: obj),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }
}

struct FhHhckauedaWeb: View {
    let aswuznaWebUrlString: String
    
    var body: some View {
        ZStack{
            KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()
            FhHhckauedaWebview(fhHhckauedaWebNav: aswuznaWebUrlString)
                .ignoresSafeArea()
        }.ignoresSafeArea()
            .navigationBarHidden(true)
                .background(VhuaGehuSwipeBack())
    }
}
