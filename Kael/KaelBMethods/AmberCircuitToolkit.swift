import Combine
import CommonCrypto
import CoreLocation
import Foundation
import Network
import SwiftUI
import SystemConfiguration.CaptiveNetwork
import UIKit

// MARK: - AES

extension String {
    func amberCircuitBEncode() -> String {
        AmberCircuitAESCoder.amberCircuitEncrypt(self)
    }

    func amberCircuitBDecrypt() -> String {
        AmberCircuitAESCoder.amberCircuitDecrypt(self)
    }
}

private enum AmberCircuitAESCoder {
    private static let amberCircuitAESKey = "e700ud0bam360z95"
    private static let amberCircuitAESIV = "nzpw70a9hmy487t2"

    static func amberCircuitEncrypt(_ amberCircuitPlainText: String) -> String {
        guard let amberCircuitData = amberCircuitPlainText.data(using: .utf8),
              let amberCircuitEncrypted = amberCircuitCrypt(
                amberCircuitData,
                amberCircuitOperation: CCOperation(kCCEncrypt)
              ) else {
            return ""
        }

        return amberCircuitEncrypted.map { String(format: "%02x", $0) }.joined()
    }

    static func amberCircuitDecrypt(_ amberCircuitCipherText: String) -> String {
        guard let amberCircuitEncryptedData = Data(hexString: amberCircuitCipherText),
              let amberCircuitDecrypted = amberCircuitCrypt(
                amberCircuitEncryptedData,
                amberCircuitOperation: CCOperation(kCCDecrypt)
              ),
              let amberCircuitResult = String(data: amberCircuitDecrypted, encoding: .utf8) else {
            return ""
        }

        return amberCircuitResult
    }

    private static func amberCircuitCrypt(
        _ amberCircuitData: Data,
        amberCircuitOperation: CCOperation
    ) -> Data? {
        guard let amberCircuitKeyData = amberCircuitAESKey.data(using: .utf8),
              let amberCircuitIVData = amberCircuitAESIV.data(using: .utf8) else {
            return nil
        }

        let amberCircuitDataLength = amberCircuitData.count
        let amberCircuitOutLength = amberCircuitDataLength + kCCBlockSizeAES128

        var amberCircuitOutBytes = Data(count: amberCircuitOutLength)
        var amberCircuitFinalLength = 0

        let amberCircuitStatus = amberCircuitOutBytes.withUnsafeMutableBytes { amberCircuitOutBytesPtr -> CCCryptorStatus in
            guard let amberCircuitOutBase = amberCircuitOutBytesPtr.baseAddress else {
                return CCCryptorStatus(kCCMemoryFailure)
            }

            return amberCircuitData.withUnsafeBytes { amberCircuitDataPtr in
                amberCircuitKeyData.withUnsafeBytes { amberCircuitKeyPtr in
                    amberCircuitIVData.withUnsafeBytes { amberCircuitIVPtr in
                        CCCrypt(
                            amberCircuitOperation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            amberCircuitKeyPtr.baseAddress,
                            kCCKeySizeAES128,
                            amberCircuitIVPtr.baseAddress,
                            amberCircuitDataPtr.baseAddress,
                            amberCircuitDataLength,
                            amberCircuitOutBase,
                            amberCircuitOutLength,
                            &amberCircuitFinalLength
                        )
                    }
                }
            }
        }

        guard amberCircuitStatus == kCCSuccess else {
            return nil
        }

        return amberCircuitOutBytes.prefix(amberCircuitFinalLength)
    }
}

