import Foundation
import SwiftUI

final class KaelIwuzHacStorageManager {

  static let shared = KaelIwuzHacStorageManager()
  private init() {}

  private let storage = UserDefaults.standard

  // MARK: - Keys
  private enum Keys {
    static let pwixzLkciemUsers: String = "pwixzLkciemUsers"
    static let rwyclaHurgrWorks: String = "rwyclaHurgrWorks"
    static let nauxuJFeComments: String = "nauxuJFeComments"
    static let mxhwiUAhxgswChatRooms: String = "mxhwiUAhxgswChatRooms"
    static let mxhwiUAhxgswMessages: String = "mxhwiUAhxgswMessages"
    static let cosplayPosts: String = "cosplayPosts"
    static let sienAlxjbjCurrentUserId: String = "sienAlxjbjCurrentUserId"
  }
}

extension KaelIwuzHacStorageManager {

  func initializeAllDefaults() {
    initializeUsersIfNeeded()
    initializeWorksIfNeeded()
    initializeCommentsIfNeeded()
    initializeChatRoomsIfNeeded()
    initializeMessagesIfNeeded()
  }

}

//User CRUD & 登录态
extension KaelIwuzHacStorageManager {

  private func initializeUsersIfNeeded() {
    guard storage.data(forKey: Keys.pwixzLkciemUsers) == nil else { return }

    let users: [PwixzLkciemUser] = [
      PwixzLkciemUser(
        pwixzLkciemUserId: "0",
        pwixzLkciemEmail: "test@gmail.com",
        pwixzLkciemPassword: "654321",
        pwixzLkciemUserName: "Barton",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_0.jpg",
        pwixzLkciemAboutMe: "Make friends with the wind, and keep company with the road.",
        pwixzLkciemFollowing: ["1", "2"],
        pwixzLkciemFans: ["4", "5"],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
      PwixzLkciemUser(
        pwixzLkciemUserId: "1",
        pwixzLkciemEmail: "Carlos@gmail.com",
        pwixzLkciemPassword: "wi28ja29jad",
        pwixzLkciemUserName: "Carlos",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_1.jpg",
        pwixzLkciemAboutMe: "Ride into the wilderness, without caring about the destination.",
        pwixzLkciemFollowing: [],
        pwixzLkciemFans: ["0"],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
      PwixzLkciemUser(
        pwixzLkciemUserId: "2",
        pwixzLkciemEmail: "Willisasd@gmail.com",
        pwixzLkciemPassword: "2u8hd8aks",
        pwixzLkciemUserName: "Willis",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_2.jpg",
        pwixzLkciemAboutMe: "Those who chase the wind are always on the road.",
        pwixzLkciemFollowing: [],
        pwixzLkciemFans: ["0"],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
      PwixzLkciemUser(
        pwixzLkciemUserId: "3",
        pwixzLkciemEmail: "32asdAw3a@gmail.com",
        pwixzLkciemPassword: "wqsd23sad",
        pwixzLkciemUserName: "Haley",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_3.jpg",
        pwixzLkciemAboutMe: "The road lies beneath our feet, and the wind follows behind us.",
        pwixzLkciemFollowing: [],
        pwixzLkciemFans: [],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
      PwixzLkciemUser(
        pwixzLkciemUserId: "4",
        pwixzLkciemEmail: "32fgdgehwv@gmail.com",
        pwixzLkciemPassword: "d21g2waas",
        pwixzLkciemUserName: "Christy",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_4.jpg",
        pwixzLkciemAboutMe: "Our hearts yearn for the vast wilderness, and our steps never cease.",
        pwixzLkciemFollowing: ["0"],
        pwixzLkciemFans: [],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
      PwixzLkciemUser(
        pwixzLkciemUserId: "5",
        pwixzLkciemEmail: "sfaAd3ga@gmail.com",
        pwixzLkciemPassword: "jy64f2sasd",
        pwixzLkciemUserName: "Sophia",
        pwixzLkciemAvatar:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/kfukuruKuw_5.jpg",
        pwixzLkciemAboutMe: "With a lifetime of passion, we never stop moving forward.",
        pwixzLkciemFollowing: ["0"],
        pwixzLkciemFans: [],
        pwixzLkciemBlacklist: [],
        pwixzLkciemWalletBalance: 0,
        pwixzLkciemLikePosts: [],
        pwixzLkciemIsDeleted: 0
      ),
    ]

    save(users, forKey: Keys.pwixzLkciemUsers)
  }

  func getUsers() -> [PwixzLkciemUser] {
    load([PwixzLkciemUser].self, forKey: Keys.pwixzLkciemUsers, default: [])
  }

  func saveUsers(_ users: [PwixzLkciemUser]) {
    save(users, forKey: Keys.pwixzLkciemUsers)
  }

  func getUserById(userId: String) -> PwixzLkciemUser? {
    let allUsers = getUsers()
    // 查找第一个 userId 匹配的用户
    return allUsers.first { $0.pwixzLkciemUserId == userId }
  }

  func updateUser(
    uid: String,
    update: (PwixzLkciemUser) -> PwixzLkciemUser
  ) {
    var users = getUsers()
    guard let index = users.firstIndex(where: { $0.pwixzLkciemUserId == uid }) else { return }
    users[index] = update(users[index])
    saveUsers(users)
  }

  // add user
  func addUser(user: PwixzLkciemUser) {
    var users: [PwixzLkciemUser] = getUsers()
    users.append(user)
    saveUsers(users)
  }

  // MARK: Login State
  func setCurrentUserId(_ uid: String) {
    storage.set(uid, forKey: Keys.sienAlxjbjCurrentUserId)
  }

  func getCurrentUserId() -> String {
    return storage.object(forKey: Keys.sienAlxjbjCurrentUserId) as? String ?? "95959"
  }
    
  func currentUserIsVisitor() -> Bool {
    guard let currentUser = getUserById(userId: getCurrentUserId()) else { return false }
    return currentUser.pwixzLkciemIsVisitor && currentUser.pwixzLkciemIsDeleted == 0
  }
    
    func markCurrentUserDeleted() {
        let currentUserId = getCurrentUserId()
        
        updateUser(uid: currentUserId) { user in
            var updated = user
            updated.pwixzLkciemIsDeleted = 1
            return updated
        }
    }

}

//work
extension KaelIwuzHacStorageManager {

  private func initializeWorksIfNeeded() {
    guard storage.data(forKey: Keys.rwyclaHurgrWorks) == nil else { return }

    let rwyclaHurgrWorks: [RwyclaHurgrVideo] = [
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "0",
        rwyclaHurgrCreatorId: "0",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent: "At 6 pm, watch the setting sun and allow yourself to relax.",
        rwyclaHurgrTitleType: 0,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_0.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_0.png"],
        rwyclaHurgrLikeCount: 397,
        rwyclaHurgrCommentCount: 1),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "1",
        rwyclaHurgrCreatorId: "1",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent:
          "Just a guy that loves riding bikes",
        rwyclaHurgrTitleType: 1,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_1.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_1.png"],
        rwyclaHurgrLikeCount: 727,
        rwyclaHurgrCommentCount: 2),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "2",
        rwyclaHurgrCreatorId: "2",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent:
          "Keep moving forward, for all the beauty lies on the journey.",
        rwyclaHurgrTitleType: 2,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_2.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_2.png"],
        rwyclaHurgrLikeCount: 986,
        rwyclaHurgrCommentCount: 1),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "3",
        rwyclaHurgrCreatorId: "3",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent: "First outdoor ride of the season is going to hit the spot",
        rwyclaHurgrTitleType: 1,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_3.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_3.png"],
        rwyclaHurgrLikeCount: 657,
        rwyclaHurgrCommentCount: 1),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "4",
        rwyclaHurgrCreatorId: "4",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent: "Taking a ride on a bike while enjoying the breeze.",
        rwyclaHurgrTitleType: 2,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_4.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_4.png"],
        rwyclaHurgrLikeCount: 1397,
        rwyclaHurgrCommentCount: 0),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "5",
        rwyclaHurgrCreatorId: "5",
        rwyclaHurgrType: 1,
        rwyclaHurgrTextContent: "Everyone’s favorite descent on the bike",
        rwyclaHurgrTitleType: 0,
        rwyclaHurgrVideoUrl:
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_5.mp4",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/iwioaAciw_cover_5.png"],
        rwyclaHurgrLikeCount: 221,
        rwyclaHurgrCommentCount: 0),
      //image
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "6",
        rwyclaHurgrCreatorId: "2",
        rwyclaHurgrType: 0,
        rwyclaHurgrTextContent: "Conquer every uphill stretch, enjoy every downhill ride.",
        rwyclaHurgrTitleType: 0,
        rwyclaHurgrVideoUrl:
          "",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_0.jpg",
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_1.jpg",
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_2.png"],
        rwyclaHurgrLikeCount: 397,
        rwyclaHurgrCommentCount: 1),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "7",
        rwyclaHurgrCreatorId: "1",
        rwyclaHurgrType: 0,
        rwyclaHurgrTextContent: "The wheels trample through the wind and rain, and love surmounts all difficulties.",
        rwyclaHurgrTitleType: 1,
        rwyclaHurgrVideoUrl:
          "",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_3.jpg",
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_4.png",
           "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_5.jpg"],
        rwyclaHurgrLikeCount: 523,
        rwyclaHurgrCommentCount: 2),
      RwyclaHurgrVideo(
        rwyclaHurgrWorkId: "8",
        rwyclaHurgrCreatorId: "0",
        rwyclaHurgrType: 0,
        rwyclaHurgrTextContent: "Set out, it is always the most meaningful thing.",
        rwyclaHurgrTitleType: 0,
        rwyclaHurgrVideoUrl:
          "",
        rwyclaHurgrPic:
          ["http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_6.jpg",
          "http://huanniuchat.oss-accelerate.aliyuncs.com/Kael2026/tyauelkwAwi_7.jpg"],
        rwyclaHurgrLikeCount: 584,
        rwyclaHurgrCommentCount: 0),
    ]
    save(rwyclaHurgrWorks, forKey: Keys.rwyclaHurgrWorks)
  }

  func getWorks() -> [RwyclaHurgrVideo] {
    load([RwyclaHurgrVideo].self, forKey: Keys.rwyclaHurgrWorks, default: [])
  }
    
    func saveWorks(_ works: [RwyclaHurgrVideo]) {
        save(works, forKey: Keys.rwyclaHurgrWorks)
    }

  func getWorksNotBlock() -> [RwyclaHurgrVideo] {
    let allWorks = getWorks()
    let currentUserInfo = getUserById(userId: getCurrentUserId())

    // 用 $0 指代遍历的每个 work 元素
    return allWorks.filter {
      guard let blacklist = currentUserInfo?.pwixzLkciemBlacklist else { return true }
      return !blacklist.contains($0.rwyclaHurgrCreatorId)
    }
  }

  func getWorkDetailById(workId: String) -> RwyclaHurgrVideo? {
    let allWorks = getWorks()
    guard
      let workDetail = allWorks.first(where: {
        $0.rwyclaHurgrWorkId == workId
      })
    else {
      return nil
    }

    return workDetail
  }

  func addWork(_ work: RwyclaHurgrVideo) {
    var rwyclaHurgrWorks = getWorks()
    rwyclaHurgrWorks.insert(work, at: 0)
    save(rwyclaHurgrWorks, forKey: Keys.rwyclaHurgrWorks)
  }

  func updateWork(_ work: RwyclaHurgrVideo) {
    var rwyclaHurgrWorks = getWorks()
    guard
      let index = rwyclaHurgrWorks.firstIndex(where: {
        $0.rwyclaHurgrWorkId == work.rwyclaHurgrWorkId
      })
    else {
      return
    }

    rwyclaHurgrWorks[index] = work
  }
    
    // like + 1
    func increaseLikeCount(workId: String) {
        var rwyclaHurgrWorks = getWorks()
        
        guard let index = rwyclaHurgrWorks.firstIndex(where: {
            $0.rwyclaHurgrWorkId == workId
        }) else {
            return
        }
        
        rwyclaHurgrWorks[index].rwyclaHurgrLikeCount += 1
        
        save(rwyclaHurgrWorks, forKey: Keys.rwyclaHurgrWorks)
    }
    
    // like - 1
    func decreaseLikeCount(workId: String) {
        var rwyclaHurgrWorks = getWorks()
        
        guard let index = rwyclaHurgrWorks.firstIndex(where: {
            $0.rwyclaHurgrWorkId == workId
        }) else {
            return
        }
        
        if rwyclaHurgrWorks[index].rwyclaHurgrLikeCount > 0 {
            rwyclaHurgrWorks[index].rwyclaHurgrLikeCount -= 1
        }
        
        save(rwyclaHurgrWorks, forKey: Keys.rwyclaHurgrWorks)
    }

    //删除
    func removeCurrentUserAllWorks() {
        let currentUserId = getCurrentUserId()
        
        guard !currentUserId.isEmpty else { return }
        
        let allWorks = getWorks()
        
        // 过滤掉当前用户的作品
        let filteredWorks = allWorks.filter {
            $0.rwyclaHurgrCreatorId != currentUserId
        }
        
        save(filteredWorks, forKey: Keys.rwyclaHurgrWorks)
    }
}

