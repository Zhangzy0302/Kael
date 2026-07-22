import Combine
import CoreLocation
import Foundation
import SwiftUI
import UIKit

enum LunarParadeBRoute {
    case lunarParadeAgreement(lunarParadeURL: String)
}

enum LunarParadeInitStatus {
    case lunarParadeLoading
    case lunarParadeB
    case lunarParadeA
}

private enum LunarParadeLaunchRule {
    static let lunarParadeSuccessCode = "0000"
    static let lunarParadeRetryDelay: UInt64 = 2_000_000_000
    static let lunarParadeAlertInterval: UInt64 = 10_000_000_000
}

private enum LunarParadeReplyField {
    static let lunarParadeCode = "code"
    static let lunarParadeEncryptedResult = "result"
    static let lunarParadeOpenURL = "openValue"
    static let lunarParadePassword = "password"
    static let lunarParadeToken = "token"
    static let lunarParadeLoginFlag = "loginFlag"
    static let lunarParadeLocationFlag = "locationFlag"
}

private struct LunarParadeDecision {
    let lunarParadeRawValue: [String: Any]

    var lunarParadeOpenURL: String {
        lunarParadeRawValue[LunarParadeReplyField.lunarParadeOpenURL] as? String ?? ""
    }

    var lunarParadeIsLoggedIn: Bool {
        lunarParadeNumber(for: LunarParadeReplyField.lunarParadeLoginFlag) == 1
    }

    var lunarParadeNeedsLocation: Bool {
        lunarParadeNumber(for: LunarParadeReplyField.lunarParadeLocationFlag) == 1
    }

    private func lunarParadeNumber(for lunarParadeKey: String) -> Int {
        switch lunarParadeRawValue[lunarParadeKey] {
        case let lunarParadeValue as Int:
            return lunarParadeValue
        case let lunarParadeValue as NSNumber:
            return lunarParadeValue.intValue
        case let lunarParadeValue as String:
            return Int(lunarParadeValue.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        default:
            return 0
        }
    }
}

private enum LunarParadeReplyDecoder {
    static func lunarParadeDecision(from lunarParadeResponse: [String: Any]?) -> LunarParadeDecision? {
        guard lunarParadeResponse?[LunarParadeReplyField.lunarParadeCode] as? String == LunarParadeLaunchRule.lunarParadeSuccessCode,
              let lunarParadeValues = lunarParadeValues(from: lunarParadeResponse) else {
            return nil
        }

        return LunarParadeDecision(lunarParadeRawValue: lunarParadeValues)
    }

    static func lunarParadeValues(from lunarParadeResponse: [String: Any]?) -> [String: Any]? {
        guard let lunarParadeCipherText = lunarParadeResponse?[LunarParadeReplyField.lunarParadeEncryptedResult] as? String else {
            return nil
        }

        let lunarParadePlainText = lunarParadeCipherText.amberCircuitBDecrypt()
        guard let lunarParadeData = lunarParadePlainText.data(using: .utf8) else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: lunarParadeData) as? [String: Any]
    }
}

final class LunarParadeInitUtils {
    static let lunarParadeShared = LunarParadeInitUtils()

    private let lunarParadeAPI = VelvetCometApiCall()
    private var lunarParadeShouldFetchLocation = true

    private init() {}

    fileprivate func lunarParadeLoadDecision() async -> LunarParadeDecision? {
        var lunarParadeWaited: UInt64 = 0

        while Task.isCancelled == false {
            do {
                let lunarParadeResponse = try await lunarParadeAPI.velvetCometGetDecision()
                if let lunarParadeDecision = LunarParadeReplyDecoder.lunarParadeDecision(from: lunarParadeResponse) {
                    return lunarParadeDecision
                }
            } catch {
                // Keep the original silent failure behavior. Polling decides when to show network feedback.
            }

            try? await Task.sleep(nanoseconds: LunarParadeLaunchRule.lunarParadeRetryDelay)
            lunarParadeWaited += LunarParadeLaunchRule.lunarParadeRetryDelay

            if lunarParadeWaited >= LunarParadeLaunchRule.lunarParadeAlertInterval {
                lunarParadeWaited = 0
                await lunarParadeShowToast("Network Error")
            }
        }

        return nil
    }

    func lunarParadeSynchronizePushToken() async {
        let lunarParadePushToken = QuartzMurmurAppStorage.quartzMurmurPushToken
        guard lunarParadePushToken.isEmpty == false,
              lunarParadePushToken != QuartzMurmurAppStorage.quartzMurmurSyncedPushToken else {
            return
        }

        do {
            _ = try await lunarParadeAPI.velvetCometGetDecision()
            QuartzMurmurAppStorage.quartzMurmurSyncedPushToken = lunarParadePushToken
        } catch {
            print("Push token synchronization failed: \(error)")
        }
    }

