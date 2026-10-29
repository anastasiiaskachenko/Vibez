import Foundation

extension UserDefaults {
    private enum Keys {
        static let isLlamaModelApproved = "isLlamaModelApproved"
    }

    var isLlamaModelApproved: Bool? {
        get { object(forKey: Keys.isLlamaModelApproved) as? Bool }
        set  {
            if let newValue {
                set(newValue, forKey: Keys.isLlamaModelApproved)
            } else {
                removeObject(forKey: Keys.isLlamaModelApproved)
            }
        }
    }
}
