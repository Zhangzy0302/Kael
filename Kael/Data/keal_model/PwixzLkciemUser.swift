import SwiftUI
import Combine

struct PwixzLkciemUser: Codable, Identifiable, Equatable {

  let pwixzLkciemUserId: String
  var pwixzLkciemEmail: String
  var pwixzLkciemPassword: String
  var pwixzLkciemUserName: String
  var pwixzLkciemAvatar: String
    var pwixzLkciemAboutMe: String
  var pwixzLkciemFollowing: [String]
  var pwixzLkciemFans: [String]
  var pwixzLkciemBlacklist: [String]
  var pwixzLkciemWalletBalance: Int
    var pwixzLkciemLikePosts: [String]
  var pwixzLkciemIsDeleted: Int

  // MARK: - Identifiable
  var id: String { pwixzLkciemUserId }
    
    func toTargetUser() -> TargetUser {
            return TargetUser(
                userId: pwixzLkciemUserId,
                email: pwixzLkciemEmail,
                password: pwixzLkciemPassword,
                avator: pwixzLkciemAvatar,
                name: pwixzLkciemUserName,
                about: pwixzLkciemAboutMe.isEmpty ? "This user has no description. " : pwixzLkciemAboutMe,
                coins: pwixzLkciemWalletBalance,
                follow: pwixzLkciemFollowing,
                fans: pwixzLkciemFans,
                blockList: pwixzLkciemBlacklist,
                postLikeIds: pwixzLkciemLikePosts,
                isdelete: pwixzLkciemIsDeleted
            )
        }
    
    func convertUsers(_ users: [PwixzLkciemUser]) -> [TargetUser] {
        return users.map { $0.toTargetUser() }
    }
}

extension PwixzLkciemUser {
    
    var pwixzLkciemIsVisitor: Bool {
        pwixzLkciemEmail.isEmpty && pwixzLkciemPassword.isEmpty
    }

    init(json: [String: Any]) {

        self.pwixzLkciemUserId = "\(json["userId"] ?? "")"
        self.pwixzLkciemEmail = json["email"] as? String ?? ""
        self.pwixzLkciemPassword = "\(json["password"] ?? "")"
        self.pwixzLkciemUserName = json["name"] as? String ?? ""
        self.pwixzLkciemAvatar = json["avator"] as? String ?? ""
        self.pwixzLkciemAboutMe = json["about"] as? String ?? ""
        self.pwixzLkciemWalletBalance = json["coins"] as? Int ?? 0
        self.pwixzLkciemIsDeleted = json["isdelete"] as? Int ?? 0

        // 数组转换（兼容 __NSArrayM）
        self.pwixzLkciemFollowing = (json["follow"] as? [Any])?.map { "\($0)" } ?? []
        self.pwixzLkciemFans = (json["fans"] as? [Any])?.map { "\($0)" } ?? []
        self.pwixzLkciemBlacklist = (json["blockList"] as? [Any])?.map { "\($0)" } ?? []
        self.pwixzLkciemLikePosts = (json["postLikeIds"] as? [Any])?.map { "\($0)" } ?? []
    }
    
    static func fromJsonArray(_ array: [[String: Any]]) -> [PwixzLkciemUser] {
            return array.map { PwixzLkciemUser(json: $0) }
        }
}

struct TargetUser: Codable {
    var userId: String
    var email: String
    var password: String
    var avator: String
    var name: String
    var about: String
    var coins: Int
    var follow: [String]
    var fans: [String]
    var blockList: [String]
    var postLikeIds: [String]
    var isdelete: Int
}


@MainActor
final class PwixzLkciemUserViewModel: ObservableObject {

  @Published var users: [PwixzLkciemUser] = []
  @Published var currentUser: PwixzLkciemUser?
  @Published var userInfo: PwixzLkciemUser?
    @Published var currentUserID: String = "95959"

  private let storage = KaelIwuzHacStorageManager.shared

  func getPwixzLkciemUserInfoByUid(uid: String) {
    userInfo = storage.getUserById(userId: uid)
  }

  func returnPwixzLkciemUserInfoById(userId: String) -> PwixzLkciemUser? {
    storage.getUserById(userId: userId)
  }

  func loadLoginPwixzLkciemUser() {
    users = storage.getUsers()

    let uid: String = storage.getCurrentUserId()
      currentUserID = uid
    currentUser = users.first { $0.pwixzLkciemUserId == uid }
  }
    
  var isCurrentUserVisitor: Bool {
    currentUser?.pwixzLkciemIsVisitor ?? false
  }

  // 登录
  func loginByEmailAndPasswordPwixzLkciem(email: String, password: String) -> PwixzLkciemUser? {
    let users = storage.getUsers()
    guard
      let matchUser = users.first(where: {
        $0.pwixzLkciemEmail == email && $0.pwixzLkciemPassword == password && $0.pwixzLkciemIsDeleted == 0
      })
    else {
      return nil
    }

    // 记录登录态
    storage.setCurrentUserId(matchUser.pwixzLkciemUserId)
      currentUserID = matchUser.pwixzLkciemUserId
    loadLoginPwixzLkciemUser()
    return matchUser
  }

