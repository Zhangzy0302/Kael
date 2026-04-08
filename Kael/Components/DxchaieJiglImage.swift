import SwiftUI

struct DxchaieJiglImage: View {

  let dxchaieJiglImageUrl: String
  let dxchaieJiglWidth: CGFloat?
  let dxchaieJiglHeight: CGFloat?
  let dxchaieJiglIsCircle: Bool
    let dxchaieJiglLineWidth: CGFloat
  let dxchaieJiglContentMode: ContentMode

  init(
    _ dxchaieJiglImageUrl: String,
    dxchaieJiglWidth: CGFloat? = nil,
    dxchaieJiglHeight: CGFloat? = nil,
    dxchaieJiglIsCircle: Bool = false,
    dxchaieJiglLineWidth: CGFloat = 0,
    dxchaieJiglContentMode: ContentMode = .fill
  ) {
    self.dxchaieJiglImageUrl = dxchaieJiglImageUrl
    self.dxchaieJiglWidth = dxchaieJiglWidth
    self.dxchaieJiglHeight = dxchaieJiglHeight
    self.dxchaieJiglIsCircle = dxchaieJiglIsCircle
    self.dxchaieJiglContentMode = dxchaieJiglContentMode
      self.dxchaieJiglLineWidth = dxchaieJiglLineWidth
  }
    
  var body: some View {
    let DxchaieJiglImage = buildImage()
      .frame(width: dxchaieJiglWidth, height: dxchaieJiglHeight)
      .clipped()

    if dxchaieJiglIsCircle {
        DxchaieJiglImage
        .clipShape(Circle())
        .overlay{
            Circle()
                .stroke(.white, lineWidth: dxchaieJiglLineWidth)
        }
    } else {
        DxchaieJiglImage
    }
  }
}

// MARK: - Build Image
extension DxchaieJiglImage {

  fileprivate func isLocalFilePath(_ path: String) -> Bool {
    path.hasPrefix("/")
  }

  fileprivate func isNetworkUrl(_ path: String) -> Bool {
    path.hasPrefix("http://") || path.hasPrefix("https://")
  }

  @ViewBuilder
  fileprivate func buildImage() -> some View {

    // 1️⃣ 空
    if dxchaieJiglImageUrl.isEmpty {
      placeholderView()
    }

    // 2️⃣ 网络图片
    else if isNetworkUrl(dxchaieJiglImageUrl),
            let url = URL(string: dxchaieJiglImageUrl) {

      AsyncImage(url: url) { phase in
        switch phase {
        case .empty:
          placeholderView()
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: dxchaieJiglContentMode)
        case .failure:
          placeholderView()
        @unknown default:
          placeholderView()
        }
          
          
      }

    }

    // 3️⃣ 本地文件
    else if isLocalFilePath(dxchaieJiglImageUrl),
            let uiImage = UIImage(contentsOfFile: dxchaieJiglImageUrl) {

      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: dxchaieJiglContentMode)

    }

    // 4️⃣ Asset
    else {

      Image(dxchaieJiglImageUrl)
        .resizable()
        .aspectRatio(contentMode: dxchaieJiglContentMode)

    }
  }

  fileprivate func placeholderView() -> some View {
    ZStack {
      Color(red: 23/255, green: 23/255, blue: 23/255)
      Image(systemName: "photo")
        .foregroundColor(.gray)
    }
  }
}
