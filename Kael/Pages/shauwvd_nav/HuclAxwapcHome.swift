import SwiftUI

struct HuclAxwapcHome: View {
    @EnvironmentObject var huclAwpiPostVM: RwyclaHurgrVideoViewModel
    @EnvironmentObject var huclaAwNavi: KawuxhaFgfNaviManager
    
    var body: some View {
        ZStack(alignment: .top){
            GeometryReader{geo in
                Image("cilakgr_bg_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                Image("woijaXkjaiwa")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 358)
                    .padding(.top, 53)
            }
            VStack{
                HuclAxwapcTop()
                ScrollView{
                    VStack(alignment: .leading){
                        HStack{
                            Text("You might like")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                                .foregroundStyle(.white)
                            Spacer()
                        }.padding(.top, 16)
                            .padding(.bottom, 20)
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 40), GridItem(.flexible())
                        ], spacing: 14) {
                            let hclAxwapcAllPicposts = huclAwpiPostVM.getAllNotBlockRwyclaHurgrWorksByType(type: 0)
                            ForEach(hclAxwapcAllPicposts) { hcalkjPost in
                                cardView(huclAxwaPost: hcalkjPost)
                            }
                            
                        }
                        
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 120)
                        .background(
                            HStack(spacing: 0){
                                Rectangle()
                                    .fill(KaelGhueauTheme.KaelColor.kealBgBlack)
                                Rectangle().fill(KaelGhueauTheme.KaelColor.kaelMainBg)
                            }
                        ).padding(.top, 200)
                        .frame(minHeight: UIScreen.main.bounds.height)
                }
                
                
            }.ignoresSafeArea(edges: .bottom)
            
            
        }
    }
    
    private struct cardView: View {
        let huclAxwaPost: RwyclaHurgrVideo
        @EnvironmentObject var ahuxakjUserVM: PwixzLkciemUserViewModel
        @EnvironmentObject var huclaAwNavi: KawuxhaFgfNaviManager
        
        var swlktaoSot: KaelIwuzHacStorageManager = KaelIwuzHacStorageManager.shared
        
        func huclaifTheme(_ type: Int) -> String {
            if type == 0 {
                return "Hobbies"
            }else {
                return "Inspire"
            }
        }
        
        var body: some View {
            ZStack{
                DxchaieJiglImage(huclAxwaPost.rwyclaHurgrPic[0], dxchaieJiglHeight: 211)
                VStack(alignment: .leading) {
                    HStack {
                        if let hucawUSerInfo = ahuxakjUserVM.returnPwixzLkciemUserInfoById(userId: huclAxwaPost.rwyclaHurgrCreatorId) {
                            DxchaieJiglImage(hucawUSerInfo.pwixzLkciemAvatar, dxchaieJiglWidth: 30, dxchaieJiglHeight: 30, dxchaieJiglIsCircle: true, dxchaieJiglLineWidth: 1)
                        }
                        Spacer()
                        if (huclAxwaPost.rwyclaHurgrCreatorId != swlktaoSot.getCurrentUserId()){
                            Image("eoqca_more")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    huclaAwNavi.showReportBlock(huclAxwaPost.rwyclaHurgrCreatorId)
                                }
                        }
                        
                    }
                    
                    Spacer()
                    
                    Text("# \(huclaifTheme(huclAxwaPost.rwyclaHurgrTitleType))")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(10, weight: .regular))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 235/255, green: 234/255, blue: 48/255),
                                            Color(red: 253/255, green: 250/255, blue: 213/255)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                }
                .padding(10)
            }.frame(height: 211)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                huclaAwNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "picPostDetails/\(huclAxwaPost.rwyclaHurgrWorkId)"))
            }
        }
        
    }
    
    struct HuclAxwapcTop: View {
        @EnvironmentObject var huclaAwNavi: KawuxhaFgfNaviManager
        
        var body: some View {
            HStack(alignment: .top){
                Image("eoqca_sun_kael")
                    .resizable()
                    .frame(width: 111, height: 38)
                Spacer()
                VStack(alignment: .trailing){
                    Text("Hello, I'm Kael AI, \nyour personalized\n cycling companion.")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .medium))
                        .foregroundStyle(Color(red: 115/255, green: 86/255, blue: 0))
                        .transformEffect(.init(a: 1, b: 0, c: -tan(.pi/12), d: 1, tx: 0, ty: 0))
                        .multilineTextAlignment(.center)
                    HStack(spacing: 10){
                        Image("eoqca_diamond_1")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("-200")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                    }.padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.4))
                                .blur(radius: 4)
                        ).clipShape(RoundedRectangle(cornerRadius: 20))
//                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                        .onTapGesture {
                            huclaAwNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "aiDetails"))
                        }
                }.padding(.top, 10)
            }.padding(.horizontal, 20)
                .padding(.top, 5)
        }
    }
}