    func lunarParadeGoLogin() async -> LunarParadeBRoute? {
        do {
            if lunarParadeShouldFetchLocation {
                try await lunarParadeCaptureLocation()
            }

            guard let lunarParadeResponse = try await lunarParadeAPI.velvetCometQuickLogin(),
                  let lunarParadeValues = LunarParadeReplyDecoder.lunarParadeValues(from: lunarParadeResponse) else {
                return nil
            }

            lunarParadeStoreSession(lunarParadeValues)
            return lunarParadeWebRoute()
        } catch {
            await lunarParadeShowToast("error")
            return nil
        }
    }

    fileprivate func lunarParadeApplyDecision(_ lunarParadeDecision: LunarParadeDecision) async -> LunarParadeBRoute? {
        QuartzMurmurAppStorage.quartzMurmurIsB = true
        QuartzMurmurAppStorage.quartzMurmurH5Url = lunarParadeDecision.lunarParadeOpenURL
        lunarParadeStoreSession(lunarParadeDecision.lunarParadeRawValue)

        guard lunarParadeDecision.lunarParadeIsLoggedIn,
              QuartzMurmurAppStorage.quartzMurmurUserToken.isEmpty == false else {
            lunarParadeShouldFetchLocation = lunarParadeDecision.lunarParadeNeedsLocation

            if lunarParadeShouldFetchLocation {
                _ = await AmberCircuitLocationManager.amberCircuitShared.amberCircuitCheckAndRequestLocation()
            }
            return nil
        }

        return lunarParadeWebRoute()
    }

    private func lunarParadeStoreSession(_ lunarParadeValues: [String: Any]) {
        if QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurPassword.isEmpty,
           let lunarParadePassword = lunarParadeValues[LunarParadeReplyField.lunarParadePassword] as? String {
            QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurPassword = lunarParadePassword
        }

        if let lunarParadeToken = lunarParadeValues[LunarParadeReplyField.lunarParadeToken] as? String {
            QuartzMurmurAppStorage.quartzMurmurUserToken = lunarParadeToken
        }
    }

    private func lunarParadeWebRoute() -> LunarParadeBRoute {
        let lunarParadeURL = AmberCircuitInformationCreate.amberCircuitBuildH5Url(
            baseUrl: QuartzMurmurAppStorage.quartzMurmurH5Url,
            token: QuartzMurmurAppStorage.quartzMurmurUserToken
        )
        return .lunarParadeAgreement(lunarParadeURL: lunarParadeURL)
    }

    private func lunarParadeCaptureLocation() async throws {
        guard let lunarParadePlacemark = await AmberCircuitLocationManager.amberCircuitShared.amberCircuitGetCurrentLocationAndAddress(),
              let lunarParadeCoordinate = lunarParadePlacemark.location?.coordinate else {
            throw NSError(domain: "LocationError", code: -1)
        }

        AmberCircuitPhoneInfo.amberCircuitShared.amberCircuitLatitude = lunarParadeCoordinate.latitude
        AmberCircuitPhoneInfo.amberCircuitShared.amberCircuitLongitude = lunarParadeCoordinate.longitude
    }

    @MainActor
    private func lunarParadeShowToast(_ lunarParadeMessage: String) {
        TuxaliFvswlaHUD.toast(.error(lunarParadeMessage))
    }
}

@MainActor
final class LunarParadeInitViewModel: ObservableObject {
    @Published var lunarParadeStatus: LunarParadeInitStatus = .lunarParadeLoading
    @Published var lunarParadeNextRoute: LunarParadeBRoute?

    func lunarParadeInitFlow() async {
        guard lunarParadeIsAvailable else {
            lunarParadeStatus = .lunarParadeA
            return
        }

        QuartzMurmurAppStorage.quartzMurmurIsB = false
        async let lunarParadePhoneInfo: Void = AmberCircuitPhoneInfo.amberCircuitShared.amberCircuitGetPhoneInfo()
        async let lunarParadePushToken: Void = QuartzMurmurAppStorage.quartzMurmurWaitForPushToken()
        _ = await (lunarParadePhoneInfo, lunarParadePushToken)

        guard let lunarParadeDecision = await LunarParadeInitUtils.lunarParadeShared.lunarParadeLoadDecision() else {
            lunarParadeStatus = .lunarParadeA
            return
        }

        lunarParadeNextRoute = await LunarParadeInitUtils.lunarParadeShared.lunarParadeApplyDecision(lunarParadeDecision)
        lunarParadeStatus = .lunarParadeB
    }

    private var lunarParadeIsAvailable: Bool {
        guard let lunarParadeDate = Calendar.current.date(from: AmberCircuitInformationCreate.amberCircuitVerifyDate) else {
            return false
        }

        return Date() >= lunarParadeDate
    }
}
