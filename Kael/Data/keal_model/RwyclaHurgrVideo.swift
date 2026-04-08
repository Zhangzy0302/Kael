import SwiftUI
import Combine

struct RwyclaHurgrVideo: Codable, Identifiable, Equatable {

  let rwyclaHurgrWorkId: String
  var rwyclaHurgrCreatorId: String
    var rwyclaHurgrType: Int
  var rwyclaHurgrTextContent: String
    var rwyclaHurgrTitleType: Int
  var rwyclaHurgrVideoUrl: String
  var rwyclaHurgrPic: [String]
  var rwyclaHurgrLikeCount: Int
    var rwyclaHurgrCommentCount: Int

  var id: String { rwyclaHurgrWorkId }
    
    func toTargetPost() -> TargetPost {
            return TargetPost(
                dynamicId: rwyclaHurgrWorkId,
                userId: rwyclaHurgrCreatorId,
                dynamicType: rwyclaHurgrType,
                dynamicDesc: rwyclaHurgrTextContent,
                dynamicTitleType: rwyclaHurgrTitleType,
                dynamicPic: rwyclaHurgrPic,
                dynamicVideo: rwyclaHurgrVideoUrl,
                dynamicLikeCount: rwyclaHurgrLikeCount,
                dynamicCommentCount: rwyclaHurgrCommentCount
            )
        }
}

extension RwyclaHurgrVideo {

    init(json: [String: Any]) {

        self.rwyclaHurgrWorkId = "\(json["dynamicId"] ?? "")"
        self.rwyclaHurgrCreatorId = "\(json["userId"] ?? "")"
        self.rwyclaHurgrType = json["dynamicType"] as? Int ?? 0
        self.rwyclaHurgrTextContent = json["dynamicDesc"] as? String ?? ""
        self.rwyclaHurgrTitleType = json["dynamicTitleType"] as? Int ?? 0
        self.rwyclaHurgrVideoUrl = json["dynamicVideo"] as? String ?? ""
        self.rwyclaHurgrLikeCount = json["dynamicLikeCount"] as? Int ?? 0
        self.rwyclaHurgrCommentCount = json["dynamicCommentCount"] as? Int ?? 0

        // 👇 图片数组（兼容 __NSArrayM）
        self.rwyclaHurgrPic = (json["dynamicPic"] as? [Any])?.map { "\($0)" } ?? []
    }
    
    static func fromJsonArray(_ array: [[String: Any]]) -> [RwyclaHurgrVideo] {
            return array.map { RwyclaHurgrVideo(json: $0) }
        }
}

struct TargetPost: Codable {
    let dynamicId: String
    let userId: String
    let dynamicType: Int
    let dynamicDesc: String
    let dynamicTitleType: Int
    let dynamicPic: [String]
    let dynamicVideo: String
    let dynamicLikeCount: Int
    let dynamicCommentCount: Int
}

@MainActor
final class RwyclaHurgrVideoViewModel: ObservableObject {

  @Published var allWorks: [RwyclaHurgrVideo] = []
  @Published var allNotBlockWorks: [RwyclaHurgrVideo] = []
//  @Published var userWorks: [RwyclaHurgrVideo] = []
  @Published var myFollowingUserWorks: [RwyclaHurgrVideo] = []
  @Published var workDetail: RwyclaHurgrVideo?

  private let storage = KaelIwuzHacStorageManager.shared

  func getAllRwyclaHurgrWorks() {
    allWorks = storage.getWorks()
  }

  func getAllNotBlockRwyclaHurgrWorks() {
    let allWorks: [RwyclaHurgrVideo] = storage.getWorks()
    if let cnaiwjdMyInfo = storage.getUserById(userId: storage.getCurrentUserId()) {
      allNotBlockWorks = allWorks.filter {
        !cnaiwjdMyInfo.pwixzLkciemBlacklist.contains($0.rwyclaHurgrCreatorId)
      }
    }

  }
    
    // get by type
    func getAllNotBlockRwyclaHurgrWorksByType(type: Int) -> [RwyclaHurgrVideo] {
      let allWorks: [RwyclaHurgrVideo] = storage.getWorks()
      if let cnaiwjdMyInfo = storage.getUserById(userId: storage.getCurrentUserId()) {
        return allWorks.filter {
          !cnaiwjdMyInfo.pwixzLkciemBlacklist.contains($0.rwyclaHurgrCreatorId)
            && $0.rwyclaHurgrType == type
        }
      }else {
          return []
      }

    }
    
    // get my works
    func getMyRwyclaHurgrWorks() -> [RwyclaHurgrVideo] {
      let allWorks: [RwyclaHurgrVideo] = storage.getWorks()
        return allWorks.filter {
            $0.rwyclaHurgrCreatorId == storage.getCurrentUserId()
        }

    }


    func getRwyclaHurgrWorksByUserIdAndType(userId: String, type: Int) -> [RwyclaHurgrVideo] {
    let allPostWorks: [RwyclaHurgrVideo] = storage.getWorks()
    return allPostWorks.filter {
        $0.rwyclaHurgrCreatorId == userId && $0.rwyclaHurgrType == type
    }
  }

  func getMyFollowingRwyclaHurgrWorks() {
    let currentUserId = storage.getCurrentUserId()
    guard let currentUserInfo: PwixzLkciemUser = storage.getUserById(userId: currentUserId)
    else {
      return
    }
    let allPostWorks: [RwyclaHurgrVideo] = storage.getWorks()
    let myFollowingWorks: [RwyclaHurgrVideo] = allPostWorks.filter {
      currentUserInfo.pwixzLkciemFollowing.contains($0.rwyclaHurgrCreatorId)
        && !currentUserInfo.pwixzLkciemBlacklist.contains($0.rwyclaHurgrCreatorId)
    }
    myFollowingUserWorks = myFollowingWorks
  }

  func getRwyclaHurgrWorkDetailByWorkId(workId: String) {
    workDetail = storage.getWorkDetailById(workId: workId)
  }

  // 根据用户ID获取用户信息（封装存储层方法）
  func getUserByCreatorId(creatorId: String) -> PwixzLkciemUser? {
    return storage.getUserById(userId: creatorId)
  }

}
