import AsyncDisplayKit
import ASNavigationBarKit

class GmailListNodeController: ASViewController<ASDisplayNode> {
    
    struct Const {
        static let categoryTitleAttr: [NSAttributedStringKey: Any] =
            [.font: UIFont.systemFont(ofSize: 10.0, weight: .bold), .foregroundColor: UIColor.darkGray]
        static let categoryTextInsets: UIEdgeInsets =
            .init(top: 15.0, left: 20.0, bottom: 15.0, right: 0.0)
    }
    
    enum Section: Int, CaseIterable {
        case category
        case email
    }
    
    lazy var navbar =  GmailSearchBarNode.init()
    let tableNode: ASTableNode = .init()
    var emaliItems: [Gmail] = AppDelegate.getGmailList()
    
    init() {
        super.init(node: .init())
        self.initializeController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableNode.view.separatorStyle = .none
    }
    
    private func initializeController() {
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyRelayoutOnSafeAreaChanges = true
        self.node.layoutSpecBlock = { [unowned self] (_, constrainedSize) -> ASLayoutSpec in
            return self.layoutSpecThatFits(constrainedSize)
        }
        self.node.backgroundColor = .white
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.navbar.configure(target: self, relativeNode: tableNode)
    }
    
    private func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let navbarLayout = self.navbar.layoutSpec(self.node.safeAreaInsets)
        
        var tableInsets: UIEdgeInsets = self.node.safeAreaInsets
        tableInsets.bottom = 0.0
        let tableLayout = ASInsetLayoutSpec(insets: tableInsets, child: tableNode)
        
        return ASOverlayLayoutSpec(child: tableLayout, overlay: navbarLayout)
    }
}

extension GmailListNodeController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return Section.allCases.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let `section` = Section(rawValue: section) else { return 0 }
        switch section {
        case .category:
            return 1
        case .email:
            return emaliItems.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard let section = Section(rawValue: indexPath.section) else { return ASCellNode() }
            switch section {
            case .category:
                let textCellNode = ASTextCellNode()
                textCellNode.text = "ALL INBOXES"
                textCellNode.textAttributes = Const.categoryTitleAttr
                textCellNode.textInsets = Const.categoryTextInsets
                return textCellNode
            case .email:
                return GmailCellNode.init(gmail: self.emaliItems[indexPath.row])
            }
        }
    }
}

extension GmailListNodeController: ASTableDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navbar.didScroll(with: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.navbar.automaticallyAdjustNavigationBarFrame()
    }
}
