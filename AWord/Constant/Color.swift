import UIKit.UIColor

public let _titleColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return .white
    } else {
        return UIColor(red: 0.25, green: 0.4, blue: 0, alpha: 1)
    }
}

public let _backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return UIColor(red: 0.25, green: 0.4, blue: 0, alpha: 1)
    } else {
        return .white
    }
}
