import UIKit
import AsyncDisplayKit
import ASNavigationBarKit

class TableViewController: ASViewController<ASDisplayNode> {
    
    let items: [String] = ["Apple", "Banana", "Caramel", "Dogmeat", "Egg",
                           "Apple", "Banana", "Caramel", "Dogmeat", "Egg",
                            "Apple", "Banana", "Caramel", "Dogmeat", "Egg",
                           "Apple", "Banana", "Caramel", "Dogmeat", "Egg",
                           "Apple", "Banana", "Caramel", "Dogmeat", "Egg"]
    
    let navbar = CommonNavigationBar.init()
    let tableNode = ASTableNode()
    
    init() {
        super.init(node: .init())
        self.title = "Table Example"
        self.node.backgroundColor = .white
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [weak self] (_, _) -> ASLayoutSpec in
            return self?.layoutSpecThatFits() ?? ASLayoutSpec()
        }
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.navbar.configure(target: self, relativeNode: self.tableNode)
    }
    
    func layoutSpecThatFits() -> ASLayoutSpec {
        let tableLayout = ASInsetLayoutSpec(insets: self.node.safeAreaInsets,
                                            child: tableNode)
        let navbarLayout = self.navbar.layoutSpec(self.node.safeAreaInsets)
        return ASOverlayLayoutSpec(child: tableLayout, overlay: navbarLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewController: ASTableDataSource, ASTableDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navbar.didScroll(with: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.navbar.automaticallyAdjustNavigationBarFrame()
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return FeedItemCellNode(title: self.items[indexPath.row], style: .horizontal)
        }
    }
}

