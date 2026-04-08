import SwiftUI

final class PyifkaLvtjhfState {

  private init() {}

  private static let defaults = UserDefaults.standard

  static var pyifkaLvtjhfAgree: Bool {
    get { defaults.bool(forKey: "pyifkaLvtjhfAgree") }
    set { defaults.set(newValue, forKey: "pyifkaLvtjhfAgree") }
  }
    
    static var pyifkaLvtjhfAgreeEULA: Bool {
      get { defaults.bool(forKey: "pyifkaLvtjhfAgreeEULA") }
      set { defaults.set(newValue, forKey: "pyifkaLvtjhfAgreeEULA") }
    }

}