//Comment
extension KaelIwuzHacStorageManager {

  private func initializeCommentsIfNeeded() {
    guard storage.data(forKey: Keys.nauxuJFeComments) == nil else { return }
      
      let nauxuJFeCommentList: [NauxuJFeComment] = [
        NauxuJFeComment(
            nauxuJFeCommentId: "0",
            nauxuJFeCommentWorkId: "0",
            nauxuJFeCommentUserId: "2",
            nauxuJFeCommentText: "Wow, the sunset is absolutely stunning!"),
        NauxuJFeComment(
            nauxuJFeCommentId: "1",
            nauxuJFeCommentWorkId: "1",
            nauxuJFeCommentUserId: "5",
            nauxuJFeCommentText: "The scenery is really beautiful."),
        NauxuJFeComment(
            nauxuJFeCommentId: "2",
            nauxuJFeCommentWorkId: "2",
            nauxuJFeCommentUserId: "3",
            nauxuJFeCommentText: "Great!"),
        NauxuJFeComment(
            nauxuJFeCommentId: "3",
            nauxuJFeCommentWorkId: "3",
            nauxuJFeCommentUserId: "2",
            nauxuJFeCommentText: "You are stunning!"),
        NauxuJFeComment(
            nauxuJFeCommentId: "4",
            nauxuJFeCommentWorkId: "1",
            nauxuJFeCommentUserId: "2",
            nauxuJFeCommentText: "beautiful day for a ride I just finished mine keep pushing it cycling Sister"),
        NauxuJFeComment(
            nauxuJFeCommentId: "5",
            nauxuJFeCommentWorkId: "6",
            nauxuJFeCommentUserId: "4",
            nauxuJFeCommentText: "I need to feel this again"),
        NauxuJFeComment(
            nauxuJFeCommentId: "6",
            nauxuJFeCommentWorkId: "7",
            nauxuJFeCommentUserId: "3",
            nauxuJFeCommentText: "Like the female lead in the movie."),
        NauxuJFeComment(
            nauxuJFeCommentId: "7",
            nauxuJFeCommentWorkId: "7",
            nauxuJFeCommentUserId: "2",
            nauxuJFeCommentText: "The nice weather makes going for a bike ride really relaxing."),
        NauxuJFeComment(
            nauxuJFeCommentId: "8",
            nauxuJFeCommentWorkId: "8",
            nauxuJFeCommentUserId: "1",
            nauxuJFeCommentText: "Cool!"),
      ]
    save(nauxuJFeCommentList, forKey: Keys.nauxuJFeComments)
  }
    
