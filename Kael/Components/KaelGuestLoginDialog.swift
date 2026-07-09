import SwiftUI

struct KaelGuestLoginDialog: View {
    let onLogin: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        onCancel()
                    }
                }
            
            ZStack(alignment: .bottom) {
                Image("reoiALxiwq_block_bg")
                    .resizable()
                    .frame(width: 260, height: 390)
                
                VStack(spacing: 0) {
                    Text("Please log in first\nto keep this feature\nworking properly for\nyour account.")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14, weight: .regular))
                        .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .frame(width: 178, height: 108)
                        .padding(.bottom, 30)
                    
                    Text("Log in")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(18, weight: .extraBold))
                        .foregroundStyle(.white)
                        .frame(width: 146, height: 53)
                        .background(
                            KaelGhueauTheme.KaelColor.kaelButtonYellow.cornerRadius(40)
                        )
                        .onTapGesture {
                            onLogin()
                        }
                    
                    Text("Cancel")
                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                        .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                        .frame(width: 146, height: 44)
                        .onTapGesture {
                            withAnimation {
                                onCancel()
                            }
                        }
                }
                .padding(.bottom, 20)
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    KaelGuestLoginDialog(onLogin: {}, onCancel: {})
}
