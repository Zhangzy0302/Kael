
import UIKit
import UserNotifications
import FBSDKCoreKit
import AdjustSdk

final class CopperLanternAdjustManager: NSObject, AdjustDelegate {
    static let copperLanternShared = CopperLanternAdjustManager()

    private let copperLanternInstallToken = "ntdueq"
    private let copperLanternPurchaseToken = "mfhq02"
    private let copperLanternAppToken = "ymwmcd0z7hmo"
    private var copperLanternDidStartInitialization = false
    private var copperLanternDidInitialize = false

    private override init() {}

    func copperLanternStartLaunchInitialization() {
        guard !copperLanternDidStartInitialization else {
            return
        }

        copperLanternDidStartInitialization = true

        Task { @MainActor in
            await AmberCircuitPhoneInfo.amberCircuitShared.amberCircuitGetPhoneInfo()
            CopperLanternAdjustManager.copperLanternShared.copperLanternInitialize()
        }
    }

    func copperLanternInitialize() {
        guard !copperLanternDidInitialize else {
            return
        }

        guard let copperLanternAdjustConfig = ADJConfig(
            appToken: copperLanternAppToken,
            environment: ADJEnvironmentProduction
        ) else {
            return
        }

        copperLanternAdjustConfig.logLevel = ADJLogLevel.verbose
        copperLanternAdjustConfig.enableSendingInBackground()
        copperLanternAdjustConfig.delegate = self

        print("ta_distinct_id: \(QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId)")

        Adjust.addGlobalCallbackParameter(
            QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId,
            forKey: "ta_distinct_id"
        )

        Adjust.attribution { [weak self] copperLanternAttribution in
            self?.adjustAttributionChanged(copperLanternAttribution)
        }

        Adjust.initSdk(copperLanternAdjustConfig)
        copperLanternDidInitialize = true
    }

    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        let copperLanternInstallEvent = ADJEvent(eventToken: copperLanternInstallToken)
        Adjust.trackEvent(copperLanternInstallEvent)
    }

    func copperLanternTrackPurchase(dollar: Double) {
        let copperLanternPurchaseEvent = ADJEvent(eventToken: copperLanternPurchaseToken)
        copperLanternPurchaseEvent?.setRevenue(dollar, currency: "USD")
        Adjust.trackEvent(copperLanternPurchaseEvent)
        // fb
        copperLanternTrackFacebookPurchase(price: dollar)
    }

    private func copperLanternTrackFacebookPurchase(price copperLanternPrice: Double) {
        AppEvents.shared.logPurchase(
            amount: copperLanternPrice,
            currency: "USD",
            parameters: [
                AppEvents.ParameterName(rawValue: "fb_mobile_purchase"): "true"
            ]
        )
    }
}

class CopperLanternAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        CopperLanternAdjustManager.copperLanternShared.copperLanternStartLaunchInitialization()
        copperLanternRegisterRemoteNotifications(application)

        return true
    }

    private func copperLanternRegisterRemoteNotifications(_ application: UIApplication) {

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }

    static func copperLanternRequestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { copperLanternSettings in
            switch copperLanternSettings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .sound, .badge]
                ) { copperLanternGranted, _ in
                    guard copperLanternGranted else {
                        return
                    }

                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }

            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }

            case .denied:
                break

            @unknown default:
                break
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {

        let copperLanternPushToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        // 保存
        QuartzMurmurAppStorage.quartzMurmurPushToken = copperLanternPushToken
        print("Push 注册成功: \(copperLanternPushToken)")

        Task {
            await LunarParadeInitUtils.lunarParadeShared.lunarParadeSynchronizePushToken()
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Push 注册失败:", error)
    }
}
