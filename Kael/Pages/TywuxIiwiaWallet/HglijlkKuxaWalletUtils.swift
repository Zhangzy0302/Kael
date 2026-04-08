
import StoreKit
import SwiftUI
import Combine

struct HglijlkKuxaProduct {
  let wisxaHRjeUfrKeyId: String
  let wisxaHRjeUfrGetDiamond: Int
  let wisxaHRjeUfrPrice: Double
}

let eoquaAfporjxuwProducts: [HglijlkKuxaProduct] = [
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "lvbsvhxcgcrvesor", wisxaHRjeUfrGetDiamond: 400, wisxaHRjeUfrPrice: 0.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "dxismgcwewhrtezo", wisxaHRjeUfrGetDiamond: 800, wisxaHRjeUfrPrice: 1.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "khtxlcejaxmqcsra", wisxaHRjeUfrGetDiamond: 2190, wisxaHRjeUfrPrice: 3.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "yadwwvxspgxwlndb", wisxaHRjeUfrGetDiamond: 2450, wisxaHRjeUfrPrice: 4.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "qnrcuelbtiuflyky", wisxaHRjeUfrGetDiamond: 3950, wisxaHRjeUfrPrice: 7.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "ymohxnvpkqxutvab", wisxaHRjeUfrGetDiamond: 5150, wisxaHRjeUfrPrice: 9.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "lkrzqvmpjtnwbxfa", wisxaHRjeUfrGetDiamond: 6700, wisxaHRjeUfrPrice: 13.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "pkzeekokfzarcvis", wisxaHRjeUfrGetDiamond: 10800, wisxaHRjeUfrPrice: 19.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "vpfbfgxamdcvxkcf", wisxaHRjeUfrGetDiamond: 29400, wisxaHRjeUfrPrice: 49.99),
  HglijlkKuxaProduct(
    wisxaHRjeUfrKeyId: "cwmnxfbzrdehncqu", wisxaHRjeUfrGetDiamond: 63700, wisxaHRjeUfrPrice: 99.99)
]

enum HglijlkKuxaPurchaseResult {
    case success(diamond: Int)
    case cancelled
    case pending
    case failed(message: String)
}

class HglijlkKuxaIAPManager: NSObject, ObservableObject {

    @Published var peiALwlxuAwiProducts: [SKProduct] = []

    private var request: SKProductsRequest?
    
    // 当前购买回调
        private var ieudLKjalComple: ((HglijlkKuxaPurchaseResult) -> Void)?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    private var bnxnuaAKjxuqRetryCount = 0
    private var bnxnuaAKjxuqTotalRequestCount = 0
    private let bnxnuaAKjxuqMaxTotalRequestCount = 10
    private var bnxnuaAKjxuqMaxRetryCount = 10
    private var bnxnuaAKjxuqIsRequesting = false

    // MARK: - 拉取商品
    func mznsALiwFetchProducts() {
        
        // ✅ 最大请求次数限制
        guard bnxnuaAKjxuqTotalRequestCount < bnxnuaAKjxuqMaxTotalRequestCount else {
            return
        }
        
        // 防止重复请求
        guard !bnxnuaAKjxuqIsRequesting else { return }
        
        // 已有数据就不再请求
        guard peiALwlxuAwiProducts.isEmpty else { return }
        
        bnxnuaAKjxuqIsRequesting = true
        bnxnuaAKjxuqTotalRequestCount += 1   // ✅ 每次请求都+1
        
        let ids = Set(eoquaAfporjxuwProducts.map { $0.wisxaHRjeUfrKeyId })
        
        request = SKProductsRequest(productIdentifiers: ids)
        request?.delegate = self
        request?.start()
    }

    // MARK: - 购买
    func xnswALjhwieRecharge(
        _ productKeyId: String,
            completion: @escaping (HglijlkKuxaPurchaseResult) -> Void
        ) {
            guard SKPaymentQueue.canMakePayments() else {
                completion(.failed(message: "Payments not allowed"))
                return
            }
            
            guard let product = peiALwlxuAwiProducts.first(where: { $0.productIdentifier == productKeyId }) else {
                completion(.failed(message: "Product not found"))
                return
            }
            
            TuxaliFvswlaHUD.showLoading(showBackground: true)
            
            // 保存回调
            self.ieudLKjalComple = completion
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
}

extension HglijlkKuxaIAPManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        DispatchQueue.main.async {
            self.bnxnuaAKjxuqIsRequesting = false
            self.bnxnuaAKjxuqRetryCount = 0   // ✅ 成功后清零
            
            self.peiALwlxuAwiProducts = response.products
            
            print("Loaded:", response.products.map { $0.productIdentifier })
            
            // ⚠️ 如果一个都没拿到，也可以认为失败
            if response.products.isEmpty {
                self.bnxnuaAKjxuqRetryFetch()
            }
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        DispatchQueue.main.async {
            self.bnxnuaAKjxuqIsRequesting = false
            
            print("Load failed:", error.localizedDescription)
            
            self.bnxnuaAKjxuqRetryFetch()
        }
    }
    
    private func bnxnuaAKjxuqRetryFetch() {
        
        bnxnuaAKjxuqRetryCount += 1
        bnxnuaAKjxuqTotalRequestCount += 1   // ✅ 只在失败时累计
        
        guard bnxnuaAKjxuqRetryCount < bnxnuaAKjxuqMaxRetryCount,
              bnxnuaAKjxuqTotalRequestCount < bnxnuaAKjxuqMaxTotalRequestCount else {
            return
        }
        
        let delay = pow(2.0, Double(bnxnuaAKjxuqRetryCount))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.bnxnuaAKjxuqRetryFetch()
        }
    }
}

extension HglijlkKuxaIAPManager: SKPaymentTransactionObserver {
    
    private func findWalletItem(productID: String) -> HglijlkKuxaProduct? {
        eoquaAfporjxuwProducts.first { $0.wisxaHRjeUfrKeyId == productID }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions xowaAwwlTransactions: [SKPaymentTransaction]) {
        
        for xowaAwwlTransaction in xowaAwwlTransactions {
            
            switch xowaAwwlTransaction.transactionState {
                
            case .purchased:
                SKPaymentQueue.default().finishTransaction(xowaAwwlTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
                if let chealaliwPro = eoquaAfporjxuwProducts.first(where: {
                    $0.wisxaHRjeUfrKeyId == xowaAwwlTransaction.payment.productIdentifier
                }) {
                    ieudLKjalComple?(.success(diamond: chealaliwPro.wisxaHRjeUfrGetDiamond))
                }
                ieudLKjalComple = nil
                
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(xowaAwwlTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
                if let error = xowaAwwlTransaction.error as? SKError {
                    if error.code == .paymentCancelled {
                        ieudLKjalComple?(.cancelled)
                    } else {
                        ieudLKjalComple?(.failed(message: error.localizedDescription))
                    }
                } else {
                    ieudLKjalComple?(.failed(message: xowaAwwlTransaction.error?.localizedDescription ?? "Unknown error"))
                }
                ieudLKjalComple = nil
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(xowaAwwlTransaction)
                TuxaliFvswlaHUD.hideLoading()
                
            case .purchasing:
                break
                
            case .deferred:
                print("Purchase pending")
                ieudLKjalComple?(.pending)
            @unknown default:
                break
            }
        }
    }
}
