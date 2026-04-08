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
    
    // 便捷方法：跳转到指定路由
    func push(_ route: KaelOXiwaxRoute) {
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
}
