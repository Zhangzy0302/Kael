import Combine
import ScreenShield
import SwiftUI
import UIKit
import WebKit

@MainActor
enum PixelHarborWebRuntime {
    private static var pixelHarborPrewarmWebView: WKWebView?

    static func pixelHarborPrewarm() {
        guard pixelHarborPrewarmWebView == nil else {
            return
        }

        let pixelHarborConfiguration = WKWebViewConfiguration()
        let pixelHarborWebView = WKWebView(frame: .zero, configuration: pixelHarborConfiguration)
        pixelHarborWebView.isHidden = true
        pixelHarborWebView.loadHTMLString("<!doctype html><html><body></body></html>", baseURL: nil)
        pixelHarborPrewarmWebView = pixelHarborWebView
    }
}

struct PixelHarborGuideBackdrop: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image("eoqca_guide_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }

            LinearGradient(
                colors: [
                    KaelGhueauTheme.KaelColor.kaelMainYellow,
                    Color(red: 245 / 255, green: 205 / 255, blue: 98 / 255).opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct PixelHarborWebDisplayView: View {
    @StateObject private var pixelHarborModel: PixelHarborWebDisplayModel
    @ObservedObject private var pixelHarborLocationManager = AmberCircuitLocationManager.amberCircuitShared
    @EnvironmentObject private var pixelHarborIapManager: HglijlkKuxaIAPManager

    let pixelHarborWebAddress: String
    let pixelHarborBackAction: () -> Void

    init(pixelHarborWebAddress: String, pixelHarborBackAction: @escaping () -> Void) {
        self.pixelHarborWebAddress = pixelHarborWebAddress
        self.pixelHarborBackAction = pixelHarborBackAction
        _pixelHarborModel = StateObject(wrappedValue: PixelHarborWebDisplayModel(pixelHarborWebAddress: pixelHarborWebAddress))
    }

    var body: some View {
        ZStack {
            KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()

            if pixelHarborModel.isBPackageWeb, pixelHarborModel.isLoading {
                pixelHarborLaunchBackdrop
            }

            pixelHarborPageLayer
                .ignoresSafeArea(edges: pixelHarborModel.isBPackageWeb ? .all : .bottom)
                .opacity(pixelHarborModel.isBPackageWeb && pixelHarborModel.isLoading ? 0 : 1)

            if !pixelHarborModel.isBPackageWeb {
                pixelHarborTopBackBar
                    .zIndex(20)
            }

            if pixelHarborModel.isLoading {
                PixelHarborWebLoadingLayer()
                    .zIndex(40)
            }

            if let pixelHarborErrorText = pixelHarborModel.loadErrorText {
                PixelHarborWebErrorLayer(pixelHarborErrorText: pixelHarborErrorText, retryAction: pixelHarborModel.retry)
                    .zIndex(50)
            }

            if pixelHarborLocationManager.amberCircuitShowLocationDialog {
                AmberCircuitLocationPermissionDialog {
                    pixelHarborLocationManager.amberCircuitShowLocationDialog = false
                }
                .zIndex(400)
            }
        }
        .protectScreenshot()
        .ignoresSafeArea()
        .onAppear {
            if pixelHarborModel.isBPackageWeb {
                CopperLanternAppDelegate.copperLanternRequestNotificationPermission()
            }
            ScreenShield.shared.protectFromScreenRecording("Screen capture not allowed")
            pixelHarborModel.sceneDidAppear(pixelHarborIapManager: pixelHarborIapManager)
        }
    }

    @ViewBuilder
    private var pixelHarborPageLayer: some View {
        if let url = pixelHarborModel.resolvedURL {
            PixelHarborWebContainer(
                url: url,
                pixelHarborBridge: pixelHarborModel.pixelHarborBridge,
                allowsBackForwardNavigationGestures: true,
                pixelHarborCallbacks: PixelHarborWebCallbacks(
                    loadingStarted: pixelHarborModel.loadingStarted,
                    loadingFinished: pixelHarborModel.loadingFinished,
                    loadingFailed: pixelHarborModel.loadingFailed,
                    closeRequested: {
                        pixelHarborModel.closeRequested()
                        pixelHarborBackAction()
                    },
                    rechargeRequested: { orderCode, batchNo in
                        pixelHarborModel.rechargeRequested(
                            orderCode: orderCode,
                            batchNo: batchNo,
                            pixelHarborIapManager: pixelHarborIapManager
                        )
                    },
                    externalOpenRequested: pixelHarborModel.openExternalURL
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            pixelHarborInvalidAddressView
        }
    }

    private var pixelHarborTopBackBar: some View {
        VStack(spacing: 0) {
            HStack {
                Image("back")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .onTapGesture(perform: pixelHarborBackAction)
                Spacer()
            }
            .padding(.top, 58)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            Spacer(minLength: 0)
        }
    }

    private var pixelHarborInvalidAddressView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(KaelGhueauTheme.KaelColor.kaelButtonYellow)

            Text("Invalid web address")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)

            Text(pixelHarborWebAddress)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack.opacity(0.70))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var pixelHarborLaunchBackdrop: some View {
        PixelHarborGuideBackdrop()
    }
}

@MainActor
private final class PixelHarborWebDisplayModel: ObservableObject {
    let pixelHarborWebAddress: String
    let pixelHarborBridge = PixelHarborWebBridge()

    @Published var isLoading = true
    @Published var loadErrorText: String?

    init(pixelHarborWebAddress: String) {
        self.pixelHarborWebAddress = pixelHarborWebAddress
    }

    var resolvedURL: URL? {
        let trimmedAddress = pixelHarborWebAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAddress.isEmpty else { return nil }

        if let url = URL(string: trimmedAddress), url.scheme?.isEmpty == false {
            return url
        }

        return URL(string: "https://\(trimmedAddress)")
    }

    var isBPackageWeb: Bool {
        guard let url = resolvedURL else { return false }
        let urlString = url.absoluteString
        return urlString.contains("openParams=") || urlString.contains("appId=")
    }

    func sceneDidAppear(pixelHarborIapManager: HglijlkKuxaIAPManager) {
        pixelHarborIapManager.pixelHarborPrepareProducts()
    }

    func loadingStarted() {
        loadErrorText = nil
        isLoading = true
    }

    func loadingFinished(_ duration: Int) {
        recordLoadingDuration(duration)

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: isBPackageWeb ? 250_000_000 : 120_000_000)
            isLoading = false
        }
    }

    func loadingFailed(_ pixelHarborErrorText: String) {
        isLoading = false
        loadErrorText = pixelHarborErrorText
    }

    func retry() {
        loadErrorText = nil
        isLoading = true
        pixelHarborBridge.reload()
    }

    func closeRequested() {
        QuartzMurmurAppStorage.quartzMurmurUserToken = ""
    }

    func rechargeRequested(orderCode: String, batchNo: String, pixelHarborIapManager: HglijlkKuxaIAPManager) {
        pixelHarborIapManager.pixelHarborRecharge(productID: batchNo, orderCode: orderCode) { [weak self] result in
            Task { @MainActor in
                self?.handleRechargeResult(result)
            }
        }
    }

    func openExternalURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            notifyOpenState(state: "failed", urlString: urlString)
            return
        }

        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            Task { @MainActor in
                self?.notifyOpenState(
                    state: success ? "success" : "failed",
                    urlString: url.absoluteString
                )
            }
        }
    }

    private func handleRechargeResult(_ result: HglijlkKuxaPurchaseResult) {
        switch result {
        case .success(let coins):
            notifyRechargeState(state: "success", coins: coins)
        case .cancelled:
            return
        case .pending:
            notifyRechargeState(state: "pending")
        case .failed(let message):
            TuxaliFvswlaHUD.toast(.error(message))
            notifyRechargeState(state: "failed")
        }
    }

    private func recordLoadingDuration(_ duration: Int) {
        guard isBPackageWeb else { return }
        Task {
            try? await VelvetCometApiCall().velvetCometLoadingTimeRecord(duration)
        }
    }

    private func notifyOpenState(state: String, urlString: String) {
        pixelHarborBridge.evaluateJavaScript(
            pixelHarborNativeOpenStateScript(state: state, urlString: urlString)
        )
    }

    private func notifyRechargeState(state: String, coins: Int = 0) {
        pixelHarborBridge.evaluateJavaScript(
            pixelHarborNativeRechargeStateScript(state: state, coins: coins)
        )
    }
}

