import AsyncDisplayKit
import ASNavigationBarKit

class CommonNavigationBar: ASNavigationBar {
    
    lazy var backButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setTitle("Back", with: UIFont.boldSystemFont(ofSize: 14.0), with: nil, for: .normal)
        return node
    }()
    
    lazy var seperateLineNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.height = .init(unit: .points, value: 0.5)
        return node
    }()
    
    override init() {
        super.init()
        backButtonNode.addTarget(self,
                                 action: #selector(didTapBack),
                                 forControlEvents: .touchUpInside)
    }
    
    @objc func didTapBack() {
        if let navigationController = self.closestViewController?.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.closestViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func contentLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets: UIEdgeInsets = .init(top: 15.0, left: 15.0, bottom: 15.0, right: .infinity)
        let insetLayout = ASInsetLayoutSpec(insets: insets, child: backButtonNode)
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 0.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [insetLayout, seperateLineNode])
    }
}