    func saveComments(_ commentsList: [NauxuJFeComment]) {
        save(commentsList, forKey: Keys.nauxuJFeComments)
    }

  func getComments(for workId: String) -> [NauxuJFeComment] {
    load([NauxuJFeComment].self, forKey: Keys.nauxuJFeComments, default: [])
      .filter { $0.nauxuJFeCommentWorkId == workId }
  }

  // 获取所有评论
  func getAllComments() -> [NauxuJFeComment] {
    load([NauxuJFeComment].self, forKey: Keys.nauxuJFeComments, default: [])
  }

  func addComment(_ comment: NauxuJFeComment) {
    var nauxuJFeComments = load(
      [NauxuJFeComment].self, forKey: Keys.nauxuJFeComments, default: [])
    nauxuJFeComments.append(comment)
    save(nauxuJFeComments, forKey: Keys.nauxuJFeComments)
  }
    
    func removeCurrentUserAllComments() {
        let currentUserId = getCurrentUserId()
        
        guard !currentUserId.isEmpty else { return }
        
        let allComments = getAllComments()
        
        // 过滤掉当前用户的评论
        let filteredComments = allComments.filter {
            $0.nauxuJFeCommentUserId != currentUserId
        }
        
        save(filteredComments, forKey: Keys.nauxuJFeComments)
    }
}

