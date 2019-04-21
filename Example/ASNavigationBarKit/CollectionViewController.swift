import UIKit
import AsyncDisplayKit

class CollectionViewController: ASViewController<ASDisplayNode> {
    
    struct Const {
        static let minimumInteritemSpacing: CGFloat = 2.5
        static let minimumLineSpacing: CGFloat = 2.5
    }
    
    lazy var collectionNode: ASCollectionNode = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Const.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = Const.minimumLineSpacing
        let node = ASCollectionNode(collectionViewLayout: flowLayout)
        node.contentInset = .init(top: 30.0, left: 5.0, bottom: 30.0, right: 5.0)
        node.dataSource = self
        node.delegate = self
        return node
    }()
    
    let navbar = CommonNavigationBar.init()
    let items: [String] = ["Apple", "Banana", "Caramel", "Dogmeat", "Egg"] +
        ["Apple", "Banana", "Caramel", "Dogmeat", "Egg"]
    
    init() {
        super.init(node: .init())
        self.node.backgroundColor = .white
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
            return self?.layoutSpecThatFits(sizeRange) ?? ASLayoutSpec()
        }
        self.navbar.configure(target: self, relativeNode: self.collectionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let collectionLayout = ASInsetLayoutSpec(insets: self.node.safeAreaInsets,
                                            child: collectionNode)
        let navbarLayout = self.navbar.layoutSpec(self.node.safeAreaInsets)
        return ASOverlayLayoutSpec(child: collectionLayout, overlay: navbarLayout)
    }
}

extension CollectionViewController: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode,
                        nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return FeedItemCellNode(title: self.items[indexPath.row], style: .vertical)
        }
    }
}

extension CollectionViewController: ASCollectionDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navbar.didScroll(with: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        self.navbar.automaticallyAdjustNavigationBarFrame()
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode,
                        constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        var constrainedWidth: CGFloat = self.collectionNode.bounds.width / 2.0
        constrainedWidth -= Const.minimumInteritemSpacing
        constrainedWidth -= collectionNode.contentInset.left
        constrainedWidth -= collectionNode.contentInset.right
        let min: CGSize = .init(width: constrainedWidth, height: 0.0)
        let max: CGSize =  .init(width: constrainedWidth, height: self.node.bounds.height)
        return ASSizeRange.init(min: min, max: max)
    }
}