private struct PixelHarborWebLoadingLayer: View {
    var body: some View {
        VStack {
            Spacer(minLength: 0)

            VStack(spacing: 18) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.28)

                Text("Loading...")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.28))
        .allowsHitTesting(true)
    }
}

private struct PixelHarborWebErrorLayer: View {
    let pixelHarborErrorText: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Load failed")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            Text(pixelHarborErrorText)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)

            Button(action: retryAction) {
                Text("Retry")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 26)
                    .frame(height: 44)
                    .background(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.86))
        .allowsHitTesting(true)
    }
}

private final class PixelHarborWebBridge: ObservableObject {
    weak var webView: WKWebView?

    func reload() {
        webView?.reload()
    }

    func evaluateJavaScript(_ javaScript: String) {
        DispatchQueue.main.async { [weak self] in
            self?.webView?.evaluateJavaScript(javaScript)
        }
    }
}

private struct PixelHarborWebCallbacks {
    let loadingStarted: () -> Void
    let loadingFinished: (Int) -> Void
    let loadingFailed: (String) -> Void
    let closeRequested: () -> Void
    let rechargeRequested: (_ orderCode: String, _ batchNo: String) -> Void
    let externalOpenRequested: (String) -> Void
}

private struct PixelHarborWebContainer: UIViewRepresentable {
    let url: URL
    let pixelHarborBridge: PixelHarborWebBridge
    let allowsBackForwardNavigationGestures: Bool
    let pixelHarborCallbacks: PixelHarborWebCallbacks

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        PixelHarborWebAction.allCases.forEach {
            contentController.add(context.coordinator, name: $0.rawValue)
        }

