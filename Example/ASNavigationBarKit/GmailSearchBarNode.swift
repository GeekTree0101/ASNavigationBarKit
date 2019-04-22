import AsyncDisplayKit
import ASNavigationBarKit

class GmailSearchBarNode: ASNavigationBar {
    
    struct Const {
        static let contentInsets: UIEdgeInsets = .init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        static let containerInsets: UIEdgeInsets = .init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        static let profileURL: URL? = URL(string: "https://avatars1.githubusercontent.com/u/19504988?s=460&v=4")
    }
    
    let menuIconNode: MenuIconNode = .init()
    
    let searchBarNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: "Search mail",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14.0,
                                                                                       weight: .light),
                                                              .foregroundColor: UIColor.lightGray])
        return node
    }()
    
    let profileNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = .init(width: 30.0, height: 30.0)
        node.cornerRadius = 15.0
        node.backgroundColor = .lightGray
        node.setURL(Const.profileURL, resetToDefault: true)
        return node
    }()
    
    let containerNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.white
        node.cornerRadius = 5.0
        node.borderWidth = 0.5
        node.borderColor = UIColor.lightGray.cgColor
        node.shadowColor = UIColor.gray.cgColor
        node.shadowOffset = .init(width: 0, height: 2.5)
        node.shadowRadius = 5.0
        node.shadowOpacity = 1.0
        return node
    }()
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.contentNode.backgroundColor = UIColor.clear
        
    }
    
    override func contentLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let containerContentLayout = self.containerContentLayoutSpec()
        let containerLayout = ASBackgroundLayoutSpec(child: containerContentLayout,
                                                     background: containerNode)
        return ASInsetLayoutSpec(insets: Const.containerInsets,
                                 child: containerLayout)
    }
    
    private func containerContentLayoutSpec() -> ASLayoutSpec {
        searchBarNode.style.flexShrink = 1.0
        let leftStackLayout = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 8.0,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [menuIconNode, searchBarNode])
        
        let contentStackLayout = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0.0,
                                                   justifyContent: .spaceBetween,
                                                   alignItems: .center,
                                                   children: [leftStackLayout, profileNode])
        
        return ASInsetLayoutSpec(insets: Const.contentInsets, child: contentStackLayout)
    }
}

final class MenuIconNode: ASDisplayNode {
    
    let stickNodes: [ASDisplayNode] = (0..<3).map({ _ -> ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .gray
        node.style.width = .init(unit: .points, value: 18.0)
        node.style.height = .init(unit: .points, value: 2.0)
        node.cornerRadius = 1.0
        return node
    })
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 2.0,
                                 justifyContent: .start,
                                 alignItems: .start,
                                 children: stickNodes)
    }
}
