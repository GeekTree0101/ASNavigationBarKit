import UIKit
import AsyncDisplayKit

class MainViewController: ASViewController<ASDisplayNode> {
    
    enum ScreenType: Int, CaseIterable {
        case single
        case table
        case collection
        case gmail
        
        var title: String {
            switch self {
            case .single: return "Single Screen"
            case .table: return "Table Screen"
            case .collection: return "Collection Screen"
            case .gmail: return "Gmail Example"
            }
        }
    }
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.dataSource = self
        node.delegate = self
        return node
    }()

    init() {
        super.init(node: .init())
        self.node.backgroundColor = .white
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [unowned self] (node, _) -> ASLayoutSpec in
            return ASInsetLayoutSpec(insets: node.safeAreaInsets, child: self.tableNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewController: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return ScreenType.allCases.count
    }
    
    func tableNode(_ tableNode: ASTableNode,
                   nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard let type = ScreenType(rawValue: indexPath.row) else { return ASCellNode() }
            let cellNode = ASTextCellNode.init()
            cellNode.text = type.title
            cellNode.textAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0)]
            cellNode.textInsets = .init(top: 20.0, left: 15.0, bottom: 20.0, right: 15.0)
            cellNode.accessoryType = .disclosureIndicator
            cellNode.selectionStyle = .none
            return cellNode
        }
    }
}

extension MainViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode,
                   didSelectRowAt indexPath: IndexPath) {
        switch ScreenType(rawValue: indexPath.row) {
        case .single?:
            self.navigationController?
                .pushViewController(SingleViewController.init(), animated: true)
        case .table?:
            self.navigationController?
                .pushViewController(TableViewController.init(), animated: true)
        case .collection?:
            self.navigationController?
                .pushViewController(CollectionViewController.init(), animated: true)
        case .gmail?:
            self.navigationController?
                .pushViewController(GmailListNodeController.init(), animated: true)
        default:
            return
        }
    }
}
