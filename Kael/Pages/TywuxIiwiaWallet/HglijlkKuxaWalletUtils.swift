
import StoreKit
import SwiftUI
import Combine

struct HglijlkKuxaProduct {
  let hglijlkKuxaKeyId: String
  let hglijlkKuxaGetDiamond: Int
  let hglijlkKuxaPrice: Double
}

let hghawiL2189jLkjProducts: [HglijlkKuxaProduct] = [
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "saaauiwzanugqkue", hglijlkKuxaGetDiamond: 400, hglijlkKuxaPrice: 0.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "cufqhwwtruywequl", hglijlkKuxaGetDiamond: 800, hglijlkKuxaPrice: 1.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "uysqkdztrnphvljc", hglijlkKuxaGetDiamond: 2190, hglijlkKuxaPrice: 3.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "qtrvjrldbpuobfhl", hglijlkKuxaGetDiamond: 2450, hglijlkKuxaPrice: 4.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "pczvlytnrqkwmbas", hglijlkKuxaGetDiamond: 3950, hglijlkKuxaPrice: 7.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "vwxfmzjjgzchmnfr", hglijlkKuxaGetDiamond: 5150, hglijlkKuxaPrice: 9.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "mxrjtlqfksahvzne", hglijlkKuxaGetDiamond: 7700, hglijlkKuxaPrice: 13.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "ipuxukzujkqtvbdi", hglijlkKuxaGetDiamond: 10800, hglijlkKuxaPrice: 19.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "zgymxegfnfowecuq", hglijlkKuxaGetDiamond: 29400, hglijlkKuxaPrice: 49.99),
  HglijlkKuxaProduct(
    hglijlkKuxaKeyId: "kcpisczvlozopdfa", hglijlkKuxaGetDiamond: 63700, hglijlkKuxaPrice: 99.99)
]

enum HglijlkKuxaPurchaseResult {
    case success(diamond: Int)
    case cancelled
    case pending
    case failed(message: String)
}

class HglijlkKuxaIAPManager: NSObject, ObservableObject {

    private struct PixelHarborPaymentContext {
        let pixelHarborProductID: String
        let pixelHarborOrderCode: String
        let pixelHarborCompletion: (HglijlkKuxaPurchaseResult) -> Void
    }

    @Published var qoryqNhqoifProducts: [SKProduct] = []

    private var request: SKProductsRequest?

    // 当前购买回调
    private var hlaiwbnLh38Zlkj: ((HglijlkKuxaPurchaseResult) -> Void)?
    private var pixelHarborPaymentContext: PixelHarborPaymentContext?
    private var pixelHarborFinishedTransactionIDs = Set<String>()

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    private var hguawLKjxiwRetryCount = 0
    private var hguawLKjxiwTotalRequestCount = 0
    private let hguawLKjxiwMaxTotalRequestCount = 10
    private var hguawLKjxiwMaxRetryCount = 10
    private var hguawLKjxiwIsRequesting = false

    // MARK: - 拉取商品
    func mznsALiwFetchProducts() {
        
        // ✅ 最大请求次数限制
        guard hguawLKjxiwTotalRequestCount < hguawLKjxiwMaxTotalRequestCount else {
            return
        }
        
        // 防止重复请求
        guard !hguawLKjxiwIsRequesting else { return }
        
        // 已有数据就不再请求
        guard qoryqNhqoifProducts.isEmpty else { return }
        
        hguawLKjxiwIsRequesting = true
        hguawLKjxiwTotalRequestCount += 1   // ✅ 每次请求都+1
        
        let ids = Set(hghawiL2189jLkjProducts.map { $0.hglijlkKuxaKeyId })
        
        request = SKProductsRequest(productIdentifiers: ids)
        request?.delegate = self
        request?.start()
    }

