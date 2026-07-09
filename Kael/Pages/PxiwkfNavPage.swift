import SwiftUI

struct PxiwkfNavPage: View {
    @State private var pxiaWkaCurrentIndex: Int = 0
    
    @EnvironmentObject var pxiwkfaNavi: KawuxhaFgfNaviManager
    @EnvironmentObject var pxiwfaUserVm: PwixzLkciemUserViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader { geo in
                HuclAxwapcHome().opacity(pxiaWkaCurrentIndex == 0 ? 1 : 0)
                APixtKjfieDiscover().opacity(pxiaWkaCurrentIndex == 1 ? 1 : 0)
                YeuacjTYevjChat().opacity(pxiaWkaCurrentIndex == 2 ? 1 : 0)
                OicmOifawgMine().opacity(pxiaWkaCurrentIndex == 3 ? 1 : 0)
            }
            
            ZStack(alignment: .top){
                Image("chwApiek_bottom_nav")
                    .resizable()
                    .frame(height: 114)
                    .frame(maxWidth: .infinity)
                HStack{
                    PiawixkNavIcon(pznwbksCurrentIndex: $pxiaWkaCurrentIndex, pznvkdNavIndex: 0)
                    PiawixkNavIcon(pznwbksCurrentIndex: $pxiaWkaCurrentIndex, pznvkdNavIndex: 1)
                    Spacer()
                    PiawixkNavIcon(pznwbksCurrentIndex: $pxiaWkaCurrentIndex, pznvkdNavIndex: 2)
                    PiawixkNavIcon(pznwbksCurrentIndex: $pxiaWkaCurrentIndex, pznvkdNavIndex: 3)
                }.padding(.top, 46)
                Circle()
                    .fill(KaelGhueauTheme.KaelColor.kaelMainBg)
                    .frame(width: 42)
                    .overlay{
                        Image("fuwjAKjurq")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }.onTapGesture {
                        pxiwkfaNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "publishPicPost"))
                    }.padding(.top, 7)
            }.frame(height: 114)
                
            
            
        }.ignoresSafeArea(edges: .bottom)
            .navigationBarHidden(true)
            .onAppear {
                KaelWebWarmPool.prepareOnce()
            }
            .onChange(of: pxiwkfaNavi.keaikxAlxiwPath) { route in
                pxiwfaUserVm.loadLoginPwixzLkciemUser()
            }
    }
    
    struct PiawixkNavIcon: View {
        @Binding var pznwbksCurrentIndex: Int
        let pznvkdNavIndex: Int
        let pwiahgtSeletedIcon: [String] = [
            "eoqca_nav_home",
            "eoqca_nav_discover",
            "eoqca_nav_msg",
            "eoqca_nav_user"
        ]
        var body: some View {
            Button(action: {
                pznwbksCurrentIndex = pznvkdNavIndex
            }) {
                Image( pwiahgtSeletedIcon[pznvkdNavIndex])
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(pznwbksCurrentIndex == pznvkdNavIndex ? 1 : 0.5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
                
        }
    }
}

#Preview {
    PxiwkfNavPage()
}
