// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let property1FriendsProperty2Act = ImageAsset(name: "Property 1=friends, Property 2=act")
  internal static let property1FriendsProperty2Inact = ImageAsset(name: "Property 1=friends, Property 2=inact")
  internal static let property1HomeProperty2Act = ImageAsset(name: "Property 1=home, Property 2=act")
  internal static let property1HomeProperty2Inact = ImageAsset(name: "Property 1=home, Property 2=inact")
  internal static let property1MyProperty2Act = ImageAsset(name: "Property 1=my, Property 2=act")
  internal static let property1MyProperty2Inact = ImageAsset(name: "Property 1=my, Property 2=inact")
  internal static let property1SendProperty2Act = ImageAsset(name: "Property 1=send, Property 2=act")
  internal static let property1SendProperty2Inact = ImageAsset(name: "Property 1=send, Property 2=inact")
  internal static let property1ShopProperty2Act = ImageAsset(name: "Property 1=shop, Property 2=act")
  internal static let property1ShopProperty2Inact = ImageAsset(name: "Property 1=shop, Property 2=inact")
  internal static let property1ToggleToggleOff = ImageAsset(name: "Property 1=toggle, toggle=off")
  internal static let property1ToggleToggleOn = ImageAsset(name: "Property 1=toggle, toggle=on")
  internal static let antenna = ImageAsset(name: "antenna")
  internal static let arrow = ImageAsset(name: "arrow")
  internal static let bagde = ImageAsset(name: "bagde")
  internal static let bell = ImageAsset(name: "bell")
  internal static let cancelMatch = ImageAsset(name: "cancel_match")
  internal static let check = ImageAsset(name: "check")
  internal static let closeBig = ImageAsset(name: "close_big")
  internal static let closeSmall = ImageAsset(name: "close_small")
  internal static let filterControl = ImageAsset(name: "filter_control")
  internal static let friendsPlus = ImageAsset(name: "friends_plus")
  internal static let img = ImageAsset(name: "img")
  internal static let man = ImageAsset(name: "man")
  internal static let message = ImageAsset(name: "message")
  internal static let more = ImageAsset(name: "more")
  internal static let moreArrow = ImageAsset(name: "more_arrow")
  internal static let place = ImageAsset(name: "place")
  internal static let plus = ImageAsset(name: "plus")
  internal static let search = ImageAsset(name: "search")
  internal static let siren = ImageAsset(name: "siren")
  internal static let woman = ImageAsset(name: "woman")
  internal static let write = ImageAsset(name: "write")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
