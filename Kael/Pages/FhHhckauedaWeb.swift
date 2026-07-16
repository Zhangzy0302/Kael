import SwiftUI
import WebKit

enum KaelWebWarmPool {
    private static var cachedView: WKWebView?
    private static var didStart = false

    static func prepareOnce() {
        guard !didStart else { return }
        didStart = true

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
            view.loadHTMLString("<!doctype html><title></title>", baseURL: nil)
            cachedView = view
        }
    }
}

private enum KaelH5JSON {
    static func stringify<T: Encodable>(_ value: T, fallback: String = "[]") -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(value),
              let output = String(data: data, encoding: .utf8) else {
            return fallback
        }
        return output
    }

    static func quotedForSingleQuoteJS(_ json: String) -> String {
        json
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
    }
}

private struct KaelBridgeSnapshot {
    private let storage = KaelIwuzHacStorageManager.shared

    func fullHydrationScript() -> String {
        let currentUser = storage.getUserById(userId: storage.getCurrentUserId())
        let values: [(name: String, json: String)] = [
            ("currentUser", currentUser.map { KaelH5JSON.stringify($0.toTargetUser(), fallback: "{}") } ?? "{}"),
            ("userList", KaelH5JSON.stringify(storage.getUsers().map { $0.toTargetUser() })),
            ("postList", KaelH5JSON.stringify(storage.getWorks().map { $0.toTargetPost() })),
            ("commentList", KaelH5JSON.stringify(storage.getAllComments().map { $0.toTargetComment() })),
            ("chatList", KaelH5JSON.stringify(storage.getChatRooms().map { $0.toTargetChatRoom() })),
            ("messageList", KaelH5JSON.stringify(storage.getAllMessages().map { $0.toTargetMessage() }))
        ]
        let assignments = values.map { item in
            "window.\(item.name) = JSON.parse('\(KaelH5JSON.quotedForSingleQuoteJS(item.json))');"
        }.joined(separator: "\n            ")
        let detail = values.map { "\($0.name): window.\($0.name)" }.joined(separator: ", ")

        return """
        (() => {
            try {
                \(assignments)
                window.__kaelNativeDataReady = true;
                window.dispatchEvent(new CustomEvent('nativeDataReady', { detail: { \(detail) } }));
            } catch (error) {
                console.error("Kael native data sync failed:", error);
            }
        })();
        """
    }
}

private final class KaelStoreCommitBuffer {
    static let shared = KaelStoreCommitBuffer()

    private let queue = DispatchQueue(label: "kael.h5.commit.buffer", qos: .utility)
    private var delayedJobs: [String: DispatchWorkItem] = [:]

    private init() {}

    func replace(key: String, after delay: TimeInterval = 0.25, _ operation: @escaping () -> Void) {
        queue.async {
            self.delayedJobs[key]?.cancel()
            let next = DispatchWorkItem(block: operation)
            self.delayedJobs[key] = next
            self.queue.asyncAfter(deadline: .now() + delay, execute: next)
        }
    }
}

struct FhHhckauedaWebview: UIViewRepresentable {
    
    let fhHhckauedaWebNav: String
    let safeAreaInsets: EdgeInsets
    @Binding var isLoading: Bool
    @EnvironmentObject var navi: KawuxhaFgfNaviManager
    @EnvironmentObject var uejaLIcjagIpa: HglijlkKuxaIAPManager
    @EnvironmentObject var bcjeiLAcxiaUserVM: PwixzLkciemUserViewModel
    
