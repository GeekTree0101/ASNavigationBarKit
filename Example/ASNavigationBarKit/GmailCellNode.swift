import AsyncDisplayKit

class GmailCellNode: ASCellNode {
    
    struct Const {
        static let profileTextAttr: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold),
                                                                    .foregroundColor: UIColor.white]
        static let usernameAttr: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
                                                                 .foregroundColor: UIColor.black]
        static let titleAttr: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
                                                              .foregroundColor: UIColor.black]
        static let contentAttr: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 12.0),
                                                                .foregroundColor: UIColor.gray]
        
        static let cellInsets: UIEdgeInsets = .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    }
    
    let profileNode: ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = .init(width: 40.0, height: 40.0)
        node.cornerRadius = 20.0
        return node
    }()
    
    let usernameNode: ASTextNode2 = {
        let node = ASTextNode2()
        node.maximumNumberOfLines = 2
        return node
    }()
    
    let titleNode: ASTextNode2 = {
        let node = ASTextNode2()
        node.maximumNumberOfLines = 2
        return node
    }()
    
    let contentNode: ASTextNode2 = {
        let node = ASTextNode2()
        node.maximumNumberOfLines = 1
        return node
    }()
    
    init(gmail: Gmail) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.usernameNode.attributedText = NSAttributedString.init(string: gmail.username,
                                                                   attributes: Const.usernameAttr)
        self.titleNode.attributedText = NSAttributedString.init(string: gmail.title,
                                                                attributes: Const.titleAttr)
        self.contentNode.attributedText = NSAttributedString.init(string: gmail.content,
                                                                  attributes: Const.contentAttr)
        self.profileNode.setAttributedTitle(NSAttributedString.init(string: String(gmail.username.uppercased().first ?? .init("?")),
                                                                    attributes: Const.profileTextAttr),
                                            for: .normal)
        self.profileNode.backgroundColor = UIColor.randomColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentElements: [ASLayoutElement] = [titleNode, contentNode]
        for element in contentElements {
            element.style.flexShrink = 1.0
            element.style.flexGrow = 0.0
        }
        
        let contentStackLayout =
            ASStackLayoutSpec(direction: .vertical,
                              spacing: 5.0,
                              justifyContent: .start,
                              alignItems: .stretch,
                              children: contentElements)
        
        contentStackLayout.style.flexShrink = 1.0
        contentStackLayout.style.flexGrow = 0.0
        
        let profileWithContentStackLayout =
            ASStackLayoutSpec(direction: .horizontal,
                              spacing: 12.0,
                              justifyContent: .start,
                              alignItems: .start,
                              children: [profileNode, contentStackLayout])
        
        
        return ASInsetLayoutSpec(insets: Const.cellInsets,
                                 child: profileWithContentStackLayout)
    }
}

