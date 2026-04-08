import SwiftUI

struct VytlwKJewReportBlock: View {
    @Binding var vytilwKejaIsShow: Bool
    
    @EnvironmentObject var vytlwKjewNavi: KawuxhaFgfNaviManager
    @EnvironmentObject var vytilwiJjUserVM: PwixzLkciemUserViewModel
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.6).ignoresSafeArea()
                .onTapGesture {
                    withAnimation{
                        vytilwKejaIsShow = false
                    }
                }
            ZStack(alignment: .bottom){
                Image("reoiALxiwq_block_bg")
                    .resizable()
                    .frame(width: 244, height: 331)
                VStack(spacing: 0){
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(KaelGhueauTheme.KaelColor.kealBgBlack, lineWidth: 1)
                            .frame(width: 148, height: 46)
                        Text("Report")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                    }.padding(.bottom, 16)
                        .onTapGesture {
                            vytilwKejaIsShow = false
                            vytlwKjewNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "report"))
                        }
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(KaelGhueauTheme.KaelColor.kealBgBlack, lineWidth: 1)
                            .frame(width: 148, height: 46)
                        Text("Shield")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                    }.onTapGesture {
                        vytilwiJjUserVM.toggleUserIsBlocked(blockUserId: vytlwKjewNavi.blockUserID!)
                        vytilwKejaIsShow = false
                        
                        TuxaliFvswlaHUD.toast(.success("Blocked successfully"))
                    }
                    Text("Cancel")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(20, weight: .extraBold))
                        .foregroundStyle(.white)
                        .frame(width: 146, height: 53)
                        .background(
                            KaelGhueauTheme.KaelColor.kaelButtonYellow.cornerRadius(40)
                        ).onTapGesture {
                            withAnimation{
                                vytilwKejaIsShow = false
                            }
                        }.padding(.top, 30)
                }.padding(.bottom, 33)
            }
        }
        
    }
}