    static weak var currentWebView: WKWebView?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, navi: navi, ipaRecharge: uejaLIcjagIpa, userVM: bcjeiLAcxiaUserVM)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        DispatchQueue.main.async {
            isLoading = true
        }
        
        let contentController = WKUserContentController()
        
        // ✅ 按文档注册事件
        Coordinator.WebAction.allCases.forEach { action in
            contentController.add(context.coordinator, name: action.rawValue)
        }
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        
        // ✅ 先注入轻量基础数据，完整列表在页面进入后异步注入
        let js = context.coordinator.generateBootstrapJS()
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
        context.coordinator.loadInitialPage(in: fhHuhckauedaWebView, url: url)
        
        let coordinator = context.coordinator
        DispatchQueue.global(qos: .userInitiated).async {
            let dataSyncJS = KaelBridgeSnapshot().fullHydrationScript()
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    coordinator.installDataSyncJS(dataSyncJS, webView: fhHuhckauedaWebView)
                }
            }
        }
        
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
    
    private var pendingDataSyncJS: String?
    private var hasFinishedLoading = false
    private var initialPageRequest: URLRequest?
    private var initialLoadAttempt = 0
    private var initialRetryWorkItem: DispatchWorkItem?
    private let maxInitialLoadAttempts = 3
    
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
        initialRetryWorkItem?.cancel()
        parent.isLoading = false
        hasFinishedLoading = true
        syncSafeAreaToH5(fhHuhckauedaWebView)
        evaluatePendingDataSyncIfNeeded(fhHuhckauedaWebView)
        
        fhHuhckauedaWebView.evaluateJavaScript("window.currentUser") { result, error in
//            print("🧪 currentUser:", result ?? "nil")
        }
    }
    
    func webView(_ fhHuhckauedaWebView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        retryInitialLoadIfNeeded(in: fhHuhckauedaWebView, error: error)
    }
    
    func webView(_ fhHuhckauedaWebView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        retryInitialLoadIfNeeded(in: fhHuhckauedaWebView, error: error)
    }
    
    func loadInitialPage(in webView: WKWebView, url: URL) {
        initialRetryWorkItem?.cancel()
        initialLoadAttempt = 0
        initialPageRequest = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 20
        )
        startInitialLoad(in: webView, bypassCache: false)
    }
    
    func installDataSyncJS(_ js: String, webView: WKWebView) {
        pendingDataSyncJS = js
        evaluatePendingDataSyncIfNeeded(webView)
    }
    
    private func startInitialLoad(in webView: WKWebView, bypassCache: Bool) {
        guard var request = initialPageRequest else { return }
        initialLoadAttempt += 1
        hasFinishedLoading = false
        parent.isLoading = true
        
        if bypassCache {
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }
        
        webView.load(request)
    }
    
    private func retryInitialLoadIfNeeded(in webView: WKWebView, error: Error) {
        guard shouldRetryInitialLoad(after: error) else {
            parent.isLoading = false
            hasFinishedLoading = true
            return
        }
        
        guard initialLoadAttempt < maxInitialLoadAttempts else {
            parent.isLoading = false
            hasFinishedLoading = true
            print("❌ Web 初始化加载失败，已达到最大重试次数:", error.localizedDescription)
            return
        }
        
        initialRetryWorkItem?.cancel()
        let delay = retryDelay(for: initialLoadAttempt)
        let workItem = DispatchWorkItem { [weak webView, weak self] in
            guard let self, let webView else { return }
            print("🔁 Web 初始化加载失败，正在重试第 \(self.initialLoadAttempt + 1) 次")
            self.startInitialLoad(in: webView, bypassCache: true)
        }
        initialRetryWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
    
    private func shouldRetryInitialLoad(after error: Error) -> Bool {
        let nsError = error as NSError
        guard nsError.domain == NSURLErrorDomain else { return true }
        
        switch nsError.code {
        case NSURLErrorCancelled,
             NSURLErrorUnsupportedURL,
             NSURLErrorUserCancelledAuthentication,
             NSURLErrorAppTransportSecurityRequiresSecureConnection:
            return false
        default:
            return true
        }
    }
    
    private func retryDelay(for attempt: Int) -> TimeInterval {
        min(0.5 * pow(2.0, Double(max(0, attempt - 1))), 2.0)
    }
    
    private func syncSafeAreaToH5(_ webView: WKWebView) {
        let js = buildSafeAreaJS()
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("❌ Web 安全区注入失败:", error.localizedDescription)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
    
    private func evaluatePendingDataSyncIfNeeded(_ webView: WKWebView) {
        guard hasFinishedLoading, let js = pendingDataSyncJS else { return }
        pendingDataSyncJS = nil
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("❌ Web 全量数据注入失败:", error.localizedDescription)
            } else {
                print("✅ Web 全量数据注入完成")
            }
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
    
    enum WebAction: String, CaseIterable {
        case close
        case userListUpdate
        case postsUpdate
        case commentsUpdate
        case chatsUpdate
        case messagesUpdate
        case logout
        case payment
        case newUserData
        case showLoading
        case showToast
        case toLogin
        case requestNativeData
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
            
        case .newUserData:
            handleNewUserData(body)
            
        case .showLoading:
            handleShowLoading(body)
            
        case .showToast:
            handleShowToast(body)
            
        case .toLogin:
            handleToLogin()
            
        case .requestNativeData:
            handleRequestNativeData()
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
        let newUsers = PwixzLkciemUser.fromJsonArray(users)
        storage.saveUsers(newUsers)
        userVM.loadLoginPwixzLkciemUser()
    }
    
    private func handlePostUpdate(_ body: Any) {
        guard let posts = extractArray(body, key: "posts") else { return }
        let newPosts = RwyclaHurgrVideo.fromJsonArray(posts)
        KaelStoreCommitBuffer.shared.replace(key: "posts") {
            KaelIwuzHacStorageManager.shared.saveWorks(newPosts)
        }
    }
    
    private func handleCommentUpdate(_ body: Any) {
        guard let comments = extractArray(body, key: "comments") else { return }
        let newComments = NauxuJFeComment.fromJsonArray(comments)
        KaelStoreCommitBuffer.shared.replace(key: "comments") {
            KaelIwuzHacStorageManager.shared.saveComments(newComments)
        }
    }
    
    private func handleChatUpdate(_ body: Any) {
        guard let chats = extractArray(body, key: "chats") else { return }
        let newChats = MxhwiUAhxgswChatRoom.fromJsonArray(chats)
        KaelStoreCommitBuffer.shared.replace(key: "chats") {
            KaelIwuzHacStorageManager.shared.saveChatRooms(newChats)
        }
    }
    
    private func handleMessageUpdate(_ body: Any) {
        guard let messages = extractArray(body, key: "messages") else { return }
        let newMessages = MxhwiUAhxgswMessage.fromJsonArray(messages)
        KaelStoreCommitBuffer.shared.replace(key: "messages") {
            KaelIwuzHacStorageManager.shared.saveChatMessageList(newMessages)
        }
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
    
    private func handleNewUserData(_ body: Any) {
        guard let dict = body as? [String: Any],
              let userData = dict["newUserData"] as? [String: Any] else {
            print("newUserData 数据错误:", body)
            return
        }
        
        let email = stringValue(from: userData, key: "email") ?? registerQueryValue(for: "email")
        let password = stringValue(from: userData, key: "password") ?? registerQueryValue(for: "password")
        
        guard let email, !email.isEmpty,
              let password, !password.isEmpty else {
            TuxaliFvswlaHUD.toast(.error("Input is required"))
            return
        }
        
        guard storage.getUsers().first(where: { $0.pwixzLkciemEmail == email }) == nil else {
            TuxaliFvswlaHUD.toast(.error("Email already exists"))
            return
        }
        
        TuxaliFvswlaHUD.showLoading()
        navi.popToRoot()
        
        guard let registeredUser = userVM.registerPwixzLkciem(email: email, password: password) else {
            TuxaliFvswlaHUD.hideLoading()
            TuxaliFvswlaHUD.toast(.error("Email already exists"))
            return
        }
        
        let name = stringValue(from: userData, key: "name")
        let avatar = stringValue(from: userData, key: "avator") ?? stringValue(from: userData, key: "avatar")
        if let name, !name.isEmpty {
            let finalAvatar = (avatar?.isEmpty == false) ? avatar! : registeredUser.pwixzLkciemAvatar
            userVM.editPwixzLkciemUserInfo(name: name, avatar: finalAvatar)
        }
        
        TuxaliFvswlaHUD.hideLoading()
    }
    
    private func handleShowLoading(_ body: Any) {
        guard let dict = body as? [String: Any],
              let isShow = dict["isShow"] as? Bool else {
            print("showLoading 数据错误:", body)
            return
        }
        
        if isShow {
            TuxaliFvswlaHUD.showLoading()
        } else {
            TuxaliFvswlaHUD.hideLoading()
        }
    }
    
    private func handleShowToast(_ body: Any) {
        guard let dict = body as? [String: Any],
              let toastMsg = dict["toastMsg"] as? String else {
            print("showToast 数据错误:", body)
            return
        }
        
        TuxaliFvswlaHUD.toast(.error(toastMsg))
    }
    
    private func handleToLogin() {
        userVM.logoutPwixzLkciem()
        navi.popToRoot()
    }
    
    private func handleRequestNativeData() {
        let js = KaelBridgeSnapshot().fullHydrationScript()
        if let webView = FhHhckauedaWebview.currentWebView {
            installDataSyncJS(js, webView: webView)
        } else {
            pendingDataSyncJS = js
        }
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
    
    private func stringValue(from dict: [String: Any], key: String) -> String? {
        dict[key] as? String
    }
    
    private func registerQueryValue(for key: String) -> String? {
        let path = parent.fhHhckauedaWebNav
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        guard let components = URLComponents(string: "https://kael.local\(normalizedPath)") else {
            return nil
        }
        return components.queryItems?.first(where: { $0.name == key })?.value
    }
}

// MARK: - JS 注入
extension Coordinator {
    
    func generateBootstrapJS() -> String {
        let currentUser = storage.getUserById(userId: storage.getCurrentUserId())
        let currentUserJSON = currentUser
            .map { encode($0.toTargetUser(), defaultValue: "{}") }
            ?? "{}"
        let shellLists = ["userList", "postList", "commentList", "chatList", "messageList"]
            .map { "window.\($0) = [];" }
            .joined(separator: "\n            ")
        
        return """
        (() => {
            try {
                window.__kaelNativeDataReady = false;
                window.currentUser = JSON.parse('\(escapeForJS(currentUserJSON))');
                \(shellLists)
                window.other = \(buildOtherConfig());
                \(buildSafeAreaJS())
            } catch (error) {
                console.error("Kael bootstrap failed:", error);
            }
        })();
        """
    }
    
    func buildSafeAreaJS() -> String {
        let insetMap: [(String, CGFloat)] = [
            ("top", parent.safeAreaInsets.top),
            ("bottom", parent.safeAreaInsets.bottom),
            ("left", parent.safeAreaInsets.leading),
            ("right", parent.safeAreaInsets.trailing)
        ]
        let objectBody = insetMap
            .map { "\($0.0): \(max(0, $0.1))" }
            .joined(separator: ", ")
        
        return """
        (function() {
            const insets = { \(objectBody) };
            window.kaelSafeAreaInsets = insets;
            window.nativeSafeAreaInsets = insets;
            window.safeAreaTop = insets.top;
            window.safeAreaBottom = insets.bottom;
            Object.assign(window.other || (window.other = {}), {
                safeAreaTop: insets.top,
                topSafeArea: insets.top,
                statusBarHeight: insets.top,
                safeAreaBottom: insets.bottom,
                bottomSafeArea: insets.bottom
            });
            const root = document && document.documentElement;
            if (root) {
                [
                    ['--kael-safe-area-top', insets.top],
                    ['--kael-safe-area-bottom', insets.bottom],
                    ['--native-safe-area-top', insets.top],
                    ['--native-safe-area-bottom', insets.bottom]
                ].forEach(([name, value]) => root.style.setProperty(name, value + 'px'));
            }
            window.dispatchEvent(new CustomEvent('nativeSafeAreaReady', { detail: insets }));
        })();
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
        
        var obj: [String: Any] = [:]
        obj["postTheme"] = ["Hobbies", "Inspire"]
        obj["reportContent"] = ["Harassment", "Malicious fraud", "Pornography", "Malicious insults", "False Information"]
        obj["coinsSetting"] = hghawiL2189jLkjProducts.map { product in
            [
                "key": product.hglijlkKuxaKeyId,
                "cions": product.hglijlkKuxaGetDiamond,
                "money": product.hglijlkKuxaPrice
            ]
        }
        let json = encodeAny(obj)
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
    @EnvironmentObject var aswuIpaManager: HglijlkKuxaIAPManager
    @State private var aswIsLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()
                FhHhckauedaWebview(
                    fhHhckauedaWebNav: aswuznaWebUrlString,
                    safeAreaInsets: geometry.safeAreaInsets,
                    isLoading: $aswIsLoading
                )
                    .ignoresSafeArea()
                if aswIsLoading {
                    VStack(spacing: 14) {
                        ProgressView()
                            .tint(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                        Text("Loading...")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .extraBold))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                    }
                }
            }.ignoresSafeArea()
                .navigationBarHidden(true)
                .background(VhuaGehuSwipeBack())
                .onAppear {
                    if aswuznaWebUrlString == "coins" {
                        aswuIpaManager.mznsALiwFetchProducts()
                    }
                }
        }
    }
}
