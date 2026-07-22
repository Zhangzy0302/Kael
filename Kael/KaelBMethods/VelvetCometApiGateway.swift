import AdjustSdk
import Foundation

final class VelvetCometApiCall {
    private let velvetCometSession: URLSession

    init(velvetCometSession: URLSession = .shared) {
        self.velvetCometSession = velvetCometSession
    }

    func velvetCometPayCall(
        purchaseID: String,
        serverVerificationData: String,
        orderCode: String
    ) async throws -> Bool {
        let velvetCometPayload: [String: Any] = [
            "winbalkjcst": purchaseID,
            "qohghakjhcbuap": serverVerificationData,
            "dkjh3LKhlgshc": try velvetCometSerialize(["orderCode": orderCode])
        ]
        print("payload: \(velvetCometPayload)")

        let velvetCometReply = try await velvetCometSend(
            .velvetCometPay,
            payload: velvetCometPayload
        )
        print("pay code: \(velvetCometReply?["code"] ?? "null")")
        return velvetCometReply?["code"] as? String == "0000"
    }

    func velvetCometGetDecision() async throws -> [String: Any]? {
        let velvetCometPhone = AmberCircuitPhoneInfo.amberCircuitShared
        print("initialization pushToken: \(QuartzMurmurAppStorage.quartzMurmurPushToken)")

        return try await velvetCometSend(
            .velvetCometDecision,
            payload: [
                "kb2hlkjbrsd": 1,
                "bpojakkjncbakn": velvetCometPhone.amberCircuitIsVpnActive,
                "vzjoia2liajkdfe": velvetCometPhone.amberCircuitLanguages,
                "ajzlkjglkwmvs": velvetCometPhone.amberCircuitCoverAppList,
                "dkjzlkhqlkjdt": velvetCometPhone.amberCircuitTimezone,
                "dijajhnlkjfdvmk": velvetCometPhone.amberCircuitKeyboards,
                "debug": 1
            ]
        )
    }

    func velvetCometQuickLogin() async throws -> [String: Any]? {
        let velvetCometPhone = AmberCircuitPhoneInfo.amberCircuitShared
        let velvetCometPassword = QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurPassword
        let velvetCometAdjustID = await Adjust.adid()
        var velvetCometPayload: [String: Any] = [
            "pobhLKjhjwaa": velvetCometAdjustID ?? "",
            "cljkLjoijqlokjbd": velvetCometPassword,
            "alkjbjlqihLKjgan": QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId,
            "pakjhbjhsxav": [
                "countryCode": velvetCometPhone.amberCircuitCountryCode,
                "latitude": velvetCometPhone.amberCircuitLatitude,
                "longitude": velvetCometPhone.amberCircuitLongitude
            ]
        ]

        if velvetCometPassword.isEmpty == false {
            velvetCometPayload["cljkLjoijqlokjbd"] = velvetCometPassword
        }

        return try await velvetCometSend(.velvetCometQuickLogin, payload: velvetCometPayload)
    }

    func velvetCometLoadingTimeRecord(_ loadingTime: Int) async throws -> [String: Any]? {
        try await velvetCometSend(
            .velvetCometLoadingTime,
            payload: ["lkjbpihhnuihxo": "\(loadingTime)"]
        )
    }

    private func velvetCometSend(
        _ velvetCometEndpoint: VelvetCometEndpoint,
        payload velvetCometPayload: [String: Any]
    ) async throws -> [String: Any]? {
        let velvetCometPlainText = try velvetCometSerialize(velvetCometPayload)
        let velvetCometEncryptedBody = velvetCometPlainText.amberCircuitBEncode()
        let velvetCometURLString = AmberCircuitInformationCreate.amberCircuitBaseURL + velvetCometEndpoint.velvetCometPath

        guard let velvetCometURL = URL(string: velvetCometURLString) else {
            throw URLError(.badURL)
        }

        var velvetCometRequest = URLRequest(url: velvetCometURL)
        velvetCometRequest.httpMethod = "POST"
        velvetCometRequest.httpBody = velvetCometEncryptedBody.data(using: .utf8)
        velvetCometRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        velvetCometRequest.setValue(AmberCircuitInformationCreate.amberCircuitAppVersion, forHTTPHeaderField: "appVersion")
        velvetCometRequest.setValue(QuartzMurmurBInfoStore.quartzMurmurShared.quartzMurmurDeviceId, forHTTPHeaderField: "deviceNo")
        velvetCometRequest.setValue(QuartzMurmurAppStorage.quartzMurmurPushToken, forHTTPHeaderField: "pushToken")
        velvetCometRequest.setValue(QuartzMurmurAppStorage.quartzMurmurUserToken, forHTTPHeaderField: "loginToken")
        velvetCometRequest.setValue(AmberCircuitInformationCreate.amberCircuitAppId, forHTTPHeaderField: "appId")

        let (velvetCometData, _) = try await velvetCometSession.data(for: velvetCometRequest)
        return try velvetCometDecode(velvetCometData)
    }

    private func velvetCometSerialize(_ velvetCometPayload: [String: Any]) throws -> String {
        let velvetCometData = try JSONSerialization.data(withJSONObject: velvetCometPayload)
        guard let velvetCometText = String(data: velvetCometData, encoding: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }

        return velvetCometText
    }

    private func velvetCometDecode(_ velvetCometData: Data) throws -> [String: Any]? {
        let velvetCometObject = try JSONSerialization.jsonObject(with: velvetCometData)

        if let velvetCometDictionary = velvetCometObject as? [String: Any] {
            return velvetCometDictionary
        }

        guard let velvetCometText = velvetCometObject as? String,
              let velvetCometNestedData = velvetCometText.data(using: .utf8) else {
            return nil
        }

        return try JSONSerialization.jsonObject(with: velvetCometNestedData) as? [String: Any]
    }
}

private enum VelvetCometEndpoint {
    case velvetCometPay
    case velvetCometDecision
    case velvetCometQuickLogin
    case velvetCometLoadingTime

    var velvetCometPath: String {
        switch self {
        case .velvetCometPay:
            return "/opi/v1/Lkjaoifjqkdp"
        case .velvetCometDecision:
            return "/opi/v1/bjakLkjb/aklwihbo"
        case .velvetCometQuickLogin:
            return "/opi/v1/alkjbLIjwacihl"
        case .velvetCometLoadingTime:
            return "/opi/v1/slkjafLKjaiwmbxzt"
        }
    }
}