//ChatRoom & Message
extension KaelIwuzHacStorageManager {

  private func initializeChatRoomsIfNeeded() {
    guard storage.data(forKey: Keys.mxhwiUAhxgswChatRooms) == nil else { return }
    save([MxhwiUAhxgswChatRoom](), forKey: Keys.mxhwiUAhxgswChatRooms)
  }
    
    func saveChatRooms(_ chatRooms: [MxhwiUAhxgswChatRoom]) {
        save(chatRooms, forKey: Keys.mxhwiUAhxgswChatRooms)
    }
    
    func saveChatMessageList(_ msgList: [MxhwiUAhxgswMessage]) {
        save(msgList, forKey: Keys.mxhwiUAhxgswMessages)
    }

  func getChatRooms() -> [MxhwiUAhxgswChatRoom] {
    load([MxhwiUAhxgswChatRoom].self, forKey: Keys.mxhwiUAhxgswChatRooms, default: [])
  }

  // 创建聊天室
  func createChatRoom(chatUsersId: [String]) -> MxhwiUAhxgswChatRoom {
    var mxhwiUAhxgswChatRooms: [MxhwiUAhxgswChatRoom] = getChatRooms()
    let newRoom: MxhwiUAhxgswChatRoom = MxhwiUAhxgswChatRoom(
      mxhwiUAhxgswRoomId: "\(mxhwiUAhxgswChatRooms.count)",
      mxhwiUAhxgswChatUsers: chatUsersId,
      mxhwiUAhxgswLastSendMsg: "",
      mxhwiUAhxgswLastSendTime: Date(),
      mxhwiUAhxgswLastSendUser: getCurrentUserId(),
      mxhwiUAhxgswUnreadCount: 0
    )
    mxhwiUAhxgswChatRooms.append(newRoom)
    save(mxhwiUAhxgswChatRooms, forKey: Keys.mxhwiUAhxgswChatRooms)

    return newRoom
  }
  // 更新聊天室
  func updateChatRoom(roomId: String, update: (MxhwiUAhxgswChatRoom) -> MxhwiUAhxgswChatRoom) {
    var mxhwiUAhxgswChatRooms: [MxhwiUAhxgswChatRoom] = getChatRooms()
    guard let index = mxhwiUAhxgswChatRooms.firstIndex(where: { $0.mxhwiUAhxgswRoomId == roomId })
    else {
      return
    }
    mxhwiUAhxgswChatRooms[index] = update(mxhwiUAhxgswChatRooms[index])
    save(mxhwiUAhxgswChatRooms, forKey: Keys.mxhwiUAhxgswChatRooms)
  }
    
