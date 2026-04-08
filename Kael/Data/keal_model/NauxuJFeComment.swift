import SwiftUI
import Combine

struct NauxuJFeComment: Codable, Equatable {

  let nauxuJFeCommentId: String
    let nauxuJFeCommentWorkId: String
    let nauxuJFeCommentUserId: String
    let nauxuJFeCommentText: String
    
    func toTargetComment() -> TargetComment {
            return TargetComment(
                commentId: nauxuJFeCommentId,
                dynamicId: nauxuJFeCommentWorkId,
                userId: nauxuJFeCommentUserId,
                content: nauxuJFeCommentText
            )
        }
}

extension NauxuJFeComment {

    init(json: [String: Any]) {

        self.nauxuJFeCommentId = "\(json["commentId"] ?? "")"
        self.nauxuJFeCommentWorkId = "\(json["dynamicId"] ?? "")"
        self.nauxuJFeCommentUserId = "\(json["userId"] ?? "")"
        self.nauxuJFeCommentText = json["content"] as? String ?? ""
    }
    
    static func fromJsonArray(_ array: [[String: Any]]) -> [NauxuJFeComment] {
        return array.map { NauxuJFeComment(json: $0) }
    }
}

struct TargetComment: Codable {
    let commentId: String
    let dynamicId: String
    let userId: String
    let content: String
}