extension Data {
    init?(hexString: String) {
        let amberCircuitLength = hexString.count / 2
        var amberCircuitData = Data(capacity: amberCircuitLength)

        var amberCircuitIndex = hexString.startIndex
        for _ in 0..<amberCircuitLength {
            let amberCircuitNextIndex = hexString.index(amberCircuitIndex, offsetBy: 2)
            guard amberCircuitNextIndex <= hexString.endIndex else {
                return nil
            }

            let amberCircuitBytes = hexString[amberCircuitIndex..<amberCircuitNextIndex]
            guard let amberCircuitNumber = UInt8(amberCircuitBytes, radix: 16) else {
                return nil
            }

            amberCircuitData.append(amberCircuitNumber)
            amberCircuitIndex = amberCircuitNextIndex
        }

        self = amberCircuitData
    }
}

// MARK: - B Package Information

class AmberCircuitInformationCreate {
    static let amberCircuitBaseURL: String = "https://opi.fbspecck.link"
    static let amberCircuitAppId: String = "16927806"
    static let amberCircuitAppVersion: String = "1.1.0"
    static let amberCircuitVerifyDate: DateComponents = DateComponents(
        year: 2026,
        month: 7,
        day: 23,
        hour: 6
    )

    static func amberCircuitBuildH5Url(baseUrl amberCircuitBaseUrl: String, token amberCircuitToken: String) -> String {
        AmberCircuitH5URLBuilder.amberCircuitBuild(
            baseUrl: amberCircuitBaseUrl,
            token: amberCircuitToken,
            appId: amberCircuitAppId
        )
    }
}

private enum AmberCircuitH5URLBuilder {
    static func amberCircuitBuild(
        baseUrl amberCircuitBaseUrl: String,
        token amberCircuitToken: String,
        appId amberCircuitAppId: String
    ) -> String {
        let amberCircuitOpenParams: [String: Any] = [
            "token": amberCircuitToken,
            "timestamp": Int(Date().timeIntervalSince1970 * 1000)
        ]

        print(amberCircuitToken)

        guard let amberCircuitJSONData = try? JSONSerialization.data(withJSONObject: amberCircuitOpenParams),
              let amberCircuitJSONString = String(data: amberCircuitJSONData, encoding: .utf8) else {
            return ""
        }

        let amberCircuitEncodedParams = amberCircuitJSONString.amberCircuitBEncode()
        return "\(amberCircuitBaseUrl)?openParams=\(amberCircuitEncodedParams)&appId=\(amberCircuitAppId)"
    }
}

// MARK: - Location

class AmberCircuitLocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let amberCircuitShared = AmberCircuitLocationManager()

    @Published var amberCircuitShowLocationDialog: Bool = false

    private let amberCircuitManager = CLLocationManager()
    private var amberCircuitLocationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        amberCircuitConfigureManager()
    }

    func amberCircuitGetCurrentLocationAndAddress() async -> CLPlacemark? {
        let amberCircuitCanUseLocation = await amberCircuitCheckAndRequestLocation()
        guard amberCircuitCanUseLocation else {
            return nil
        }

        do {
            let amberCircuitLocation = try await amberCircuitGetCurrentLocation()
            return try await amberCircuitReverseGeocode(amberCircuitLocation)
        } catch {
            await MainActor.run {
                TuxaliFvswlaHUD.toast(.error("Positioning failed"))
            }
            return nil
        }
    }

    func amberCircuitCheckAndRequestLocation() async -> Bool {
        guard await amberCircuitCheckSystemLocationService() else {
            return false
        }

        return await amberCircuitCheckAuthorizationStatus()
    }

    func locationManager(
        _ amberCircuitManager: CLLocationManager,
        didUpdateLocations amberCircuitLocations: [CLLocation]
    ) {
        guard let amberCircuitLocation = amberCircuitLocations.first else {
            amberCircuitLocationContinuation?.resume(throwing: NSError())
            amberCircuitLocationContinuation = nil
            return
        }

        amberCircuitLocationContinuation?.resume(returning: amberCircuitLocation)
        amberCircuitLocationContinuation = nil
    }

    func locationManager(
        _ amberCircuitManager: CLLocationManager,
        didFailWithError amberCircuitError: Error
    ) {
        amberCircuitLocationContinuation?.resume(throwing: amberCircuitError)
        amberCircuitLocationContinuation = nil
    }

    private func amberCircuitConfigureManager() {
        amberCircuitManager.delegate = self
        amberCircuitManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func amberCircuitCheckSystemLocationService() async -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            await amberCircuitShowPermissionDialog()

            if CLLocationManager.locationServicesEnabled() == false {
                amberCircuitShowLocationServiceDisabledToast()
                return false
            }

            return false
        }

        return true
    }

    private func amberCircuitCheckAuthorizationStatus() async -> Bool {
        let amberCircuitStatus = amberCircuitManager.authorizationStatus

        if amberCircuitStatus == .denied || amberCircuitStatus == .restricted {
            return await amberCircuitHandleRejectedAuthorization()
        }

        if amberCircuitStatus == .notDetermined {
            amberCircuitManager.requestWhenInUseAuthorization()
            return true
        }

        return true
    }

    private func amberCircuitHandleRejectedAuthorization() async -> Bool {
        await amberCircuitShowPermissionDialog()

        let amberCircuitNewStatus = amberCircuitManager.authorizationStatus
        if amberCircuitNewStatus == .denied || amberCircuitNewStatus == .restricted {
            return false
        }

        return true
    }

    private func amberCircuitGetCurrentLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { amberCircuitContinuation in
            self.amberCircuitLocationContinuation = amberCircuitContinuation
            amberCircuitManager.requestLocation()
        }
    }

    private func amberCircuitReverseGeocode(_ amberCircuitLocation: CLLocation) async throws -> CLPlacemark? {
        try await withCheckedThrowingContinuation { amberCircuitContinuation in
            CLGeocoder().reverseGeocodeLocation(amberCircuitLocation) { amberCircuitPlacemarks, amberCircuitError in
                if let amberCircuitError {
                    amberCircuitContinuation.resume(throwing: amberCircuitError)
                    return
                }

                amberCircuitContinuation.resume(returning: amberCircuitPlacemarks?.first)
            }
        }
    }

    private func amberCircuitShowLocationServiceDisabledToast() {
        DispatchQueue.main.async {
            TuxaliFvswlaHUD.toast(.error("Please enable system location services."))
        }
    }

    @MainActor
    private func amberCircuitShowPermissionDialog() async {
        amberCircuitShowLocationDialog = true
    }
}

// MARK: - Phone Info

class AmberCircuitPhoneInfo {
    static let amberCircuitShared = AmberCircuitPhoneInfo()

    var amberCircuitLanguages: [String] = []
    var amberCircuitCountryCode: String = ""
    var amberCircuitLatitude: Double = 0
    var amberCircuitLongitude: Double = 0
    var amberCircuitCoverAppList: [String] = []
    var amberCircuitKeyboards: [String] = []
    var amberCircuitTimezone: String = ""
    var amberCircuitIsVpnActive: Int = 0

