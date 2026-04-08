import SwiftUI

struct EwioxaEula: View {
    @EnvironmentObject var ewialkxNavi: KawuxhaFgfNaviManager
    
    var body: some View {
        ZStack(alignment: .top){
            KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()
            VStack{
                HStack{
                    Image("back")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            ewialkxNavi.pop()
                        }
                    Spacer()
                }.padding(.horizontal, 20)
                    .padding(.vertical, 12)
                VStack(spacing: 0){
                    HStack{
                        Text("EULA")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(24, weight: .extraBold))
                            .foregroundStyle(.black)
                            .padding(.bottom, 16)
                        Spacer()
                    }
                    
                    Text("Welcome to Kael! To make a better place,the following content is not allowed in the app in particular.\n\n1. Any content about child harm,pornography related detrimental to children.\n2. Fake and harmful messages about recent or current events.\n3. Any violence,bullying content, publicly promotes pornography and other content.\n\nIf we find any content including and not limited to the above violations your content will be deleted and account will be banned.By clicking the above button,you agreeto the Terms of Use and Privacy Policy.")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                        .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                    Spacer()
                    HStack{
                        Text("Terms of Use")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            .underline()
                            .onTapGesture {
                                ewialkxNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "userAgreement"))
                            }
                        Spacer()
                        Text("Privacy Policy")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            .underline()
                            .onTapGesture {
                                ewialkxNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "privacyPolicy"))
                            }
                    }.padding(.horizontal, 9)
                        .padding(.bottom, 23)
                    HStack(spacing: 0){
                        Button(action: {
                            ewialkxNavi.pop()
                        }) {
                            Text("Cancel")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                                .foregroundStyle(.white)
                                .frame(width: 120, height: 40)
                                .background(RoundedRectangle(cornerRadius: 14).fill(.black))
                        }
                        Spacer()
                        Button(action: {
                            PyifkaLvtjhfState.pyifkaLvtjhfAgree = true
                            PyifkaLvtjhfState.pyifkaLvtjhfAgreeEULA = true
                            ewialkxNavi.pop()
                        }) {
                            Text("I agree")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                                .foregroundStyle(.white)
                                .frame(width: 120, height: 40)
                                .background(RoundedRectangle(cornerRadius: 14).fill(KaelGhueauTheme.KaelColor.kaelButtonYellow))
                        }
                    }.padding(.horizontal, 9)
                }.padding(.horizontal, 32)
                    .padding(.vertical, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(KaelGhueauTheme.KaelColor.kaelMainYellow)
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(KaelGhueauTheme.KaelColor.kealBgBlack, lineWidth: 8)
                            }
                    ).padding(.horizontal, 20)
                    .padding(.bottom, 44)
            }
        }.navigationBarHidden(true)
            .background(VhuaGehuSwipeBack())
    }
}

#Preview {
    EwioxaEula()
}