    func removeCurrentUserChatRooms() {
        let currentUserId = getCurrentUserId()
        
        guard !currentUserId.isEmpty else { return }
        
        let allRooms = getChatRooms()
        
        // 过滤掉包含当前用户的聊天室
        let filteredRooms = allRooms.filter {
            !$0.mxhwiUAhxgswChatUsers.contains(currentUserId)
        }
        
        save(filteredRooms, forKey: Keys.mxhwiUAhxgswChatRooms)
    }

    // message
  private func initializeMessagesIfNeeded() {
    guard storage.data(forKey: Keys.mxhwiUAhxgswMessages) == nil else { return }
    save([MxhwiUAhxgswMessage](), forKey: Keys.mxhwiUAhxgswMessages)
  }
    
    func getAllMessages() -> [MxhwiUAhxgswMessage] {
      return load([MxhwiUAhxgswMessage].self, forKey: Keys.mxhwiUAhxgswMessages, default: [])
    }

  func getMessages(roomId: String) -> [MxhwiUAhxgswMessage] {
    return load([MxhwiUAhxgswMessage].self, forKey: Keys.mxhwiUAhxgswMessages, default: [])
      .filter { $0.mxhwiUAhxgswRoomId == roomId }
  }
    

  func addMessage(_ msg: MxhwiUAhxgswMessage) {
    var mxhwiUAhxgswMessages = load(
      [MxhwiUAhxgswMessage].self, forKey: Keys.mxhwiUAhxgswMessages, default: [])
    mxhwiUAhxgswMessages.append(msg)
    save(mxhwiUAhxgswMessages, forKey: Keys.mxhwiUAhxgswMessages)
  }
}

//底层通用存取（核心）
extension KaelIwuzHacStorageManager {

  fileprivate func save<T: Codable>(_ value: T, forKey key: String) {
    if let data = try? JSONEncoder().encode(value) {
      storage.set(data, forKey: key)
    }
  }

  fileprivate func load<T: Codable>(
    _ type: T.Type,
    forKey key: String,
    default defaultValue: T
  ) -> T {
    guard
      let data = storage.data(forKey: key),
      let value = try? JSONDecoder().decode(type, from: data)
    else {
      return defaultValue
    }
    return value
  }
}
