import SwiftUI

struct BNceyqciPostCArd: View {
    let bnceyaPostInfo: RwyclaHurgrVideo
    
    @EnvironmentObject var bNceywPostVM: RwyclaHurgrVideoViewModel
    @EnvironmentObject var bNwjwiqUserVM: PwixzLkciemUserViewModel
    @EnvironmentObject var NvwaBNqciNavi: KawuxhaFgfNaviManager
    
    var body: some View {
        ZStack{
            DxchaieJiglImage(bnceyaPostInfo.rwyclaHurgrPic[0], dxchaieJiglHeight: 246)
            VStack(alignment: .leading){
                if let oicmUserInfo = bNceywPostVM.getUserByCreatorId(creatorId: bnceyaPostInfo.rwyclaHurgrCreatorId) {
                    HStack{
                        DxchaieJiglImage(oicmUserInfo.pwixzLkciemAvatar, dxchaieJiglWidth: 42, dxchaieJiglHeight: 42, dxchaieJiglIsCircle: true, dxchaieJiglLineWidth: 1)
                        Spacer()
                        if oicmUserInfo.pwixzLkciemUserId != bnceyaPostInfo.rwyclaHurgrCreatorId {
                            Image("eoqca_more")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    NvwaBNqciNavi.showReportBlock(bnceyaPostInfo.rwyclaHurgrCreatorId)
                                }
                        }
                    }
                    
                }
                Spacer()
                HStack(){
                    Spacer()
                    HStack(spacing: 5){
                        if let bnmine = bNwjwiqUserVM.currentUser {
                            Image(bnmine.pwixzLkciemLikePosts.contains(bnceyaPostInfo.rwyclaHurgrWorkId) ? "likepic" : "dislikepic")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(bnceyaPostInfo.rwyclaHurgrLikeCount)")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(12))
                                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                        }
                        
                    }.padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                    HStack(spacing: 5){
                        Image("comment")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(bnceyaPostInfo.rwyclaHurgrCommentCount)")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(12))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                    }.padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                }
            }.padding(10)
            if bnceyaPostInfo.rwyclaHurgrType == 1 {
                Image("viealkjAlpalue")
                    .resizable()
                    .frame(width: 42, height: 42)
            }
            
        }.frame(height: 246)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                if bnceyaPostInfo.rwyclaHurgrType == 0 {
                    NvwaBNqciNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "picPostDetails/\(bnceyaPostInfo.rwyclaHurgrWorkId)"))
                } else {
                    NvwaBNqciNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "videoPostDetails/\(bnceyaPostInfo.rwyclaHurgrWorkId)"))
                }
                
            }
    }
}
