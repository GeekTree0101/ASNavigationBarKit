import AsyncDisplayKit

final class FeedItemCellNode: ASCellNode {
    
    struct Const {
        static func titleAttribute(_ cellStyle: CellStyle) -> [NSAttributedStringKey: Any] {
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.alignment = cellStyle == .vertical ? .center: .left
            return [.font: UIFont.boldSystemFont(ofSize: cellStyle == .vertical ? 14.0: 24.0),
                    .foregroundColor: UIColor.darkGray,
                    .paragraphStyle: paragraphStyle]
        }
    }
    
    lazy var imageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.backgroundColor = .lightGray
        node.setURL(URL.randImageURL(), resetToDefault: true)
        node.cornerRadius = 5.0
        return node
    }()
    
    lazy var titleNode = ASTextNode()
    
    enum CellStyle {
        case horizontal
        case vertical
        
        var cellInsets: UIEdgeInsets {
            switch self {
            case .horizontal:
                return .init(top: 20.0, left: 15.0, bottom: 20.0, right: 15.0)
            case .vertical:
                return .zero
            }
        }
    }
    
    private let feedCellStyle: CellStyle
    
    init(title: String, style feedCellStyle: CellStyle) {
        self.feedCellStyle = feedCellStyle
        super.init()
        self.selectionStyle = .none
        self.automaticallyManagesSubnodes = true
        self.titleNode.attributedText = .init(string: title,
                                              attributes: Const.titleAttribute(feedCellStyle))
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageRatioLayout = ASRatioLayoutSpec(ratio: 1.0, child: imageNode)
        
        let elements: [ASLayoutElement] = [imageRatioLayout, titleNode]
        titleNode.style.flexGrow = 1.0
        titleNode.style.flexShrink = 1.0
        
        let stackLayout: ASStackLayoutSpec
        
        switch feedCellStyle {
        case .horizontal:
            imageRatioLayout.style.width = .init(unit: .points, value: 80.0)
            stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10.0,
                                            justifyContent: .spaceBetween,
                                            alignItems: .center,
                                            children: elements)
            
        case .vertical:
            stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 5.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: elements)
        }
        
        return ASInsetLayoutSpec(insets: feedCellStyle.cellInsets,
                                 child: stackLayout)
    }
}