        configuration.userContentController = contentController
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        applySettings(to: webView, coordinator: context.coordinator)
        pixelHarborBridge.webView = webView
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.pixelHarborContainer = self
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        PixelHarborWebAction.allCases.forEach {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: $0.rawValue)
        }
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func applySettings(to webView: WKWebView, coordinator: Coordinator) {
        webView.navigationDelegate = coordinator
        webView.uiDelegate = coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.contentInset = .zero
        webView.scrollView.scrollIndicatorInsets = .zero
        webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
        var pixelHarborContainer: PixelHarborWebContainer
        var pixelHarborStartTime: Date?

        init(_ pixelHarborContainer: PixelHarborWebContainer) {
            self.pixelHarborContainer = pixelHarborContainer
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            pixelHarborStartTime = Date()
            pixelHarborContainer.pixelHarborCallbacks.loadingStarted()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            pixelHarborContainer.pixelHarborCallbacks.loadingFinished(elapsedMilliseconds())
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            pixelHarborContainer.pixelHarborCallbacks.loadingFailed(error.localizedDescription)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            pixelHarborContainer.pixelHarborCallbacks.loadingFailed(error.localizedDescription)
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url,
                  let scheme = url.scheme?.lowercased() else {
                decisionHandler(.allow)
                return
            }

            guard !PixelHarborWebNavigationPolicy.shouldAllow(scheme: scheme) else {
                decisionHandler(.allow)
                return
            }

            openNonWebURL(url, webView: webView)
            decisionHandler(.cancel)
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            guard let url = navigationAction.request.url else {
                return nil
            }

            if PixelHarborWebNavigationPolicy.shouldOpenExternally(url: url) {
                UIApplication.shared.open(url)
                return nil
            }

            webView.load(URLRequest(url: url))
            return nil
        }

        func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            decisionHandler(.grant)
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let action = PixelHarborWebAction(rawValue: message.name) else {
                return
            }

            switch action {
            case .rechargePay:
                guard let order = PixelHarborWebOrder(body: message.body) else { return }
                pixelHarborContainer.pixelHarborCallbacks.rechargeRequested(order.orderCode, order.batchNo)

            case .close:
                pixelHarborContainer.pixelHarborCallbacks.closeRequested()

            case .openBrowser:
                guard let urlString = PixelHarborWebExternalLink.urlString(from: message.body) else { return }
                pixelHarborContainer.pixelHarborCallbacks.externalOpenRequested(urlString)
            }
        }

        private func elapsedMilliseconds() -> Int {
            pixelHarborStartTime.map { Int(Date().timeIntervalSince($0) * 1000) } ?? 0
        }

        private func openNonWebURL(_ url: URL, webView: WKWebView) {
            UIApplication.shared.open(url, options: [:]) { success in
                let script = pixelHarborNativeOpenStateScript(
                    state: success ? "success" : "failed",
                    urlString: url.absoluteString
                )
                DispatchQueue.main.async {
                    webView.evaluateJavaScript(script)
                }
            }
        }
    }
}

private enum PixelHarborWebAction: String, CaseIterable {
    case rechargePay
    case close = "Close"
    case openBrowser
}

private enum PixelHarborWebNavigationPolicy {
    static func shouldAllow(scheme: String) -> Bool {
        ["http", "https", "file", "about"].contains(scheme)
    }

    static func shouldOpenExternally(url: URL) -> Bool {
        let urlString = url.absoluteString.lowercased()
        return url.scheme == "itms-apps"
            || url.scheme == "itms-services"
            || urlString.contains("apps.apple.com")
    }
}

private struct PixelHarborWebOrder {
    let orderCode: String
    let batchNo: String

    init?(body: Any) {
        guard let dict = body as? [String: Any],
              let orderCode = dict["orderCode"] as? String,
              let batchNo = dict["batchNo"] as? String else {
            return nil
        }

        self.orderCode = orderCode
        self.batchNo = batchNo
    }
}

private enum PixelHarborWebExternalLink {
    static func urlString(from body: Any) -> String? {
        if let dict = body as? [String: Any],
           let urlString = dict["url"] as? String {
            return urlString
        }

        return body as? String
    }
}

private func pixelHarborJavaScriptEscaped(_ value: String) -> String {
    value
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "'", with: "\\'")
        .replacingOccurrences(of: "\n", with: "\\n")
        .replacingOccurrences(of: "\r", with: "\\r")
}

private func pixelHarborNativeOpenStateScript(state: String, urlString: String) -> String {
    """
    window.dispatchEvent(new CustomEvent('nativeOpenState', {
        detail: { state: '\(pixelHarborJavaScriptEscaped(state))', url: '\(pixelHarborJavaScriptEscaped(urlString))' }
    }));
    """
}

private func pixelHarborNativeRechargeStateScript(state: String, coins: Int) -> String {
    """
    window.dispatchEvent(new CustomEvent('nativeRechargeState', {
        detail: { state: '\(pixelHarborJavaScriptEscaped(state))', coins: \(coins) }
    }));
    """
}
