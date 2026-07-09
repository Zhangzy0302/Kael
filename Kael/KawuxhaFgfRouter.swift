import SwiftUI
import Combine

enum KaelOXiwaxRoute: Hashable {
    case ewioxaEula
    case xpavheSignXePage(xpveheguideType: XpavheSignType)
    case fhHhvckaeudeWeb(fhHguwvWebUrl: String)
    case pxiwkfNavPage
}

struct KawuxhaFgfRouter: View {
    @EnvironmentObject var fwoaWiakcPath: KawuxhaFgfNaviManager
    private var kalaiAstorage = KaelIwuzHacStorageManager.shared
    
    var body: some View {
        NavigationStack(path: $fwoaWiakcPath.keaikxAlxiwPath){
            Group {
                if kalaiAstorage.getCurrentUserId() == "95959" {
                    YdkalxMicjGuidePage()
                }else {
                    PxiwkfNavPage()
                }
                
            }.navigationDestination(for: KaelOXiwaxRoute.self) { route in
                    switch route {
                    case .ewioxaEula:
                        EwioxaEula()
                    case .xpavheSignXePage(let xpveheguideType):
                        XpavheSignXePage(xpveheguideType: xpveheguideType)
                    case .fhHhvckaeudeWeb(let fhHguwvWebUrl):
                        FhHhckauedaWeb(aswuznaWebUrlString: fhHguwvWebUrl)
                    case .pxiwkfNavPage:
                        PxiwkfNavPage()
                    }
                    
                }
                
        }
    }
}

class KawuxhaFgfNaviManager: ObservableObject {
    // 核心：全局共享的导航路径
    @Published var keaikxAlxiwPath: NavigationPath = NavigationPath()
    @Published var isShowBlock: Bool = false
    @Published var blockUserID: String?
    @Published var isShowGuestLogin: Bool = false
    
    private let storage = KaelIwuzHacStorageManager.shared
    
    // 便捷方法：跳转到指定路由
    func push(_ route: KaelOXiwaxRoute) {
        if shouldBlockVisitor(route) {
            showGuestLoginDialog()
            return
        }
        keaikxAlxiwPath.append(route)
    }
    
    // 便捷方法：返回上一页
    func pop() {
        keaikxAlxiwPath.removeLast()
    }
    
    // 便捷方法：返回根页面
    func popToRoot() {
        keaikxAlxiwPath = NavigationPath()
    }
    
    // 弹出拉黑弹框
    func showReportBlock(_ blockId: String){
        if storage.currentUserIsVisitor() {
            showGuestLoginDialog()
            return
        }
        blockUserID = blockId
        withAnimation(.easeOut) {
            isShowBlock = true
        }
    }
    
    // 关闭弹框
    func closeReportBlock() {
        withAnimation(.easeOut) {
            isShowBlock = false
        }
    }
    
    func closeGuestLogin() {
        withAnimation(.easeOut(duration: 0.2)) {
            isShowGuestLogin = false
        }
    }
    
    func confirmGuestLogin() {
        closeGuestLogin()
        redirectVisitorToLogin()
    }
    
    private func shouldBlockVisitor(_ route: KaelOXiwaxRoute) -> Bool {
        guard storage.currentUserIsVisitor() else { return false }
        
        if case .fhHhvckaeudeWeb(let path) = route {
            return KaelGuestWebAccess(path: path).requiresSignedInUser
        }
        
        return false
    }
    
    private func showGuestLoginDialog() {
        isShowBlock = false
        blockUserID = nil
        withAnimation(.easeOut(duration: 0.2)) {
            isShowGuestLogin = true
        }
    }
    
    private func redirectVisitorToLogin() {
        isShowBlock = false
        blockUserID = nil
        storage.setCurrentUserId("95959")
        keaikxAlxiwPath = NavigationPath()
    }
}

private struct KaelGuestWebAccess {
    let path: String
    
    var requiresSignedInUser: Bool {
        !isPublicDocument && !isReadablePost
    }
    
    private var isPublicDocument: Bool {
        path == "userAgreement" || path == "privacyPolicy"
    }
    
    private var isReadablePost: Bool {
        ["picPostDetails/", "videoPostDetails/"].contains { path.hasPrefix($0) }
    }
}
