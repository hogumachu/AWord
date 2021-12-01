import UIKit.UIColor

public let _titleColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return .white
    } else {
        return .systemGreen
    }
}

public let _backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return .systemGreen
    } else {
        return .white
    }
}
