//
//  KaelApp.swift
//  Kael
//
//  Created by yangyang on 2026/3/31.
//

import SwiftUI

@main
struct KaelApp: App {
    @StateObject private var kawuxhaFgfNaviManager = KawuxhaFgfNaviManager()
    
    @StateObject private var mxhwiUAhxgswChatViewModel: MxhwiUAhxgswChatViewModel = MxhwiUAhxgswChatViewModel()
    @StateObject private var pwixzLkciemUserViewModel: PwixzLkciemUserViewModel = PwixzLkciemUserViewModel()
    @StateObject private var rwyclaHurgrVideoViewModel: RwyclaHurgrVideoViewModel = RwyclaHurgrVideoViewModel()
    @StateObject private var hglijlkKuxaIAPManager: HglijlkKuxaIAPManager = HglijlkKuxaIAPManager()
    
    private var storage = KaelIwuzHacStorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                KawuxhaFgfRouter()
                TuxaliFvswlaHUDView()
                if kawuxhaFgfNaviManager.isShowBlock {
                    VytlwKJewReportBlock(vytilwKejaIsShow: $kawuxhaFgfNaviManager.isShowBlock)
                        .transition(.opacity)
                }
                if kawuxhaFgfNaviManager.isShowGuestLogin {
                    KaelGuestLoginDialog(
                        onLogin: {
                            kawuxhaFgfNaviManager.confirmGuestLogin()
                            pwixzLkciemUserViewModel.loadLoginPwixzLkciemUser()
                        },
                        onCancel: {
                            kawuxhaFgfNaviManager.closeGuestLogin()
                        }
                    )
                    .zIndex(10)
                }
            }.environmentObject(kawuxhaFgfNaviManager)
                .environmentObject(mxhwiUAhxgswChatViewModel)
                .environmentObject(pwixzLkciemUserViewModel)
                .environmentObject(rwyclaHurgrVideoViewModel)
                .environmentObject(hglijlkKuxaIAPManager)
                .onAppear{
                    storage.initializeAllDefaults()
                    hglijlkKuxaIAPManager.mznsALiwFetchProducts()
                    pwixzLkciemUserViewModel.loadLoginPwixzLkciemUser()
                }
        }
    }
}
