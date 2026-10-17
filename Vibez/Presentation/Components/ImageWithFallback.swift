import SwiftUI

extension Image {
    init (itemId: Int, fallbackImage: String = "notFound") {
        let name = "\(itemId)"
        if UIImage(named: name) != nil {
            self.init(name)
        } else {
            self.init(fallbackImage)
        }
    }
}