    // MARK: - 购买
    func xnswALjhwieRecharge(
        _ productKeyId: String,
        completion: @escaping (HglijlkKuxaPurchaseResult) -> Void
    ) {
        guard pixelHarborPaymentContext == nil, hlaiwbnLh38Zlkj == nil else {
            completion(.failed(message: "A purchase is already in progress"))
            return
        }

        guard SKPaymentQueue.canMakePayments() else {
            completion(.failed(message: "Payments not allowed"))
            return
        }

        guard let product = qoryqNhqoifProducts.first(where: { $0.productIdentifier == productKeyId }) else {
            completion(.failed(message: "Product not found"))
            return
        }

        TuxaliFvswlaHUD.showLoading(showBackground: true)

        // 保存回调
        hlaiwbnLh38Zlkj = completion
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func pixelHarborPrepareProducts() {
        mznsALiwFetchProducts()
    }

    func pixelHarborRecharge(
        productID: String,
        orderCode: String,
        completion: @escaping (HglijlkKuxaPurchaseResult) -> Void
    ) {
        guard hghawiL2189jLkjProducts.contains(where: { $0.hglijlkKuxaKeyId == productID }) else {
            completion(.failed(message: "Payment package unavailable"))
            return
        }

        guard pixelHarborPaymentContext == nil, hlaiwbnLh38Zlkj == nil else {
            completion(.failed(message: "A purchase is already in progress"))
            return
        }

        guard SKPaymentQueue.canMakePayments() else {
            completion(.failed(message: "Payments are unavailable"))
            return
        }

        guard let pixelHarborProduct = qoryqNhqoifProducts.first(where: { $0.productIdentifier == productID }) else {
            pixelHarborPrepareProducts()
            completion(.failed(message: "Products are loading"))
            return
        }

        pixelHarborPaymentContext = PixelHarborPaymentContext(
            pixelHarborProductID: productID,
            pixelHarborOrderCode: orderCode,
            pixelHarborCompletion: completion
        )
        TuxaliFvswlaHUD.showLoading(showBackground: true)
        SKPaymentQueue.default().add(SKPayment(product: pixelHarborProduct))
    }
}

extension HglijlkKuxaIAPManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        DispatchQueue.main.async {
            self.hguawLKjxiwIsRequesting = false
            self.hguawLKjxiwRetryCount = 0   // ✅ 成功后清零
            
            self.qoryqNhqoifProducts = response.products
            
            print("Loaded:", response.products.map { $0.productIdentifier })
            
            // ⚠️ 如果一个都没拿到，也可以认为失败
            if response.products.isEmpty {
                self.hguawLKjxiwRetryFetch()
            }
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        DispatchQueue.main.async {
            self.hguawLKjxiwIsRequesting = false
            
            print("Load failed:", error.localizedDescription)
            
            self.hguawLKjxiwRetryFetch()
        }
    }
    
    private func hguawLKjxiwRetryFetch() {
        
        hguawLKjxiwRetryCount += 1
        hguawLKjxiwTotalRequestCount += 1   // ✅ 只在失败时累计
        guard hguawLKjxiwRetryCount < hguawLKjxiwMaxRetryCount,
              hguawLKjxiwTotalRequestCount < hguawLKjxiwMaxTotalRequestCount else {
            return
        }
        
        let delay = pow(2.0, Double(hguawLKjxiwRetryCount))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.mznsALiwFetchProducts()
        }
    }
}

extension HglijlkKuxaIAPManager: SKPaymentTransactionObserver {
    private func pixelHarborPaymentContext(for productID: String) -> PixelHarborPaymentContext? {
        guard let pixelHarborPaymentContext,
              pixelHarborPaymentContext.pixelHarborProductID == productID else {
            return nil
        }

        return pixelHarborPaymentContext
    }

    private func pixelHarborReceiptDataString() -> String {
        guard let pixelHarborReceiptURL = Bundle.main.appStoreReceiptURL,
              let pixelHarborReceiptData = try? Data(contentsOf: pixelHarborReceiptURL) else {
            return ""
        }

        return pixelHarborReceiptData.base64EncodedString()
    }

    private func pixelHarborFinishPurchase(
        _ pixelHarborTransaction: SKPaymentTransaction,
        context pixelHarborContext: PixelHarborPaymentContext
    ) {
        let pixelHarborProductID = pixelHarborTransaction.payment.productIdentifier
        let pixelHarborTransactionID = pixelHarborTransaction.transactionIdentifier

        if let pixelHarborTransactionID {
            guard pixelHarborFinishedTransactionIDs.insert(pixelHarborTransactionID).inserted else {
                SKPaymentQueue.default().finishTransaction(pixelHarborTransaction)
                return
            }
        }

        let pixelHarborPurchaseID = pixelHarborTransactionID ?? ""
        let pixelHarborReceipt = pixelHarborReceiptDataString()

        Task { [weak self] in
            let pixelHarborVerified: Bool
            do {
                pixelHarborVerified = try await VelvetCometApiCall().velvetCometPayCall(
                    purchaseID: pixelHarborPurchaseID,
                    serverVerificationData: pixelHarborReceipt,
                    orderCode: pixelHarborContext.pixelHarborOrderCode
                )
            } catch {
                await MainActor.run {
                    self?.pixelHarborCompletePurchase(
                        transaction: pixelHarborTransaction,
                        productID: pixelHarborProductID,
                        result: .failed(message: error.localizedDescription)
                    )
                }
                return
            }

            await MainActor.run {
                guard let self else { return }

                if pixelHarborVerified,
                   let pixelHarborProduct = self.findWalletItem(productID: pixelHarborProductID) {
                    CopperLanternAdjustManager.copperLanternShared.copperLanternTrackPurchase(
                        dollar: pixelHarborProduct.hglijlkKuxaPrice
                    )
                    self.pixelHarborCompletePurchase(
                        transaction: pixelHarborTransaction,
                        productID: pixelHarborProductID,
                        result: .success(diamond: pixelHarborProduct.hglijlkKuxaGetDiamond)
                    )
                } else {
                    self.pixelHarborCompletePurchase(
                        transaction: pixelHarborTransaction,
                        productID: pixelHarborProductID,
                        result: .failed(message: "Purchase unverified")
                    )
                }
            }
        }
    }

