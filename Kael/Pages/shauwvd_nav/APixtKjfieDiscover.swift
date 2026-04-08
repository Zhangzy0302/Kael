import SwiftUI

struct APixtKjfieDiscover: View {
    @EnvironmentObject var awpixalNavi: KawuxhaFgfNaviManager
    @EnvironmentObject var apixKfiePostVM: RwyclaHurgrVideoViewModel
    @EnvironmentObject var apixtKifjUserVM: PwixzLkciemUserViewModel
    
    @State private var apixKjfieCurrentIndex: String = "ALL"
    
    var body: some View {
        ZStack(alignment: .top){
            GeometryReader{ geo in
                Image("cilakgr_bg_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    Text("Discover")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(30, weight: .extraBold))
                        .foregroundStyle(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                        .padding(.trailing, 6)
                    Image("cflkqlkdfire")
                        .resizable()
                        .frame(width: 41, height: 41)
                    Spacer()
                    Circle()
                        .fill(KaelGhueauTheme.KaelColor.kealBgBlack)
                        .frame(width: 42)
                        .overlay{
                            Image("fuwjAKjurq")
                                .resizable()
                                .frame(width: 26, height: 26)
                        }
                        .onTapGesture {
                            awpixalNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "publishVideoPost"))
                        }
                }.padding(.top, 7)
                
                HStack(spacing: 20){
                    ApixKaiwTag(apixkaText: $apixKjfieCurrentIndex, apicxaTagText: "ALL")
                    ApixKaiwTag(apixkaText: $apixKjfieCurrentIndex, apicxaTagText: "Follow")
                }.padding(.top, 44)
                
                if let apiwMyInfo = apixtKifjUserVM.currentUser {
                    let apixkKfielVideos = apixKfiePostVM.getAllNotBlockRwyclaHurgrWorksByType(type: 1)
                    let apiCKaiswFollowVideos = apixkKfielVideos.filter{
                        apiwMyInfo.pwixzLkciemFollowing.contains($0.rwyclaHurgrCreatorId)
                    }
                    TabView(selection: $apixKjfieCurrentIndex) {
                        Group{
                            if apixkKfielVideos.isEmpty {
                                VhuwaFgEmptyData(vhuwauGTopPadding: 100)
                            }else {
                                ScrollView{
                                    LazyVStack(spacing: 14){
                                        ForEach(apixkKfielVideos) { video in
                                            BNceyqciPostCArd(bnceyaPostInfo: video)
                                        }
                                    }.padding(.bottom, 120)
                                }
                            }
                            
                        }.tag("ALL")
                        Group{
                            if apiCKaiswFollowVideos.isEmpty {
                                VhuwaFgEmptyData(vhuwauGTopPadding: 100)
                            } else {
                                ScrollView {
                                    LazyVStack(spacing: 14) {
                                        ForEach(apiCKaiswFollowVideos) { video in
                                            BNceyqciPostCArd(bnceyaPostInfo: video)
                                        }
                                    }.padding(.bottom, 120)
                                }
                            }
                        }.tag("Follow")
                        
                        
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                        .background(Color.clear)
                        .padding(.top, 14)

                }
            }.padding(.horizontal, 20)
        }
    }
    
    struct ApixKaiwTag: View {
        @Binding var apixkaText: String
        let apicxaTagText: String
        var body: some View {
            Text(apicxaTagText)
                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: apixkaText == apicxaTagText ? .extraBold : .regular))
                .foregroundStyle(apixkaText == apicxaTagText ? KaelGhueauTheme.KaelColor.kealBgBlack : Color(red: 102/255, green: 102/255, blue: 102/255))
                .frame(width: 84, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(
                        apixkaText == apicxaTagText ? KaelGhueauTheme.KaelColor.kaelMainYellow : .white
                    )
                ).onTapGesture {
                    apixkaText = apicxaTagText
                }
        }
    }
}

#Preview {
    APixtKjfieDiscover()
}