  // 游客登录
    func visitorLoginPwixzLkciem() {
        
        let users = storage.getUsers()
        
        // ✅ 1. 查找已有游客（email & password 为空 + 未删除）
        if let existVisitor = users.first(where: {
            $0.pwixzLkciemIsVisitor &&
            $0.pwixzLkciemIsDeleted == 0
        }) {
            print(existVisitor)
//            print("✅ 使用已有游客:", existVisitor.pwixzLkciemUserId)
            
            storage.setCurrentUserId(existVisitor.pwixzLkciemUserId)
            loadLoginPwixzLkciemUser()
            return
        }
        
        // ❌ 2. 没有游客 → 创建新游客
        let newId = "\(Int(Date().timeIntervalSince1970))" // ✅ 推荐用时间戳避免重复
        
        let newUser = PwixzLkciemUser(
            pwixzLkciemUserId: newId,
            pwixzLkciemEmail: "",
            pwixzLkciemPassword: "",
            pwixzLkciemUserName: "Visitor_\(newId)",
            pwixzLkciemAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/vnewiaADefaultAva.png",
            pwixzLkciemAboutMe: "",
            pwixzLkciemFollowing: [],
            pwixzLkciemFans: [],
            pwixzLkciemBlacklist: [],
            pwixzLkciemWalletBalance: 0,
            pwixzLkciemLikePosts: [],
            pwixzLkciemIsDeleted: 0
        )
        
        print("🆕 创建新游客:", newId)
        
        storage.addUser(user: newUser)
        storage.setCurrentUserId(newUser.pwixzLkciemUserId)
        
        loadLoginPwixzLkciemUser()
    }

  // 删除账号
  func deleteAccountPwixzLkciem() {
      storage.removeCurrentUserAllWorks()
      storage.removeCurrentUserChatRooms()
      storage.removeCurrentUserAllComments()
      // ✅ 1. 标记删除
      storage.updateUser(uid: storage.getCurrentUserId()) { user in
          var newUser = user
          newUser.pwixzLkciemIsDeleted = 1
          return newUser
      }
    storage.setCurrentUserId("95959")
      currentUserID = "95959"
    loadLoginPwixzLkciemUser()
  }

  // 注册
  func registerPwixzLkciem(email: String, password: String) -> PwixzLkciemUser? {
    let users = storage.getUsers()
    guard
      users.first(where: { $0.pwixzLkciemEmail == email }) == nil
    else {
      return nil
    }

    let newUser: PwixzLkciemUser = PwixzLkciemUser(
      pwixzLkciemUserId: "\(users.count)",
      pwixzLkciemEmail: email,
      pwixzLkciemPassword: password,
      pwixzLkciemUserName: "User_" + String(users.count),
      pwixzLkciemAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/vnewiaADefaultAva.png",
      pwixzLkciemAboutMe: "",
      pwixzLkciemFollowing: [],
      pwixzLkciemFans: [],
      pwixzLkciemBlacklist: [],
      pwixzLkciemWalletBalance: 0,
      pwixzLkciemLikePosts: [],
      pwixzLkciemIsDeleted: 0
    )

    storage.addUser(user: newUser)
    storage.setCurrentUserId(newUser.pwixzLkciemUserId)
    loadLoginPwixzLkciemUser()
    return newUser
  }

  // 登出
  func logoutPwixzLkciem() {
    storage.setCurrentUserId("95959")
    loadLoginPwixzLkciemUser()
  }
    
  // 修改用户信息
  func editPwixzLkciemUserInfo(name: String, avatar: String) {
    guard let currentUser else { return }
    storage.updateUser(uid: currentUser.pwixzLkciemUserId) { user in
      var newUser: PwixzLkciemUser = user
      newUser.pwixzLkciemUserName = name
      newUser.pwixzLkciemAvatar = avatar
      return newUser
    }

    loadLoginPwixzLkciemUser()
  }

  // 切换拉黑状态
  func toggleUserIsBlocked(blockUserId: String) {
    guard let currentUser, !currentUser.pwixzLkciemIsVisitor else { return }
    storage.updateUser(uid: currentUser.pwixzLkciemUserId) { user in
      var newUser: PwixzLkciemUser = user
      if newUser.pwixzLkciemBlacklist.contains(blockUserId) {
        newUser.pwixzLkciemBlacklist.removeAll { $0 == blockUserId }
      } else {
        newUser.pwixzLkciemBlacklist.append(blockUserId)
      }

      return newUser
    }

    loadLoginPwixzLkciemUser()
  }

  // 切换是否喜欢视频作品
  func toggleVideoIsLiked(_ videoId: String) {
    guard let currentUser, !currentUser.pwixzLkciemIsVisitor else { return }
    storage.updateUser(uid: currentUser.pwixzLkciemUserId) { user in
      var newUser: PwixzLkciemUser = user
      if newUser.pwixzLkciemLikePosts.contains(videoId) {
        newUser.pwixzLkciemLikePosts.removeAll { $0 == videoId }
          storage.decreaseLikeCount(workId: videoId)
      } else {
        newUser.pwixzLkciemLikePosts.append(videoId)
          storage.increaseLikeCount(workId: videoId)
      }
      return newUser
    }
    loadLoginPwixzLkciemUser()
  }


  // 更新用户钻石数
  func increaseUserDiamond(diamond: Int) {
    guard let currentUser, !currentUser.pwixzLkciemIsVisitor else { return }
    storage.updateUser(uid: currentUser.pwixzLkciemUserId) { user in
      var newUser: PwixzLkciemUser = user
      newUser.pwixzLkciemWalletBalance = newUser.pwixzLkciemWalletBalance + diamond
      return newUser
    }

    loadLoginPwixzLkciemUser()
  }
}
