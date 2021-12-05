import UIKit.UIColor

public let _titleColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    return UIColor(hex: "22577E")
}

public let _backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    return UIColor(hex: "F6F2D4")
}

public let _lightTitleColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    return UIColor(hex: "5584AC")
    
}

public let _lightBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    return UIColor(hex: "F6F2D4", alpha: 0.8)
}
