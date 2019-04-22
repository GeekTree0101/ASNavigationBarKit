<img src="https://github.com/GeekTree0101/ASNavigationBarKit/blob/master/Resources/logo.png" />

[![CI Status](https://img.shields.io/travis/Geektree0101/ASNavigationBarKit.svg?style=flat)](https://travis-ci.org/Geektree0101/ASNavigationBarKit)
[![Version](https://img.shields.io/cocoapods/v/ASNavigationBarKit.svg?style=flat)](https://cocoapods.org/pods/ASNavigationBarKit)
[![License](https://img.shields.io/cocoapods/l/ASNavigationBarKit.svg?style=flat)](https://cocoapods.org/pods/ASNavigationBarKit)
[![Platform](https://img.shields.io/cocoapods/p/ASNavigationBarKit.svg?style=flat)](https://cocoapods.org/pods/ASNavigationBarKit)

## TODO
- Remove ReactiveX Dependency
- Update Wiki guide

## Example


<img src="https://github.com/GeekTree0101/ASNavigationBarKit/blob/master/Resources/showcase.gif" />

[Gmail Navigation Bar](https://github.com/GeekTree0101/ASNavigationBarKit/blob/master/Example/ASNavigationBarKit/GmailSearchBarNode.swift)

```swift
import ASNavigationBarKit

class GmailSearchBarNode: ASNavigationBar {

    // ...
    
    // Make a navigationBar layoutSpec
    override func contentLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // ...
    }
}
```

[Gmail Table Node Controller](https://github.com/GeekTree0101/ASNavigationBarKit/blob/master/Example/ASNavigationBarKit/GmailListNodeController.swift)

```swift
class GmailListNodeController: ASViewController<ASDisplayNode> {

    // ...
    
    // 1. Initialize NavigationBar
    lazy var navbar =  GmailSearchBarNode.init()

    private func initializeController() {
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [unowned self] (_, constrainedSize) -> ASLayoutSpec in
            return self.layoutSpecThatFits(constrainedSize)
        }
        
        // ...
        
        // 2. configuration navigationBar
        self.navbar.configure(target: self, relativeNode: tableNode)
    }
    
    private func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // 3. Create navigationBar LayoutSpec
        let navbarLayout = self.navbar.layoutSpec(self.node.safeAreaInsets)
        
        var tableInsets: UIEdgeInsets = self.node.safeAreaInsets
        tableInsets.bottom = 0.0
        let tableLayout = ASInsetLayoutSpec(insets: tableInsets, child: tableNode)
        
        // 4. Overlay NavigationBar Layout
        return ASOverlayLayoutSpec(child: tableLayout, overlay: navbarLayout)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 5. enable scrolling transition
        self.navbar.didScroll(with: scrollView) 
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 6. enable automatically adjust transition
        self.navbar.automaticallyAdjustNavigationBarFrame()
    }
}
```

## Requirements

- 'Texture', '~> 2.7'

## Installation

ASNavigationBarKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ASNavigationBarKit'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

ASNavigationBarKit is available under the MIT license. See the LICENSE file for more info.