    @MainActor
    private func pixelHarborCompletePurchase(
        transaction pixelHarborTransaction: SKPaymentTransaction,
        productID pixelHarborProductID: String,
        result pixelHarborResult: HglijlkKuxaPurchaseResult
    ) {
        SKPaymentQueue.default().finishTransaction(pixelHarborTransaction)
        TuxaliFvswlaHUD.hideLoading()

        guard let pixelHarborContext = pixelHarborPaymentContext(for: pixelHarborProductID) else {
            return
        }

        pixelHarborPaymentContext = nil
        pixelHarborContext.pixelHarborCompletion(pixelHarborResult)
    }

    @MainActor
    private func pixelHarborFailPurchase(
        _ pixelHarborTransaction: SKPaymentTransaction,
        result pixelHarborResult: HglijlkKuxaPurchaseResult
    ) {
        let pixelHarborProductID = pixelHarborTransaction.payment.productIdentifier
        guard pixelHarborPaymentContext(for: pixelHarborProductID) != nil else {
            return
        }

        pixelHarborCompletePurchase(
            transaction: pixelHarborTransaction,
            productID: pixelHarborProductID,
            result: pixelHarborResult
        )
    }

    private func findWalletItem(productID: String) -> HglijlkKuxaProduct? {
        hghawiL2189jLkjProducts.first { $0.hglijlkKuxaKeyId == productID }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions bnbcuWufaTransactions: [SKPaymentTransaction]) {
        
        for bnbcuWufaTransaction in bnbcuWufaTransactions {
            
            switch bnbcuWufaTransaction.transactionState {
                
            case .purchased:
                if let pixelHarborContext = pixelHarborPaymentContext(for: bnbcuWufaTransaction.payment.productIdentifier) {
                    pixelHarborFinishPurchase(bnbcuWufaTransaction, context: pixelHarborContext)
                    continue
                }

                SKPaymentQueue.default().finishTransaction(bnbcuWufaTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
                if let bnbcuWufaPro = hghawiL2189jLkjProducts.first(where: {
                    $0.hglijlkKuxaKeyId == bnbcuWufaTransaction.payment.productIdentifier
                }) {
                    hlaiwbnLh38Zlkj?(.success(diamond: bnbcuWufaPro.hglijlkKuxaGetDiamond))
                }
                hlaiwbnLh38Zlkj = nil
                
                
            case .failed:
                if pixelHarborPaymentContext(for: bnbcuWufaTransaction.payment.productIdentifier) != nil {
                    let pixelHarborResult: HglijlkKuxaPurchaseResult
                    if let pixelHarborError = bnbcuWufaTransaction.error as? SKError,
                       pixelHarborError.code == .paymentCancelled {
                        pixelHarborResult = .cancelled
                    } else {
                        pixelHarborResult = .failed(
                            message: bnbcuWufaTransaction.error?.localizedDescription ?? "Purchase failed"
                        )
                    }
                    DispatchQueue.main.async {
                        self.pixelHarborFailPurchase(bnbcuWufaTransaction, result: pixelHarborResult)
                    }
                    continue
                }

                SKPaymentQueue.default().finishTransaction(bnbcuWufaTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
                if let error = bnbcuWufaTransaction.error as? SKError {
                    if error.code == .paymentCancelled {
                        hlaiwbnLh38Zlkj?(.cancelled)
                    } else {
                        hlaiwbnLh38Zlkj?(.failed(message: error.localizedDescription))
                    }
                } else {
                    hlaiwbnLh38Zlkj?(.failed(message: bnbcuWufaTransaction.error?.localizedDescription ?? "Unknown error"))
                }
                hlaiwbnLh38Zlkj = nil
                
            case .restored:
                if pixelHarborPaymentContext(for: bnbcuWufaTransaction.payment.productIdentifier) != nil {
                    DispatchQueue.main.async {
                        self.pixelHarborFailPurchase(bnbcuWufaTransaction, result: .cancelled)
                    }
                    continue
                }

                SKPaymentQueue.default().finishTransaction(bnbcuWufaTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
            case .purchasing:
                break
                
            case .deferred:
                print("Purchase pending")
                if let pixelHarborContext = pixelHarborPaymentContext(for: bnbcuWufaTransaction.payment.productIdentifier) {
                    pixelHarborContext.pixelHarborCompletion(.pending)
                } else {
                    hlaiwbnLh38Zlkj?(.pending)
                }
            @unknown default:
                break
            }
        }
    }
}
