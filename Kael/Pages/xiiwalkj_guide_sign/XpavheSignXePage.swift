import SwiftUI

enum XpavheSignType {
    case xpavehSignIn
    case xoiapceSingUp
    case xaiwlkSawForgot
}

struct XpavheSignXePage: View {
    let xpveheguideType: XpavheSignType
    @EnvironmentObject var xpawiSignnavi: KawuxhaFgfNaviManager
    @EnvironmentObject var xpavhUserVM: PwixzLkciemUserViewModel
    
    @State private var xpavheEmail: String = ""
    @State private var xpavhePWd: String = ""
    @State private var xpavheRePwd: String = ""
    
    @FocusState private var xpawiIsFocus1: Bool
    @FocusState private var xpawiIsFocus2: Bool
    @FocusState private var xpawiIsFocus3: Bool
    
    @State private var xpawvheCurrentStatus: XpavheSignType = .xpavehSignIn
    
    var body: some View {
        ZStack(alignment: .top){
            KaelGhueauTheme.KaelColor.kaelMainBg.ignoresSafeArea()
            VStack{
                HStack{
                    Image("back")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            xpawiSignnavi.pop()
                        }
                    Spacer()
                }.padding(.horizontal, 20)
                    .padding(.vertical, 12)
                Text(xpawvheCurrentStatus == .xpavehSignIn ? "Sign in" : xpawvheCurrentStatus == .xoiapceSingUp ? "Sign up" : "Forget  password")
                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(36, weight: .extraBold))
                    .padding(.bottom, 56)
                
                VStack(spacing: 0){
                    VStack(alignment: .leading){
                        Text("Email")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                        XpaveiaAucuInputBox(xpwvaText: $xpavheEmail, vawiaIsFocus: $xpawiIsFocus1)
                    }.padding(.bottom, 36)
                    VStack(alignment: .leading, spacing: 15){
                        Text("Password")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                        XpaveiaAucuInputBox(xpwvaText: $xpavhePWd, vawiaIsFocus: $xpawiIsFocus2)
                        if xpawvheCurrentStatus != .xpavehSignIn {
                            XpaveiaAucuInputBox(xpwvaText: $xpavheRePwd, vawiaIsFocus: $xpawiIsFocus3)
                        }
                        if xpawvheCurrentStatus == .xpavehSignIn {
                            HStack{
                                Spacer()
                                Text("Forgot ？")
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                                    .onTapGesture {
                                        withAnimation{
                                            xpawvheCurrentStatus = .xaiwlkSawForgot
                                        }
                                        
                                    }
                            }.padding(.top, 3)
                        }
                        
                    }
                    Button(action: {
                        xpawiIsFocus1 = false
                        xpawiIsFocus2 = false
                        xpawiIsFocus3 = false
                        if xpavheEmail.isEmpty {
                            TuxaliFvswlaHUD.toast(.normal("Email is required"))
                            return
                        }
                        if xpavhePWd.isEmpty {
                            TuxaliFvswlaHUD.toast(.normal("Password is required"))
                            return
                        }
                        if ((xpawvheCurrentStatus == .xpavehSignIn) ? false : xpavheRePwd.isEmpty) {
                            TuxaliFvswlaHUD.toast(.normal("Repassword is required"))
                            return
                        }
                        switch xpawvheCurrentStatus {
                        case .xpavehSignIn:
                            let xpawiakxUser = xpavhUserVM.loginByEmailAndPasswordPwixzLkciem(email: xpavheEmail, password: xpavhePWd)
                            if xpawiakxUser == nil {
                                TuxaliFvswlaHUD.toast(.error("Invalid email or password"))
                                return
                            }else {
                                Task{
                                    TuxaliFvswlaHUD.showLoading(showBackground: true)
                                    await delay(0.8)
                                    TuxaliFvswlaHUD.hideLoading()
                                    xpawiSignnavi.popToRoot()
                                }
                                
                            }
                        case .xoiapceSingUp:
                            if xpavhePWd != xpavheRePwd {
                                TuxaliFvswlaHUD.toast(.error("Passwords do not match"))
                                return
                            }
                            let xpaxiIWjnbuNEwUserInfo = xpavhUserVM.registerPwixzLkciem(email: xpavheEmail, password: xpavhePWd)
                            if xpaxiIWjnbuNEwUserInfo == nil {
                                TuxaliFvswlaHUD.toast(.error("This email is already registered"))
                                return
                            }else {
                                Task{
                                    TuxaliFvswlaHUD.showLoading(showBackground: true)
                                    await delay(0.8)
                                    TuxaliFvswlaHUD.hideLoading()
                                    xpawiSignnavi.popToRoot()
                                }
                            }
                        case .xaiwlkSawForgot:
                            return
                        }
                    }) {
                        Text(xpawvheCurrentStatus == .xpavehSignIn ? "Sign in" : xpawvheCurrentStatus == .xoiapceSingUp ? "Sign up" : "Save")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(24, weight: .extraBold))
                            .foregroundStyle(.white)
                            .frame(width: 246, height: 58)
                            .background(RoundedRectangle(cornerRadius: 30).fill(KaelGhueauTheme.KaelColor.kaelButtonYellow))
                    }.padding(.top, 90)
                        .padding(.bottom, 40)
                }.padding(.horizontal,20)
            }
        }.onTapGesture {
            xpawiIsFocus1 = false
            xpawiIsFocus2 = false
            xpawiIsFocus3 = false
        }.onAppear{
            xpawvheCurrentStatus = xpveheguideType
        }.navigationBarHidden(true)
            .background(VhuaGehuSwipeBack())
    }
    
    struct XpaveiaAucuInputBox: View {
        @Binding var xpwvaText: String
        @FocusState.Binding var vawiaIsFocus: Bool
        var body: some View {
            TextField("", text: $xpwvaText,
                      prompt: Text("Enter email address")
                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                    .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                )
                .focused($vawiaIsFocus)
                .tint(.black)
                .textInputAutocapitalization(.never)
                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .regular))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .frame(height: 62)
                .background(RoundedRectangle(cornerRadius: 20).fill(.black.opacity(0.1)))
                .onTapGesture {
                    vawiaIsFocus = true
                }
        }
    }
}

