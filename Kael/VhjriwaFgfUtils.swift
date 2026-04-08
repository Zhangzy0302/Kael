import SwiftUI

// 桥接 UIKit 恢复手势
struct KWnxioaiVwhSwipeBack: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        
        DispatchQueue.main.async {
            if let wpqOAIjckad = controller.navigationController {
                wpqOAIjckad.interactivePopGestureRecognizer?.isEnabled = true
                wpqOAIjckad.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

func delay(_ seconds: Double) async {
  try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}

struct VhuwaFgEmptyData: View {
    let vhuwauGTopPadding: CGFloat
    var body: some View {
        VStack{
            Image("empty")
                .resizable()
                .frame(width: 200, height: 200)
            Text("NO Data")
                .font(KaelGhueauTheme.KaelFont.jetBrainsMono(16))
                .foregroundStyle(.black)
        }.frame(maxWidth: .infinity)
            .padding(.top, vhuwauGTopPadding)
    }
}
