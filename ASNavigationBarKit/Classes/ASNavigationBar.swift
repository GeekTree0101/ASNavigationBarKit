import AsyncDisplayKit
import RxSwift
import RxCocoa

open class ASNavigationBar: ASDisplayNode, UIGestureRecognizerDelegate {
    
    public struct ConstrainedOptions: OptionSet {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        // Disable opacity transition.
        public static let disableOpacityTransition = ConstrainedOptions(rawValue: 1 << 0)
        
        // You don't wanna control system navigationBar hidden status.
        public static let ignoreControlSystemNavbar = ConstrainedOptions(rawValue: 1 << 1)
        
        // Unuse default transition frame animation with disable opacity transition.
        public static let unuseDefaultTransition = ConstrainedOptions(rawValue: 1 << 2)
        
        public static let all: ConstrainedOptions =
            [.disableOpacityTransition,
             .ignoreControlSystemNavbar,
             .unuseDefaultTransition]
    }
    
    public let contentNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
        return node
    }()
    
    private var _contentInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private weak var _relativeNode: ASDisplayNode?
    private var _isBeforeDowndragging: Bool = false
    
    open var options: ConstrainedOptions = .init()
    public let disposeBag = DisposeBag()
    
    public override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        self.contentNode.layoutSpecBlock = { [weak self] (_, constrainedSize) -> ASLayoutSpec in
            return self?.contentLayoutSpecThatFits(constrainedSize) ?? ASLayoutSpec()
        }
    }
    
    override open func layout() {
        super.layout()
        guard let node = self._relativeNode else { return }
        self.adjustScrollableContentInsets(node)
        self._relativeNode = nil
    }
    
    /**
     Configuration ASNavigationBar
     
     - important: You must call it at init: of Your ViewController
     
     - parameters:
     - target: Target ViewController
     - relativeNode: Scrollable node for adjust top of contentInsets
     */
    open func configure(target viewController: UIViewController,
                        relativeNode: ASDisplayNode?) {
        self._relativeNode = relativeNode
        viewController.rx.methodInvoked(#selector(viewController.viewWillAppear))
            .subscribe(onNext: { [weak self] _ in
                self?.unuseSystemNavigationBarOnViewWillAppearIfNeeds()
            })
            .disposed(by: disposeBag)
        viewController.rx.methodInvoked(#selector(viewController.viewWillDisappear))
            .subscribe(onNext: { [weak self] _ in
                self?.rollbackSystemNavigationBarOnViewWillDisappearIfNeeds()
            })
            .disposed(by: disposeBag)
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: _contentInsets, child: contentNode)
    }
    
    /**
     Unuse System NavigationBar If Needs
     
     - important: will operate at viewWillAppear:
     than insert .ignoreControlSystemNavbar
     */
    open func unuseSystemNavigationBarOnViewWillAppearIfNeeds() {
        guard !self.options.contains(.ignoreControlSystemNavbar) else { return }
        self.closestViewController?
            .navigationController?.isNavigationBarHidden = true
        self.closestViewController?
            .navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /**
     Rollback System navigationBar If Needs
     
     - important: will operate at viewWillDisappear:, if you don't wanna use it
     than insert .ignoreControlSystemNavbar
     */
    open func rollbackSystemNavigationBarOnViewWillDisappearIfNeeds() {
        guard !self.options.contains(.ignoreControlSystemNavbar) else { return }
        self.closestViewController?
            .navigationController?.isNavigationBarHidden = false
        self.closestViewController?
            .navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    /**
     Create a content area layoutSpec
     
     - important: default is 44.0pt content layout
     
     - parameters:
     - constrainedSize: constrainedSize from ASNavigationBar
     */
    open func contentLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASLayoutSpec()
        layout.style.height = .init(unit: .points, value: 44.0)
        return layout
    }
    
    /**
     Adjust scrollable node contentInsets
     
     - parameters:
     - relativeNode: Scrollable Content Node such as ASScrollNode, ASTableNode, ASCollectionNode etc
     */
    open func adjustScrollableContentInsets(_ relativeNode: ASDisplayNode) {
        let calculatedContentAreaHeight: CGFloat = self.contentNode.calculatedSize.height
        
        switch relativeNode {
        case let tableNode as ASTableNode:
            var insets = tableNode.contentInset
            insets.top += calculatedContentAreaHeight
            tableNode.contentInset = insets
        case let collectionNode as ASCollectionNode:
            var insets = collectionNode.contentInset
            insets.top += calculatedContentAreaHeight
            collectionNode.contentInset = insets
        case let scrollNode as ASScrollNode:
            var insets = scrollNode.view.contentInset
            insets.top += calculatedContentAreaHeight
            scrollNode.view.contentInset = insets
        default:
            break
        }
    }
    
    /**
     Adjust navigaitonBar frame at scrollViewDidScroll
     
     - important: You must set it at scrollViewDidScroll:
     
     - parameters:
     - scrollView: scrollView for calculate navigationBar frame (UIScrollView)
     */
    open func didScroll(with scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        self._isBeforeDowndragging = scrollView.panGestureRecognizer.velocity(in: nil).y < 0.0
        let translationY = scrollView.panGestureRecognizer.translation(in: nil).y
        let offsetY: CGFloat
        
        if _isBeforeDowndragging {
            offsetY = min(0, max(-self.frame.height, translationY))
        } else {
            offsetY = min(0, translationY - self.frame.height)
        }
        
        let transitionRate: CGFloat = max(0.0, min(1.0, 1 - abs(offsetY / self.frame.height)))
        
        self.didCalculatedTransitionRate(transitionRate)
        
        guard !options.contains(.unuseDefaultTransition) else { return }
        if _isBeforeDowndragging {
            guard self.frame.origin.y > -self.frame.height else { return }
        } else {
            guard self.frame.origin.y != 0.0 else { return }
        }
        
        if !options.contains(.unuseDefaultTransition) {
            self.contentNode.alpha = transitionRate
        }
        
        let origin: CGPoint = .init(x: self.frame.origin.x, y: offsetY)
        let size: CGSize = self.frame.size
        self.frame = .init(origin: origin, size: size)
    }
    
    
    /**
     Passing Calculated navigation nar transition rate (0.0 ~ 1.0)
     
     - important: If you needs custom transition animation base on rate, just override this method!
     */
    open func didCalculatedTransitionRate(_ rate: CGFloat) {
        // override
    }
    
    /**
     Adjust finalize status navigaitonBar frame
     
     - important: Recommend use it at scrollViewDidEndDragging:
     */
    open func automaticallyAdjustNavigationBarFrame() {
        guard !options.contains(.unuseDefaultTransition) else { return }
        
        let offsetY: CGFloat = self._isBeforeDowndragging ? -self.frame.height: 0.0
        let origin: CGPoint = .init(x: self.frame.origin.x, y: offsetY)
        let size: CGSize = self.frame.size
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = .init(origin: origin, size: size)
            let rate: CGFloat = 1 - abs(offsetY / self.frame.height)
            
            if !self.options.contains(.disableOpacityTransition) {
                self.contentNode.alpha = rate
            }
            
            self.didCalculatedTransitionRate(rate)
        })
    }
    
    /**
     Convenience create a navigationBar layoutSpec
     
     - parameters:
     - safeAreaInsets: Root node safeAreaInsets (UIEdgeInsets)
     */
    open func layoutSpec(_ safeAreaInsets: UIEdgeInsets) -> ASLayoutSpec {
        self._contentInsets = .init(top: safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        let navBarInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: .infinity, right: 0)
        return ASInsetLayoutSpec(insets: navBarInsets, child: self)
    }
}