    func amberCircuitGetPhoneInfo() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.amberCircuitGetLanguages() }
            group.addTask { await self.amberCircuitGetTimezone() }
            group.addTask { await self.amberCircuitGetInstalledApps() }
            group.addTask { await self.amberCircuitCheckVPN() }
            group.addTask { await self.amberCircuitGetSystemKeyboards() }
            group.addTask { await self.amberCircuitPrepareDeviceIdIfNeeded() }
        }

        print("devid: \(QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId)")
    }

    func amberCircuitGetLanguages() async {
        amberCircuitLanguages = AmberCircuitDeviceSnapshot.amberCircuitPreferredLanguages()
    }

    func amberCircuitGetTimezone() async {
        amberCircuitTimezone = AmberCircuitDeviceSnapshot.amberCircuitCurrentTimezone()
    }

    func amberCircuitCheckVPN() async {
        amberCircuitIsVpnActive = AmberCircuitDeviceSnapshot.amberCircuitIsVPNActive() ? 1 : 0
    }

    func amberCircuitGetInstalledApps() async {
        amberCircuitCoverAppList = await AmberCircuitInstalledAppScanner.amberCircuitInstalledAppNames()
    }

    func amberCircuitGetSystemKeyboards() async {
        amberCircuitKeyboards = await AmberCircuitDeviceSnapshot.amberCircuitActiveKeyboardLanguages()
    }

    func amberCircuitGetDeviceId(appId amberCircuitAppId: String) async -> String {
        let amberCircuitIdentifier = await UIDevice.current.identifierForVendor?.uuidString ?? ""
        return amberCircuitIdentifier + amberCircuitAppId
    }

    private func amberCircuitPrepareDeviceIdIfNeeded() async {
        guard QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId.isEmpty else {
            return
        }

        print("QuartzMurmurBInfoStore.getDevid: \(QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId)")

        let amberCircuitDeviceId = await amberCircuitGetDeviceId(
            appId: AmberCircuitInformationCreate.amberCircuitAppId
        )
        QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId = amberCircuitDeviceId
    }
}

private enum AmberCircuitDeviceSnapshot {
    private static let amberCircuitVPNInterfaceKeywords = ["tap", "tun", "ppp", "ipsec"]

    static func amberCircuitPreferredLanguages() -> [String] {
        Locale.preferredLanguages
    }

    static func amberCircuitCurrentTimezone() -> String {
        TimeZone.current.identifier
    }

    static func amberCircuitIsVPNActive() -> Bool {
        guard let amberCircuitSettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let amberCircuitScopes = amberCircuitSettings["__SCOPED__"] as? [String: Any] else {
            return false
        }

        return amberCircuitScopes.keys.contains { amberCircuitInterfaceName in
            amberCircuitVPNInterfaceKeywords.contains { amberCircuitInterfaceName.contains($0) }
        }
    }

    static func amberCircuitActiveKeyboardLanguages() async -> [String] {
        await MainActor.run {
            UITextInputMode.activeInputModes.compactMap { $0.primaryLanguage }
        }
    }
}

private enum AmberCircuitInstalledAppScanner {
    static func amberCircuitInstalledAppNames() async -> [String] {
        var amberCircuitInstalled: [String] = []

        for amberCircuitApp in amberCircuitKnownApps where await amberCircuitCanOpenApp(amberCircuitApp) {
            amberCircuitInstalled.append(amberCircuitApp.amberCircuitName)
        }

        return amberCircuitInstalled
    }

    private static func amberCircuitCanOpenApp(_ amberCircuitApp: AmberCircuitApp) async -> Bool {
        guard let amberCircuitURL = URL(string: "\(amberCircuitApp.amberCircuitScheme)://") else {
            return false
        }

        return await UIApplication.shared.canOpenURL(amberCircuitURL)
    }
}

struct AmberCircuitApp {
    let amberCircuitName: String
    let amberCircuitScheme: String
}

let amberCircuitKnownApps = [
    AmberCircuitApp(amberCircuitName: "WhatsApp", amberCircuitScheme: "whatsapp"),
    AmberCircuitApp(amberCircuitName: "Instagram", amberCircuitScheme: "instagram"),
    AmberCircuitApp(amberCircuitName: "Facebook", amberCircuitScheme: "fb"),
    AmberCircuitApp(amberCircuitName: "TikTok", amberCircuitScheme: "tiktok"),
    AmberCircuitApp(amberCircuitName: "GoogleMaps", amberCircuitScheme: "comgooglemaps"),
    AmberCircuitApp(amberCircuitName: "twitter", amberCircuitScheme: "tweetie"),
    AmberCircuitApp(amberCircuitName: "qq", amberCircuitScheme: "mqq"),
    AmberCircuitApp(amberCircuitName: "weiChat", amberCircuitScheme: "wechat"),
    AmberCircuitApp(amberCircuitName: "Aliapp", amberCircuitScheme: "alipay")
]
