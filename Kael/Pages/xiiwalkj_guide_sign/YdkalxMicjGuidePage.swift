import SwiftUI

struct YdkalxMicjGuidePage: View {
    @EnvironmentObject var ydkalMcijNavi: KawuxhaFgfNaviManager
    @EnvironmentObject var ydkalMicUserVM: PwixzLkciemUserViewModel
    
    @AppStorage("pyifkaLvtjhfAgree") var yedkalMicIsAgree: Bool = false
    
    var body: some View {
        ZStack{
            GeometryReader{geo in
                Image("eoqca_guide_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            
            LinearGradient(colors: [
                KaelGhueauTheme.KaelColor.kaelMainYellow,
                Color(red: 245/255, green: 205/255, blue: 98/255).opacity(0)
            ], startPoint: .bottom, endPoint: .top).ignoresSafeArea()
            VStack{
                HStack{
                    Image("kael_logo")
                        .resizable()
                        .frame(width: 79, height: 79)
                        .cornerRadius(20)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(KaelGhueauTheme.KaelColor.kaelButtonYellow, lineWidth: 3)
                        }
                    Spacer()
                    Text("EULA")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5.5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(KaelGhueauTheme.KaelColor.kealBgBlack))
                        .onTapGesture {
                            ydkalMcijNavi.push(.ewioxaEula)
                        }
                }.padding(.leading, 38)
                    .padding(.trailing, 20)
                    .padding(.top, 17)
                Spacer()
                VStack(spacing: 0){
                    Button(action: {
                        if !PyifkaLvtjhfState.pyifkaLvtjhfAgreeEULA {
                            ydkalMcijNavi.push(.ewioxaEula)
                        } else if !PyifkaLvtjhfState.pyifkaLvtjhfAgree{
                            TuxaliFvswlaHUD.toast(.error("Please agree to the Terms and Privacy Policy."))
                        } else {
                            ydkalMcijNavi.push(.xpavheSignXePage(xpveheguideType: .xpavehSignIn))
                        }
                    }) {
                        Text("Login by email")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                            .foregroundStyle(.white)
                            .frame(width: 229, height: 62)
                            .background(RoundedRectangle(cornerRadius: 20).fill(KaelGhueauTheme.KaelColor.kaelButtonYellow))
                    }.padding(.bottom, 20)
                    Button(action: {
                        if !PyifkaLvtjhfState.pyifkaLvtjhfAgreeEULA {
                            ydkalMcijNavi.push(.ewioxaEula)
                        } else if !PyifkaLvtjhfState.pyifkaLvtjhfAgree{
                            TuxaliFvswlaHUD.toast(.error("Please agree to the Terms and Privacy Policy."))
                        } else {
                            Task{
                                TuxaliFvswlaHUD.showLoading(showBackground: true)
                                await delay(0.4)
                                TuxaliFvswlaHUD.hideLoading()
                                ydkalMicUserVM.visitorLoginPwixzLkciem()
                                ydkalMcijNavi.popToRoot()
                            }
                            
                        }
                    }) {
                        Text("I'm new")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                            .foregroundStyle(.white)
                            .frame(width: 229, height: 62)
                            .background(RoundedRectangle(cornerRadius: 20).fill(KaelGhueauTheme.KaelColor.kealBgBlack))
                    }.padding(.bottom, 22)
                    VStack(alignment: .leading){
                        Text("Don't have an account?")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                            .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                        Text("Sign up")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                            .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                            .kaelTextUnderline(Color(red: 51/255, green: 51/255, blue: 51/255))
                            .onTapGesture {
                                if !PyifkaLvtjhfState.pyifkaLvtjhfAgreeEULA {
                                    ydkalMcijNavi.push(.ewioxaEula)
                                } else if !PyifkaLvtjhfState.pyifkaLvtjhfAgree{
                                    TuxaliFvswlaHUD.toast(.error("Please agree to the Terms and Privacy Policy."))
                                } else {
                                    ydkalMcijNavi.push(.xpavheSignXePage(xpveheguideType: .xoiapceSingUp))
                                }
                            }
                    }.padding(.bottom, 40)
                    HStack(alignment: .top, spacing: 10){
                        Button(action: {
                            yedkalMicIsAgree = !yedkalMicIsAgree
                        }) {
                            Circle()
                                .stroke(.white, lineWidth: 1)
                                .frame(width: 19)
                                .background(
                                    Group {
                                        if yedkalMicIsAgree {
                                            ZStack{
                                                Circle()
                                                    .fill(.black)
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                    
                                    
                                )
                        }
                        VStack(alignment: .leading, spacing: 0){
                            HStack(spacing: 0){
                                Text("Agree with ")
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                    .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                                Text("User Agreement")
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                    .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                                    .kaelTextUnderline(Color(red: 51/255, green: 51/255, blue: 51/255))
                                    .onTapGesture {
                                        ydkalMcijNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "userAgreement"))
                                    }
                                Text(" and")
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                    .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                            }
                            
                            Text("Privacy Policy")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                                .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                                .kaelTextUnderline(Color(red: 51/255, green: 51/255, blue: 51/255))
                                .onTapGesture {
                                    ydkalMcijNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "privacyPolicy"))
                                }
                        }
                    }.padding(.bottom, 26)
                }
            }
            
        }
    }
}
