import SwiftUI

struct YeuacjTYevjChat: View {
    @EnvironmentObject var yueuciajChatVM: MxhwiUAhxgswChatViewModel
    @EnvironmentObject var yucaTyeUserVM: PwixzLkciemUserViewModel
    @EnvironmentObject var yueacaNavi: KawuxhaFgfNaviManager
    
    var body: some View {
        ZStack(alignment: .top){
            GeometryReader{ geo in
                Image("cilakgr_bg_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0){
                    HStack(spacing: 0){
                        Text("Chat")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(30, weight: .extraBold))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                            .padding(.trailing, 6)
                        
                    }.padding(.top, 7)
                    ScrollView {
                        LazyVStack(spacing: 16){
                            let yuwajMyRooms = yueuciajChatVM.getMyMxhwiUAhxgswChatRoomsNotBlock()
                            if yuwajMyRooms.isEmpty {
                                VhuwaFgEmptyData(vhuwauGTopPadding: 100)
                            }else {
                                ForEach(yuwajMyRooms, id: \.mxhwiUAhxgswRoomId) { yueauca in
                                    YeualkwjRoomMesg(eualnwialvRoomInfo: yueauca)
                                    }
                            }
                            
                            
                        }.padding(.bottom, 120)
                    }.padding(.top, 62)
                }.padding(.horizontal, 20)
            }
            
                
        }
    }
    
    struct YeualkwjRoomMesg: View {
        let eualnwialvRoomInfo: MxhwiUAhxgswChatRoom
        @EnvironmentObject var yucaTyeUserVM: PwixzLkciemUserViewModel
        @EnvironmentObject var yueacaNavi: KawuxhaFgfNaviManager
        @EnvironmentObject var yueacChatVm: MxhwiUAhxgswChatViewModel
        
        var body: some View {
            HStack(spacing: 8){
                if let teuacTYejChatUserInfo = yueacChatVm.getMxhwiUAhxgswChatUserInfo(chatRoomId: eualnwialvRoomInfo.mxhwiUAhxgswRoomId) {
                    ZStack(alignment: .topTrailing){
                        Circle().fill(LinearGradient(colors: [
                            .white,
                            .white.opacity(0)
                        ], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 64)
                        .overlay{
                            DxchaieJiglImage(teuacTYejChatUserInfo.pwixzLkciemAvatar, dxchaieJiglWidth: 63, dxchaieJiglHeight: 63, dxchaieJiglIsCircle: true)
                        }
                        if (eualnwialvRoomInfo.mxhwiUAhxgswLastSendUser != yucaTyeUserVM.currentUserID && eualnwialvRoomInfo.mxhwiUAhxgswUnreadCount > 0) {
                            Circle()
                                .fill(.red)
                                .frame(width: 12)
                                .overlay{
                                    Text("\(eualnwialvRoomInfo.mxhwiUAhxgswUnreadCount)")
                                        .font(KaelGhueauTheme.KaelFont.jetBrainsMono(9, weight: .regular))
                                        .foregroundStyle(.white)
                                }.padding(.trailing, 6)
                                .padding(.top, 1)
                        }
                        
                    }
                    HStack{
                        VStack(alignment: .leading, spacing: 5){
                            HStack{
                                Text(teuacTYejChatUserInfo.pwixzLkciemUserName)
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                                    .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                Spacer()
                                Text("JUST")
                                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(10, weight: .regular))
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                            }
                           
                            Text(eualnwialvRoomInfo.mxhwiUAhxgswLastSendMsg)
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(12, weight: .regular))
                                .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255).opacity(0.8))
                        }
                        
                    }.padding(.trailing, 10)
                }
                
                
            }.padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 60)
                        .fill(
                            LinearGradient(colors: [
                                Color(red: 235/255, green: 234/255, blue: 48/255),
                                Color(red: 250/255, green: 250/255, blue: 213/255)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                ).shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                .onTapGesture {
                    yueacaNavi.push(.fhHhvckaeudeWeb(fhHguwvWebUrl: "chat/\(eualnwialvRoomInfo.mxhwiUAhxgswRoomId)"))
                }
        }
    }
}

#Preview {
    YeuacjTYevjChat()
}
