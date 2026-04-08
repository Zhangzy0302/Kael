import SwiftUI
import Combine

struct MxhwiUAhxgswChatRoom: Codable, Identifiable, Equatable {

  let mxhwiUAhxgswRoomId: String
  var mxhwiUAhxgswChatUsers: [String]
  var mxhwiUAhxgswLastSendMsg: String
  var mxhwiUAhxgswLastSendTime: Date
    var mxhwiUAhxgswLastSendUser: String
  var mxhwiUAhxgswUnreadCount: Int

  var id: String { mxhwiUAhxgswRoomId }
    
    func toTargetChatRoom() -> TargetChatRoom {
        return TargetChatRoom(
            chatId: mxhwiUAhxgswRoomId,
            chatUserIds: mxhwiUAhxgswChatUsers,
            lastSendContent: mxhwiUAhxgswLastSendMsg,
            lastSendTime: mxhwiUAhxgswLastSendTime.toJSString(),
            unreadMsgCount: mxhwiUAhxgswUnreadCount,
            lastSendUserId: mxhwiUAhxgswLastSendUser
        )
    }
}

extension MxhwiUAhxgswChatRoom {

    init(json: [String: Any]) {

        self.mxhwiUAhxgswRoomId = "\(json["chatId"] ?? "")"
        self.mxhwiUAhxgswLastSendMsg = json["lastSendContent"] as? String ?? ""
        self.mxhwiUAhxgswLastSendUser = "\(json["lastSendUserId"] ?? "")"
        self.mxhwiUAhxgswUnreadCount = json["unreadMsgCount"] as? Int ?? 0

        // 👇 用户数组
        self.mxhwiUAhxgswChatUsers = (json["chatUserIds"] as? [Any])?
            .map { "\($0)" } ?? []

        // 👇 时间转换（String → Date）
        let timeStr = json["lastSendTime"] as? String ?? ""
        self.mxhwiUAhxgswLastSendTime = Date.fromJSString(timeStr)
    }
    
    static func fromJsonArray(_ array: [[String: Any]]) -> [MxhwiUAhxgswChatRoom] {
            array.map { MxhwiUAhxgswChatRoom(json: $0) }
        }
}

struct TargetChatRoom: Codable {
    let chatId: String
    let chatUserIds: [String]
    let lastSendContent: String
    let lastSendTime: String
    let unreadMsgCount: Int
    let lastSendUserId: String
}

struct MxhwiUAhxgswMessage: Codable, Identifiable, Equatable {

  let mxhwiUAhxgswMsgId: String

  var mxhwiUAhxgswRoomId: String
  var mxhwiUAhxgswSendUserId: String
  var mxhwiUAhxgswTextMsg: String
  var mxhwiUAhxgswImageMsg: String
  var mxhwiUAhxgswDate: Date
    
    var id: String { mxhwiUAhxgswMsgId }
    
    func toTargetMessage() -> TargetMessage {
        return TargetMessage(
            msgId: mxhwiUAhxgswMsgId,
            chatId: mxhwiUAhxgswRoomId,
            userId: mxhwiUAhxgswSendUserId,
            sendContent: mxhwiUAhxgswTextMsg,
            sendPicUrl: mxhwiUAhxgswImageMsg,
            sendTime: mxhwiUAhxgswDate.toJSString()
        )
    }
}

extension MxhwiUAhxgswMessage {

    init(json: [String: Any]) {

        self.mxhwiUAhxgswMsgId = "\(json["msgId"] ?? "")"
        self.mxhwiUAhxgswRoomId = "\(json["chatId"] ?? "")"
        self.mxhwiUAhxgswSendUserId = "\(json["userId"] ?? "")"

        self.mxhwiUAhxgswTextMsg = json["sendContent"] as? String ?? ""
        self.mxhwiUAhxgswImageMsg = json["sendPicUrl"] as? String ?? ""

        // 👇 时间
        let timeStr = json["sendTime"] as? String ?? ""
        self.mxhwiUAhxgswDate = Date.fromJSString(timeStr)
    }
    
    static func fromJsonArray(_ array: [[String: Any]]) -> [MxhwiUAhxgswMessage] {
            array.map { MxhwiUAhxgswMessage(json: $0) }
        }
}

struct TargetMessage: Codable {
    let msgId: String
    let chatId: String
    let userId: String
    let sendContent: String
    let sendPicUrl: String
    let sendTime: String
}

extension Date {
    
    func toJSString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    static func fromJSString(_ str: String) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.date(from: str) ?? Date()
        }
}

@MainActor
final class MxhwiUAhxgswChatViewModel: ObservableObject {

  @Published var myChatRooms: [MxhwiUAhxgswChatRoom] = []
  @Published var chatMessageList: [MxhwiUAhxgswMessage] = []

  private let storage = KaelIwuzHacStorageManager.shared

  func getMxhwiUAhxgswChatUserId(chatRoomId: String) -> String? {
    guard
      let chatRoomInfo = storage.getChatRooms().first(where: {
        $0.mxhwiUAhxgswRoomId == chatRoomId
      })
    else {
      return nil
    }
    guard
      let chatUserId = chatRoomInfo.mxhwiUAhxgswChatUsers.first(where: {
        $0 != storage.getCurrentUserId()
      })
    else {
      return nil
    }

    return chatUserId
  }

  func getMyMxhwiUAhxgswChatRoomsNotBlock() -> [MxhwiUAhxgswChatRoom] {
    let bhajaAllChatRooms = storage.getChatRooms()
    let loginUserId = storage.getCurrentUserId()
    guard let myInfo = storage.getUserById(userId: loginUserId) else {
      return []
    }

    let myMxhwiUAhxgswChatRooms = bhajaAllChatRooms.filter {
      if let chatUserId = getMxhwiUAhxgswChatUserId(chatRoomId: $0.mxhwiUAhxgswRoomId) {
        $0.mxhwiUAhxgswChatUsers.contains(loginUserId)
          && !myInfo.pwixzLkciemBlacklist.contains(chatUserId)
      } else {
        false
      }

    }
      
      return myMxhwiUAhxgswChatRooms
  }

  // 获取聊天用户信息
  func getMxhwiUAhxgswChatUserInfo(chatRoomId: String) -> PwixzLkciemUser? {
    guard let chatUserId = getMxhwiUAhxgswChatUserId(chatRoomId: chatRoomId) else {
      return nil
    }
    return storage.getUserById(userId: chatUserId)
  }

}
