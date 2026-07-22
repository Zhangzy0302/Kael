import SwiftUI
import UIKit

struct AmberCircuitLocationPermissionDialog: View {
    let amberCircuitOpenSettingsAction: () -> Void
    let amberCircuitCancelAction: () -> Void

    init(
        amberCircuitOpenSettingsAction: @escaping () -> Void = AmberCircuitLocationPermissionDialog.amberCircuitOpenAppSettings,
        amberCircuitCancelAction: @escaping () -> Void
    ) {
        self.amberCircuitOpenSettingsAction = amberCircuitOpenSettingsAction
        self.amberCircuitCancelAction = amberCircuitCancelAction
    }

    var body: some View {
        GeometryReader { amberCircuitProxy in
            ZStack {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture(perform: amberCircuitCancelAction)

                ZStack(alignment: .bottom) {
                    Image("reoiALxiwq_block_bg")
                        .resizable()
                        .frame(width: 260, height: 390)

                    VStack(spacing: 0) {
                        amberCircuitLocationBadge
                            .padding(.bottom, 18)

                        Text("Location Permission")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(18, weight: .extraBold))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 14)

                        Text("Allow location access to personalize services for your area. Your location is used only to make your experience more relevant.")
                            .font(KaelGhueauTheme.KaelFont.jetBrainsMono(12, weight: .regular))
                            .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                            .lineSpacing(3)
                            .multilineTextAlignment(.center)
                            .frame(width: 196)
                            .padding(.bottom, 24)

                        Button(action: amberCircuitOpenSettingsAction) {
                            Text("Settings")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(17, weight: .extraBold))
                                .foregroundStyle(.white)
                                .frame(width: 146, height: 53)
                                .background(KaelGhueauTheme.KaelColor.kaelButtonYellow)
                                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 16)

                        Button(action: amberCircuitCancelAction) {
                            Text("Cancel")
                                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16, weight: .extraBold))
                                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
                                .frame(width: 146, height: 44)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 25)
                }
                .transition(
                    .scale(scale: 0.96)
                        .combined(with: .opacity)
                )
            }
            .frame(width: amberCircuitProxy.size.width, height: amberCircuitProxy.size.height)
        }
        .transition(.opacity)
    }

    private var amberCircuitLocationBadge: some View {
        ZStack {
            Circle()
                .fill(KaelGhueauTheme.KaelColor.kaelMainYellow)
                .overlay {
                    Circle()
                        .stroke(KaelGhueauTheme.KaelColor.kealBgBlack, lineWidth: 2)
                }
                .frame(width: 58, height: 58)

            Image(systemName: "location.fill")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(KaelGhueauTheme.KaelColor.kealBgBlack)
        }
    }

    nonisolated private static func amberCircuitOpenAppSettings() {
        guard let amberCircuitSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        Task { @MainActor in
            guard UIApplication.shared.canOpenURL(amberCircuitSettingsURL) else {
                return
            }

            await UIApplication.shared.open(amberCircuitSettingsURL)
        }
    }
}

#Preview {
    AmberCircuitLocationPermissionDialog(
        amberCircuitCancelAction: {}
    )
}
