import SwiftUI

struct OicmOifawgMine: View {
    @EnvironmentObject var oicmOifawgUserVM: PwixzLkciemUserViewModel
    @EnvironmentObject var oicnmaNavi: KawuxhaFgfNaviManager
    @EnvironmentObject var oicmOifawPosts: RwyclaHurgrVideoViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0){
                    if let oicmOifaagMyInfo = oicmOifawgUserVM.currentUser {
                        VStack(spacing: 0){
                            ZStack(alignment: .top){
                                Image("cieoiAOeTop")
                                    .resizable()
                                    .frame(width: 134, height: 67)
                                DxchaieJiglImage(oicmOifaagMyInfo.pwixzLkciemAvatar, dxchaieJiglWidth: 106, dxchaieJiglHeight: 106, dxchaieJiglIsCircle: true)
                                    .padding(.top, 16)
                            }.padding(.bottom, 10)
                                .padding(.top, 58)
                            
                            Text(oicmOifaagMyInfo.pwixzLkciemUserName)
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            HStack{
                                Button(action: {}) {
                                    VStack(spacing: 6){
                                        let ociaMyPosts = oicmOifawPosts.getMyRwyclaHurgrWorks()
                                        Text("\(ociaMyPosts.count)")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                        Text("Works")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                    }
                                }.frame(maxWidth: .infinity)
                                Button(action: {
                                    oicnmaNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "fan"))
                                }) {
                                    VStack(spacing: 6){
                                        Text("\(oicmOifaagMyInfo.pwixzLkciemFans.count)")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                        Text("Fans")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                    }
                                }.frame(maxWidth: .infinity)
                                Button(action: {
                                    oicnmaNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "follow"))
                                }) {
                                    VStack(spacing: 6){
                                        Text("\(oicmOifaagMyInfo.pwixzLkciemFollowing.count)")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                        Text("Follow")
                                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                    }
                                }.frame(maxWidth: .infinity)
                            }.padding(.top, 16)
                                .padding(.bottom, 20)
                                .padding(.horizontal, 20 )
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 13){
                        Text("Works")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(18, weight: .extraBold))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 30).fill(KaelGhueauTheme.KaelColor.kaelMainYellow))
                        LazyVStack(spacing: 14){
                            let oicmOifagMyWorks = oicmOifawPosts.getMyRwyclaHurgrWorks()
                            Group {
                                if oicmOifagMyWorks.isEmpty {
                                    VhuwaFgEmptyData(vhuwauGTopPadding: 40)
                                }else {
                                    ForEach(oicmOifagMyWorks) { ocimaWork in
                                        BNceyqciPostCArd(bnceyaPostInfo: ocimaWork)
                                    }
                                }
                            }
                            
                        }
                    }.padding(.horizontal, 20)
                    
                }.padding(.bottom, 120)
            }
            
            HStack(spacing: 0){
                
                Spacer()
                Image("cjhalLAw_setting")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        oicnmaNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "setting"))
                    }
            }.padding(.vertical, 10)
                .padding(.horizontal, 20)
        }
    }
}
