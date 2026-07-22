
import SwiftUI

@main
struct KaelApp: App {
    @UIApplicationDelegateAdaptor(CopperLanternAppDelegate.self)
    var appDelegate
    
    @StateObject private var kawuxhaFgfNaviManager = KawuxhaFgfNaviManager()
    
    @StateObject private var mxhwiUAhxgswChatViewModel: MxhwiUAhxgswChatViewModel = MxhwiUAhxgswChatViewModel()
    @StateObject private var pwixzLkciemUserViewModel: PwixzLkciemUserViewModel = PwixzLkciemUserViewModel()
    @StateObject private var rwyclaHurgrVideoViewModel: RwyclaHurgrVideoViewModel = RwyclaHurgrVideoViewModel()
    @StateObject private var hglijlkKuxaIAPManager: HglijlkKuxaIAPManager = HglijlkKuxaIAPManager()
    
    private var storage = KaelIwuzHacStorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            PixelHarborPackageGateView {
                ZStack{
                    KawuxhaFgfRouter()
                    TuxaliFvswlaHUDView()
                    if kawuxhaFgfNaviManager.isShowBlock {
                        VytlwKJewReportBlock(vytilwKejaIsShow: $kawuxhaFgfNaviManager.isShowBlock)
                            .transition(.opacity)
                    }
                    if kawuxhaFgfNaviManager.isShowGuestLogin {
                        KaelGuestLoginDialog(
                            onLogin: {
                                kawuxhaFgfNaviManager.confirmGuestLogin()
                                pwixzLkciemUserViewModel.loadLoginPwixzLkciemUser()
                            },
                            onCancel: {
                                kawuxhaFgfNaviManager.closeGuestLogin()
                            }
                        )
                        .zIndex(10)
                    }
                }
            }
            .environmentObject(kawuxhaFgfNaviManager)
            .environmentObject(mxhwiUAhxgswChatViewModel)
            .environmentObject(pwixzLkciemUserViewModel)
            .environmentObject(rwyclaHurgrVideoViewModel)
            .environmentObject(hglijlkKuxaIAPManager)
            .onAppear{
                storage.initializeAllDefaults()
                hglijlkKuxaIAPManager.mznsALiwFetchProducts()
                pwixzLkciemUserViewModel.loadLoginPwixzLkciemUser()
            }
        }
    }
}

private struct PixelHarborPackageGateView<APackageContent: View>: View {
    @StateObject private var pixelHarborInitViewModel = LunarParadeInitViewModel()
    @State private var pixelHarborDidStartInit = false
    @State private var pixelHarborWebAddress: String?
    @State private var pixelHarborIsQuickLoggingIn = false
    
    @ViewBuilder let pixelHarborAPackageContent: () -> APackageContent
    
    var body: some View {
        ZStack {
            switch pixelHarborInitViewModel.lunarParadeStatus {
            case .lunarParadeLoading:
                pixelHarborLoadingContent
                
            case .lunarParadeA:
                pixelHarborAPackageContent()
                
            case .lunarParadeB:
                pixelHarborBPackageEntryContent
            }
            
            if let pixelHarborWebAddress {
                PixelHarborWebDisplayView(pixelHarborWebAddress: pixelHarborWebAddress) {
                    self.pixelHarborWebAddress = nil
                }
                .transition(.opacity)
                .zIndex(10)
            }
            
            TuxaliFvswlaHUDView()
                .zIndex(500)
        }
        .task {
            await startBInitIfNeeded()
        }
        .animation(.easeInOut(duration: 0.24), value: pixelHarborWebAddress)
    }
    
    private var pixelHarborLoadingContent: some View {
        ZStack {
            PixelHarborGuideBackdrop()
            
            VStack(spacing: 18) {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.3)
                
                Text("Loading...")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var pixelHarborBPackageEntryContent: some View {
        ZStack {
            PixelHarborGuideBackdrop()
            
            VStack(spacing: 0) {
                Spacer()
                
                Image("kael_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 79, height: 79)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color(red: 221 / 255, green: 123 / 255, blue: 15 / 255), lineWidth: 3)
                    )
                    .padding(.bottom, 18)
                
                Text("Kael")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.bottom, 120)
                
                Button(action: handleQuickLogin) {
                    Text(pixelHarborIsQuickLoggingIn ? "Logging in..." : "Quick Login")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 255, height: 54)
                        .background(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(pixelHarborIsQuickLoggingIn)
                .opacity(pixelHarborIsQuickLoggingIn ? 0.72 : 1)
                .padding(.horizontal, 18)
                .padding(.bottom, 66)
            }
        }
    }
    
    @MainActor
    private func startBInitIfNeeded() async {
        guard !pixelHarborDidStartInit else { return }
        pixelHarborDidStartInit = true
        await pixelHarborInitViewModel.lunarParadeInitFlow()

        if pixelHarborInitViewModel.lunarParadeStatus == .lunarParadeB {
            PixelHarborWebRuntime.pixelHarborPrewarm()
        }

        openInitialBWebRouteIfNeeded()
    }
    
    private func openInitialBWebRouteIfNeeded() {
        guard pixelHarborWebAddress == nil else { return }
        openBWebRoute(pixelHarborInitViewModel.lunarParadeNextRoute, showsFailureToast: false)
    }
    
    private func handleQuickLogin() {
        guard !pixelHarborIsQuickLoggingIn else { return }
        pixelHarborIsQuickLoggingIn = true
        TuxaliFvswlaHUD.showLoading(showBackground: true)
        
        Task { @MainActor in
            let route: LunarParadeBRoute?
            if let nextRoute = pixelHarborInitViewModel.lunarParadeNextRoute {
                route = nextRoute
            } else {
                route = await LunarParadeInitUtils.lunarParadeShared.lunarParadeGoLogin()
            }
            
            TuxaliFvswlaHUD.hideLoading()
            pixelHarborIsQuickLoggingIn = false
            openBWebRoute(route, showsFailureToast: true)
        }
    }
    
    private func openBWebRoute(_ route: LunarParadeBRoute?, showsFailureToast: Bool) {
        guard case let .some(.lunarParadeAgreement(url)) = route,
              !url.isEmpty else {
            if showsFailureToast {
                TuxaliFvswlaHUD.toast(.error("Login failed. Please try again."))
            }
            return
        }
        
        pixelHarborWebAddress = url
    }
}
