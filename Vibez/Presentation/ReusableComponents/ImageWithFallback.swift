import SwiftUI
import UIKit

extension Image {
    init (genreId: Int, fallbackImage: String = "notFound") {
        let name = "\(genreId)"
        if UIImage(named: name) != nil {
            self.init(name)
        } else {
            self.init(fallbackImage)
        }
    }
}
