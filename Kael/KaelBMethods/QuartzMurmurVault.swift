
import Foundation
import Security

// MARK: - Secure Keys

enum QuartzMurmurSecureKey {
    case quartzMurmurDeviceId
    case quartzMurmurPassword

    var quartzMurmurKey: String {
        switch self {
        case .quartzMurmurDeviceId:
            return "quartzMurmurDeviceId4"
        case .quartzMurmurPassword:
            return "quartzMurmurPassword4"
        }
    }
}

// MARK: - Keychain Store

final class QuartzMurmurBInfoStore {

    static let quartzMurmurShared = QuartzMurmurBInfoStore()

    private init() {}

    var quartzMurmurDeviceId: String {
        get { quartzMurmurReadSecureValue(.quartzMurmurDeviceId) ?? "" }
        set { _ = quartzMurmurSaveSecureValue(newValue, for: .quartzMurmurDeviceId) }
    }

    var quartzMurmurPassword: String {
        get { quartzMurmurReadSecureValue(.quartzMurmurPassword) ?? "" }
        set { _ = quartzMurmurSaveSecureValue(newValue, for: .quartzMurmurPassword) }
    }

    private func quartzMurmurSaveSecureValue(_ quartzMurmurValue: String, for quartzMurmurKey: QuartzMurmurSecureKey) -> Bool {
        guard let quartzMurmurData = quartzMurmurValue.data(using: .utf8) else {
            return false
        }

        quartzMurmurDeleteSecureValue(quartzMurmurKey)

        var quartzMurmurQuery = quartzMurmurBaseSecureQuery(for: quartzMurmurKey)
        quartzMurmurQuery[kSecValueData as String] = quartzMurmurData
        quartzMurmurQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        return SecItemAdd(quartzMurmurQuery as CFDictionary, nil) == errSecSuccess
    }

    private func quartzMurmurReadSecureValue(_ quartzMurmurKey: QuartzMurmurSecureKey) -> String? {
        var quartzMurmurQuery = quartzMurmurBaseSecureQuery(for: quartzMurmurKey)
        quartzMurmurQuery[kSecReturnData as String] = true
        quartzMurmurQuery[kSecMatchLimit as String] = kSecMatchLimitOne

        var quartzMurmurResult: AnyObject?
        let quartzMurmurStatus = SecItemCopyMatching(quartzMurmurQuery as CFDictionary, &quartzMurmurResult)

        guard
            quartzMurmurStatus == errSecSuccess,
            let quartzMurmurData = quartzMurmurResult as? Data
        else {
            return nil
        }

        return String(data: quartzMurmurData, encoding: .utf8)
    }

    private func quartzMurmurDeleteSecureValue(_ quartzMurmurKey: QuartzMurmurSecureKey) {
        let quartzMurmurQuery = quartzMurmurBaseSecureQuery(for: quartzMurmurKey)
        SecItemDelete(quartzMurmurQuery as CFDictionary)
    }

    private func quartzMurmurBaseSecureQuery(for quartzMurmurKey: QuartzMurmurSecureKey) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: quartzMurmurKey.quartzMurmurKey
        ]
    }
}

// MARK: - App Storage Keys

enum QuartzMurmurAppStorageKey {
    static let quartzMurmurIsB = "quartzMurmurIsB"
    static let quartzMurmurPushToken = "quartzMurmurPushToken"
    static let quartzMurmurSyncedPushToken = "quartzMurmurSyncedPushToken"
    static let quartzMurmurH5Url = "quartzMurmurH5Url"
    static let quartzMurmurUserToken = "quartzMurmurUserToken"
}

// MARK: - UserDefaults Store

final class QuartzMurmurAppStorage {

    private static let quartzMurmurDefaults = UserDefaults.standard

    static var quartzMurmurIsB: Bool {
        get { quartzMurmurDefaults.bool(forKey: QuartzMurmurAppStorageKey.quartzMurmurIsB) }
        set { quartzMurmurDefaults.set(newValue, forKey: QuartzMurmurAppStorageKey.quartzMurmurIsB) }
    }

    static var quartzMurmurUserToken: String {
        get { quartzMurmurStringValue(for: QuartzMurmurAppStorageKey.quartzMurmurUserToken) }
        set { quartzMurmurDefaults.set(newValue, forKey: QuartzMurmurAppStorageKey.quartzMurmurUserToken) }
    }

    static var quartzMurmurPushToken: String {
        get { quartzMurmurStringValue(for: QuartzMurmurAppStorageKey.quartzMurmurPushToken) }
        set { quartzMurmurDefaults.set(newValue, forKey: QuartzMurmurAppStorageKey.quartzMurmurPushToken) }
    }

    static var quartzMurmurSyncedPushToken: String {
        get { quartzMurmurStringValue(for: QuartzMurmurAppStorageKey.quartzMurmurSyncedPushToken) }
        set { quartzMurmurDefaults.set(newValue, forKey: QuartzMurmurAppStorageKey.quartzMurmurSyncedPushToken) }
    }

    static var quartzMurmurH5Url: String {
        get { quartzMurmurStringValue(for: QuartzMurmurAppStorageKey.quartzMurmurH5Url) }
        set { quartzMurmurDefaults.set(newValue, forKey: QuartzMurmurAppStorageKey.quartzMurmurH5Url) }
    }

    static func quartzMurmurWaitForPushToken() async {
        let quartzMurmurDeadline = Date().addingTimeInterval(3)

        while quartzMurmurPushToken.isEmpty,
              Date() < quartzMurmurDeadline {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
    }

    private static func quartzMurmurStringValue(for quartzMurmurKey: String) -> String {
        quartzMurmurDefaults.string(forKey: quartzMurmurKey) ?? ""
    }
}

var quartzMurmurUsersOrderCode: String = ""
