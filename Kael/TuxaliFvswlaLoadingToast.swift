import SwiftUI
import Combine

enum TuxaliFvswlaHUDAction {
    case normal(String)
    case success(String)
    case error(String)
}

enum TuxaliFvswlaHUD {

    static func toast(_ action: TuxaliFvswlaHUDAction) {
        executeOnMain {
            switch action {
            case .normal(let text):
                TuxaliFvswlaLoadingToast.shared.showToast(text)

            case .success(let text):
                TuxaliFvswlaLoadingToast.shared.showToast(text, type: .success)

            case .error(let text):
                TuxaliFvswlaLoadingToast.shared.showToast(text, type: .error)
            }
        }
      }

    static func showLoading(showBackground: Bool = false) {
            executeOnMain {
                TuxaliFvswlaLoadingToast.shared.showLoading(showBackground: showBackground)
            }
        }

        static func hideLoading() {
            executeOnMain {
                TuxaliFvswlaLoadingToast.shared.hideLoading()
            }
        }

        private static func executeOnMain(
            _ action: @escaping @MainActor () -> Void
        ) {
            Task { @MainActor in
                action()
            }
        }
}

@MainActor
final class TuxaliFvswlaLoadingToast: ObservableObject {

    static let shared = TuxaliFvswlaLoadingToast()

    @Published var toast: TuxaliFvswlaToast?
    @Published var tuxaliFvswlasLoading: Bool = false
    @Published var showBackground: Bool = false // ✅ 是否显示黑色半透明背景

    private init() {}

    func showToast(
        _ text: String,
        type: TuxaliFvswlaToastType = .normal,
        duration: TimeInterval = 1.8
    ) {
        toast = TuxaliFvswlaToast(text: text, type: type)

        Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            self.toast = nil
        }
    }

    /// 显示 loading，可选择是否显示遮罩
    func showLoading(showBackground: Bool = false) {
        self.showBackground = showBackground
        tuxaliFvswlasLoading = true
    }

    func hideLoading() {
        tuxaliFvswlasLoading = false
        showBackground = false
    }
}


struct TuxaliFvswlaHUDView: View {

  @ObservedObject private var qwjAKjxlLkjqos = TuxaliFvswlaLoadingToast.shared

  var body: some View {
    ZStack {
    // 🚫 Loading 时的点击拦截层
          if qwjAKjxlLkjqos.tuxaliFvswlasLoading {
              if qwjAKjxlLkjqos.showBackground {
                  Color.black
                      .opacity(0.4) // 默认半透明，可调
                      .ignoresSafeArea()
              }else {
                  Color.black
                    .opacity(0.001) // 必须 > 0，否则不拦截事件
                    .ignoresSafeArea()
              }
            
          }
      // Loading
      if qwjAKjxlLkjqos.tuxaliFvswlasLoading {
        // 弹窗内容
        VStack(spacing: 22) {
          ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(1.4)
            .tint(.white)

          Text("Loading...")
            .foregroundColor(.white)
        }.frame(width: 130, height: 130)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(.black.opacity(0.8))
            .cornerRadius(20))
        .overlay{
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 1)
        }
//        .shadow(color: KaelGhueauTheme.KaelColor.kaelMainYellow, radius: 4, y: 2)
        .padding(.horizontal, 40)

      }

      // Toast
      if let toast = qwjAKjxlLkjqos.toast {
        VStack {
          Spacer()
            VStack(spacing: 16) {

            if let tuxaliFvswlacon = toast.type.tuxaliFvswlacon {
              Image(systemName: tuxaliFvswlacon)
                    .frame(width: 30)
                    .foregroundColor(toast.type.tuxaliFvswlaColor)
            }

            Text(toast.text)
                    .font(KaelGhueauTheme.KaelFont.jetBrainsMono(14))
              .foregroundColor(.white)
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 14)
          .background(.black.opacity(0.8))
          .cornerRadius(20)
          .overlay{
              RoundedRectangle(cornerRadius: 20)
                  .stroke(.white, lineWidth: 1)
          }
          .transition(.opacity.combined(with: .move(edge: .top)))

          Spacer()
        }
      }
    }
    .animation(.easeInOut, value: qwjAKjxlLkjqos.tuxaliFvswlasLoading)
  }
}

enum TuxaliFvswlaToastType {
  case normal
  case success
  case error

  var tuxaliFvswlaColor: Color {
    switch self {
    case .normal:
      return .white
    case .success:
      return .green
    case .error:
      return .red
    }
  }

  var tuxaliFvswlacon: String? {
    switch self {
    case .success:
      return "checkmark.circle.fill"
    case .error:
      return "xmark.octagon.fill"
    default:
      return nil
    }
  }
}

struct TuxaliFvswlaToast {
  let text: String
  let type: TuxaliFvswlaToastType
}
