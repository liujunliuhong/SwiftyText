//
//  SwiftyLabel.swift
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import CoreText
/*  UILabel Properties
 ✅ text
 ✅ font
 ✅ textColor
 ✅ shadowColor
 ✅ shadowOffset
 ✅ textAlignment
 ✅ lineBreakMode
 ✅ attributedText
 ✅ numberOfLines
 ✅ isUserInteractionEnabled
 ❌ highlightedTextColor
 ❌ isHighlighted
 ❌ isEnabled
 ❌ adjustsFontSizeToFitWidth
 ❌ baselineAdjustment
 ❌ minimumScaleFactor
 ❌ allowsDefaultTighteningForTruncation
 ❌ preferredMaxLayoutWidth
 
 open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
 open func drawText(in rect: CGRect)
 */


/* SwiftyLabel Support Properties
 text
 font
 textColor
 lineBreakMode
 textAlignment
 shadowColor
 shadowOffset
 shadowBlurRadius
 
 attributedText
 numberOfLines
 exclusionPaths
 truncationToken
 verticalAlignment
 truncationType
 displaysAsynchronously
 */

fileprivate let kLongPressMinimumDuration: TimeInterval = 0.5
fileprivate let kLongPressAllowableMovement: CGFloat = 9
fileprivate let kHighlightFadeDuration: TimeInterval = 0.15
fileprivate let kAsyncFadeDuration: TimeInterval = 0.08

open class SwiftyLabel: UIView {
    
    private var _text: String?
    open var text: String? {
        set {
            if _text == newValue {
                return
            }
            _text = newValue
            
            let tmpText = _text ?? ""
            
            self.innerAttributedText.replaceCharacters(in: NSRange(location: 0, length: self.innerAttributedText.length), with: tmpText)
            self.innerAttributedText.st_removeDiscontinuousAttributes()
            
            self.innerAttributedText.st_add(font: self.font)
            self.innerAttributedText.st_add(textColor: self.textColor)
            self.innerAttributedText.st_add(alignment: self.textAlignment)
            
            switch self.lineBreakMode {
            case .byWordWrapping,
                 .byCharWrapping,
                 .byClipping:
                self.innerAttributedText.st_add(lineBreakMode: self.lineBreakMode)
            case .byTruncatingHead,
                 .byTruncatingTail,
                 .byTruncatingMiddle:
                self.innerAttributedText.st_add(lineBreakMode: .byWordWrapping)
            default:
                self.innerAttributedText.st_add(lineBreakMode: .byWordWrapping)
            }
            
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _text
        }
    }
    
    
    
    private static let defaultFont = UIFont.systemFont(ofSize: 17)
    private var _font: UIFont = SwiftyLabel.defaultFont
    open var font: UIFont? {
        set {
            let tmpFont = newValue ?? SwiftyLabel.defaultFont
            if _font == tmpFont {
                return
            }
            _font = tmpFont
            
            self.innerAttributedText.st_add(font: _font)
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _font
        }
    }
    
    
    private var _textColor: UIColor = .black
    open var textColor: UIColor {
        set {
            if _textColor == newValue {
                return
            }
            _textColor = newValue
            
            self.innerAttributedText.st_add(textColor: _textColor)
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
        }
        get {
            _textColor
        }
    }
    
    
    private var _textAlignment: NSTextAlignment = .left
    open var textAlignment: NSTextAlignment {
        set {
            if _textAlignment == newValue {
                return
            }
            _textAlignment = newValue
            
            self.innerAttributedText.st_add(alignment: _textAlignment)
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _textAlignment
        }
    }
    
    
    private var _shadowColor: UIColor?
    open var shadowColor: UIColor? {
        set {
            if _shadowColor == newValue {
                return
            }
            
            _shadowColor = newValue
            
            self.innerAttributedText.st_add(shadow: self.shadowFromProperties())
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
        }
        get {
            _shadowColor
        }
    }
    
    
    private var _shadowOffset: CGSize = .zero
    open var shadowOffset: CGSize {
        set {
            if _shadowOffset == newValue {
                return
            }
            _shadowOffset = newValue
            
            self.innerAttributedText.st_add(shadow: self.shadowFromProperties())
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
        }
        get {
            _shadowOffset
        }
    }
    
    private var _shadowBlurRadius: CGFloat = .zero
    open var shadowBlurRadius: CGFloat {
        set {
            if _shadowBlurRadius == newValue {
                return
            }
            _shadowBlurRadius = newValue
            
            self.innerAttributedText.st_add(shadow: self.shadowFromProperties())
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
        }
        get {
            _shadowBlurRadius
        }
    }
    
    
    
    
    
    private var _attributedText: NSAttributedString?
    open var attributedText: NSAttributedString? {
        set {
            if _attributedText == newValue {
                return
            }
            if let atr = newValue, atr.length > 0 {
                self.innerAttributedText = NSMutableAttributedString(attributedString: atr)
                switch self.lineBreakMode {
                case .byWordWrapping,
                     .byCharWrapping,
                     .byClipping:
                    self.innerAttributedText.st_add(lineBreakMode: self.lineBreakMode)
                case .byTruncatingHead,
                     .byTruncatingTail,
                     .byTruncatingMiddle:
                    self.innerAttributedText.st_add(lineBreakMode: .byWordWrapping)
                default:
                    self.innerAttributedText.st_add(lineBreakMode: .byWordWrapping)
                }
            } else {
                self.innerAttributedText = NSMutableAttributedString()
            }
            
            _attributedText = self.innerAttributedText
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.updateOuterTextProperties()
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _attributedText
        }
    }
    
    
    
    
    private var _numberOfLines: Int = 1
    open var numberOfLines: Int {
        set {
            if _numberOfLines == newValue {
                return
            }
            _numberOfLines = newValue
            self.innerContainer.numberOfLines = newValue
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _numberOfLines
        }
    }
    
    
    
    private var _exclusionPaths: [UIBezierPath] = []
    open var exclusionPaths: [UIBezierPath] {
        set {
            if _exclusionPaths == newValue {
                return
            }
            _exclusionPaths = newValue
            self.innerContainer.exclusionPaths = newValue
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _exclusionPaths
        }
    }
    
    
    
    private var _truncationToken: NSAttributedString?
    open var truncationToken: NSAttributedString? {
        set {
            if _truncationToken == newValue {
                return
            }
            _truncationToken = newValue
            self.innerContainer.truncationToken = newValue
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _truncationToken
        }
    }
    
    
    
    var _verticalAlignment: SwiftyTextVerticalAlignment = .top
    open var verticalAlignment: SwiftyTextVerticalAlignment {
        set {
            if _verticalAlignment == newValue {
                return
            }
            _verticalAlignment = newValue
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _verticalAlignment
        }
    }
    
    private var _lineBreakMode: NSLineBreakMode = .byTruncatingTail
    open var lineBreakMode: NSLineBreakMode {
        set {
            if _lineBreakMode == newValue {
                return
            }
            
            _lineBreakMode = newValue
            
            self.innerContainer.lineBreakMode = _lineBreakMode
            
            if self.displaysAsynchronously {
                self.clearContents()
            }
            self.setLayoutNeedUpdate()
            self.endTouch()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return _lineBreakMode
        }
    }
    
    
    open var displaysAsynchronously: Bool = true {
        didSet {
            if let asyncLayer = self.layer as? SwiftyTextAsyncLayer {
                asyncLayer.displaysAsynchronously = displaysAsynchronously
            }
        }
    }
    
    
    
    
    private struct State {
        var layoutNeedUpdate: Bool = false
        var showingHighlight : Bool = false
        
        var trackingTouch : Bool = false
        var swallowTouch : Bool = false
        var touchMoved : Bool = false
        
        var contentsNeedFade : Bool = false
    }
    
    private var innerAttributedText: NSMutableAttributedString = NSMutableAttributedString()
    private var innerLayout: SwiftyTextLayout?
    private var innerContainer: SwiftyTextContainer = SwiftyTextContainer()
    
    private var attachmentViews = [UIView]()
    private var attachmentLayers = [CALayer]()
    
    private var highlightLayout: SwiftyTextLayout?
    private var highlight: SwiftyTextHighlight?
    private var highlightRange: NSRange = NSRange(location: 0, length: 0)
    
    private var shrinkInnerLayout: SwiftyTextLayout?
    private var shrinkHighlightLayout: SwiftyTextLayout?
    
    private var longPressTimer: Timer?
    private var touchBeganPoint = CGPoint.zero
    
    private lazy var state = State()
    
    deinit {
        print("\(#function)")
        self.endLongPressTimer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setup()
        self.frame = frame
    }
    
    public init() {
        super.init(frame: .zero)
        self.setup()
        self.frame = .zero
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyLabel {
    private func setup() {
        if let asyncLayer = self.layer as? SwiftyTextAsyncLayer {
            asyncLayer.displaysAsynchronously = true
        }
        self.layer.contentsScale = UIScreen.main.scale
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.contentMode = .redraw
        self.clipsToBounds = false
        
        self.innerContainer = SwiftyTextContainer()
        self.innerContainer.numberOfLines = self.numberOfLines
    }
    
    open override class var layerClass: AnyClass {
        return SwiftyTextAsyncLayer.self
    }
}

extension SwiftyLabel {
    open override var frame: CGRect {
        set {
            let oldSize: CGSize = bounds.size
            super.frame = newValue
            let newSize: CGSize = bounds.size
            if oldSize != newSize {
                self.innerContainer.size = self.bounds.size
                self.state.layoutNeedUpdate = true
                if self.displaysAsynchronously {
                    self.clearContents()
                }
                self.setLayoutNeedRedraw()
            }
        }
        get {
            return super.frame
        }
    }
    
    open override var bounds: CGRect {
        set {
            let oldSize: CGSize = bounds.size
            super.bounds = newValue
            let newSize: CGSize = bounds.size
            if oldSize != newSize {
                self.innerContainer.size = self.bounds.size
                self.state.layoutNeedUpdate = true
                if self.displaysAsynchronously {
                    self.clearContents()
                }
                self.setLayoutNeedRedraw()
            }
        }
        get {
            return super.bounds
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size: CGSize = size
        
        if size.width.isLessThanOrEqualTo(.zero) {
            size.width = SwiftyTextMaxSize.width
        }
        if size.height.isLessThanOrEqualTo(.zero) {
            size.height = SwiftyTextMaxSize.height
        }
        if let container = self.innerContainer.copy() as? SwiftyTextContainer {
            container.size = size
            let layout = SwiftyTextLayout.layout(container: container, attributedText: self.innerAttributedText)
            return layout?.textSize ?? .zero
        }
        return .zero
    }
}

extension SwiftyLabel {
    private func shadowFromProperties() -> NSShadow? {
        let shadow = NSShadow()
        shadow.shadowColor = self.shadowColor
        shadow.shadowOffset = self.shadowOffset
        shadow.shadowBlurRadius = self.shadowBlurRadius
        return shadow
    }
    
    private func updateOuterLineBreakMode() {
        switch self.innerContainer.truncationType {
        case .start:
            _lineBreakMode = .byTruncatingHead
        case .middle:
            _lineBreakMode = .byTruncatingMiddle
        case .end:
            _lineBreakMode = .byTruncatingTail
        default:
            _lineBreakMode = self.innerAttributedText.st_lineBreakMode()
        }
    }
    
    private func updateOuterTextProperties() {
        _text = self.innerAttributedText.st_plainText()
        _font = self.innerAttributedText.st_font() ?? SwiftyLabel.defaultFont
        _textColor = self.innerAttributedText.st_textColor() ?? UIColor.black
        _textAlignment = self.innerAttributedText.st_alignment()
        _lineBreakMode = self.innerAttributedText.st_lineBreakMode()
        _attributedText = self.innerAttributedText
        self.updateOuterLineBreakMode()
    }
    
    private func updateOuterContainerProperties() {
        _truncationToken = self.innerContainer.truncationToken
        _numberOfLines = self.innerContainer.numberOfLines
        _exclusionPaths = self.innerContainer.exclusionPaths
        self.updateOuterLineBreakMode()
    }
}

extension SwiftyLabel {
    /// Update if update is possible
    private func updateIfNeeded() {
        if !self.state.layoutNeedUpdate {
            return
        }
        self.state.layoutNeedUpdate = false
        self.updateLayout()
        self.setLayoutNeedRedraw()
    }
    
    /// update layout
    private func updateLayout() {
        self.innerLayout = SwiftyTextLayout.layout(container: self.innerContainer, attributedText: self.innerAttributedText)
        self.shrinkInnerLayout = SwiftyLabel.getShrinkLayout(layout: self.innerLayout)
    }
    
    /// refresh
    private func setLayoutNeedRedraw() {
        self.layer.setNeedsDisplay()
    }
    
    /// Force refresh
    private func setLayoutNeedUpdate() {
        self.state.layoutNeedUpdate = true
        self.clearInnerLayout()
        self.setLayoutNeedRedraw()
    }
    
    /// clear inner layout
    private func clearInnerLayout() {
        if self.innerLayout == nil {
            return
        }
        let layout: SwiftyTextLayout? = self.innerLayout
        self.innerLayout = nil
        self.shrinkInnerLayout = nil
        // 目前没有弄明白为什么要写下面👇这几行代码
        DispatchQueue.global(qos: .default).async {
            let text: NSAttributedString? = layout?.attributedText
            if let count = layout?.attachments.count, count != 0 {
                DispatchQueue.main.async {
                    let _ = text?.length
                }
            }
        }
    }
}

extension SwiftyLabel {
    private func convertPoint(toLayout point: CGPoint) -> CGPoint {
        var point = point
        guard let innerLayout = self.innerLayout else {
            return .zero
        }
        let textSize = innerLayout.textSize
        if self.verticalAlignment == .center {
            point.y = point.y - ((self.bounds.height - textSize.height) / 2.0)
        } else if self.verticalAlignment == .bottom {
            point.y = point.y - (self.bounds.height - textSize.height)
        }
        return point
    }
    
    private func getHighlight(at point: CGPoint) -> (highlight:SwiftyTextHighlight?, highlightRange: NSRange) {
        guard let innerLayout = self.innerLayout else {
            return (highlight: nil, highlightRange: NSRange(location: 0, length: 0))
        }
        // 通过触摸点找到触摸点对应的`SwiftyTextHighlight`
        var touchHightlight: SwiftyTextHighlight?
        for (_, line) in innerLayout.lines.enumerated() {
            var isFinish = false
            for (j, runRect) in line.runRects.enumerated() {
                if runRect.contains(point) {
                    let run = line.runs[j] // 触摸点对应的run
                    if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
                        let highlight = runAttributes[.stHighlightAttributeName] as? SwiftyTextHighlight {
                        touchHightlight = highlight // 触摸点对应的`YHTextHighlight`
                        isFinish = true
                        break
                    }
                }
            }
            if isFinish {
                break
            }
        }
        
        if touchHightlight == nil {
            return (highlight: nil, highlightRange: NSRange(location: 0, length: 0))
        }
        
        // 根据得到的`SwiftyTextHighlight`找到所有ranges集合
        // FIXME: 此处有待优化
        var highlightRanges: [NSRange] = []
        for (_, line) in innerLayout.lines.enumerated() {
            for (_, run) in line.runs.enumerated() {
                if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
                    let highlight = runAttributes[.stHighlightAttributeName] as? SwiftyTextHighlight {
                    if highlight == touchHightlight! {
                        let runRange: CFRange = CTRunGetStringRange(run)
                        let range = NSRange(location: runRange.location, length: runRange.length)
                        highlightRanges.append(range)
                    }
                }
            }
        }
        let unionRange = highlightRanges.st_ranges_union()
        return (highlight: touchHightlight, highlightRange: unionRange)
    }
    
    
    private func showHighlight(animated: Bool) {
        if self.highlight == nil {
            return
        }
        
        if self.highlightLayout == nil {
            let newAttrs = self.highlight!.highlightAttributes
            if let newAtr = self.innerAttributedText.mutableCopy() as? NSMutableAttributedString {
                for (key, value) in newAttrs {
                    newAtr.st_addAttribute(key: key, value: value, range: self.highlightRange)
                }
                self.highlightLayout = SwiftyTextLayout.layout(container: self.innerContainer, attributedText: newAtr)
                self.shrinkHighlightLayout = SwiftyLabel.getShrinkLayout(layout: self.highlightLayout)
                if self.highlightLayout == nil {
                    self.highlight = nil
                }
            }
        }
        
        if self.highlightLayout != nil && !self.state.showingHighlight {
            self.state.showingHighlight = true
            self.state.contentsNeedFade = animated
            self.setLayoutNeedRedraw()
        }
    }
    
    private func hideHighlight(animated: Bool) {
        if !self.state.showingHighlight {
            return
        }
        self.state.showingHighlight = false
        self.state.contentsNeedFade = animated
        self.setLayoutNeedRedraw()
    }
    
    private func removeHighlight(animated: Bool) {
        self.hideHighlight(animated: animated)
        self.highlight = nil
        self.highlightLayout = nil
        self.shrinkHighlightLayout = nil
    }
    
    private func endTouch() {
        self.endLongPressTimer()
        self.removeHighlight(animated: true)
        self.state.trackingTouch = false
    }
    
    private func startLongPressTimer() {
        self.longPressTimer?.invalidate()
        let proxy = SwiftyTextProxy(target: self)
        self.longPressTimer = Timer(timeInterval: kLongPressMinimumDuration, target: proxy, selector: #selector(longPressAction), userInfo: nil, repeats: false)
        if let t = self.longPressTimer {
            RunLoop.current.add(t, forMode: .common)
        }
    }
    
    private func endLongPressTimer() {
        self.longPressTimer?.invalidate()
        self.longPressTimer = nil
    }
    
    // 为什么有`shrinkLayout`这么个属性？？？？
    private class func getShrinkLayout(layout: SwiftyTextLayout?) -> SwiftyTextLayout? {
        guard let layout = layout else {
            return nil
        }
        // `attributedText`存在，`lines`的数目为0，才设置`shrinkLayout`
        guard let attributedText = layout.attributedText, attributedText.length > 0, layout.lines.count == 0 else {
            return nil
        }
        guard let container = layout.textContainer.copy() as? SwiftyTextContainer else {
            return nil
        }
        container.numberOfLines = 1
        var containerSize = container.size
        containerSize.height = SwiftyTextMaxSize.height
        container.size = containerSize
        return SwiftyTextLayout.layout(container: container, attributedText: attributedText)
    }
    
    private func getInnerLayout() -> SwiftyTextLayout? {
        if self.shrinkInnerLayout == nil {
            return self.innerLayout
        }
        return self.shrinkInnerLayout
    }
    
    private func getHighlightLayout() -> SwiftyTextLayout? {
        if self.shrinkHighlightLayout == nil {
            return self.highlightLayout
        }
        return self.shrinkHighlightLayout
    }
    
    private func clearContents() {
        let image = self.layer.contents as! CGImage?
        self.layer.contents = nil
        if image != nil {
            // 还不清除为什么要写下面👇的代码
            DispatchQueue.global(qos: .default).async {
                let _ = image
            }
        }
    }
}

extension SwiftyLabel {
    // long press action
    @objc func longPressAction() {
        // end timer
        self.endLongPressTimer()
        // check
        if self.highlight != nil {
            // 长按手势回调出去
            self.highlight?.longPressAction?(self, self.innerAttributedText, self.highlightRange, self.highlight?.userInfo)
            // remove highlight
            self.removeHighlight(animated: true)
            // trackingTouch设置为false
            self.state.trackingTouch = false
        }
    }
}

// MARK: - Touch
extension SwiftyLabel {
    /*
     1、获取触摸点
     2、获取触摸点所对应的字符的`SwiftyTextHighlight`对象
     3、遍历run，获取所有run的`SwiftyTextHighlight`对象等于触摸点的`SwiftyTextHighlight`对象的所有run集合
     4、遍历run集合，去除所有不连续的run，剩余的run就是高亮所对应的所有run
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesBegan")
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        self.updateIfNeeded()
        
        let convertPoint = self.convertPoint(toLayout: location)
        
        let highlightInfo = self.getHighlight(at: convertPoint)
        let highlight: SwiftyTextHighlight? = highlightInfo.highlight
        let highlightRange: NSRange = highlightInfo.highlightRange
        
        self.highlight = highlight
        self.highlightRange = highlightRange
        self.highlightLayout = nil
        self.shrinkHighlightLayout = nil
        
        if self.highlight != nil {
            self.touchBeganPoint = location
            self.state.swallowTouch = true
            self.state.trackingTouch = true
            self.state.touchMoved = false
            if self.highlight?.longPressAction != nil {
                self.startLongPressTimer()
            }
            self.showHighlight(animated: false)
        } else {
            self.state.trackingTouch = false
            self.state.swallowTouch = false
            self.state.touchMoved = false
        }
        
        if !self.state.swallowTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesMoved")
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        self.updateIfNeeded()
        
        if self.state.trackingTouch {
            if !self.state.touchMoved {
                let moveH = touchPoint.x - self.touchBeganPoint.x
                let moveV = touchPoint.y - self.touchBeganPoint.y
                if abs(moveH) > abs(moveV) {
                    if abs(moveH) > kLongPressAllowableMovement {
                        self.state.touchMoved = true
                    }
                } else {
                    if abs(moveV) > kLongPressAllowableMovement {
                        self.state.touchMoved = true
                    }
                }
                if self.state.touchMoved {
                    self.endLongPressTimer()
                }
            }
            if self.state.touchMoved && self.highlight != nil {
                let convertPoint = self.convertPoint(toLayout: touchPoint)
                let highlightInfo = self.getHighlight(at: convertPoint)
                if highlightInfo.highlight == self.highlight {
                    self.showHighlight(animated: true)
                } else {
                    self.hideHighlight(animated: true)
                }
            }
        }
        
        if !self.state.swallowTouch {
            super.touchesMoved(touches, with: event)
        }
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesEnded")
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        if self.state.trackingTouch {
            self.endLongPressTimer()
            if self.highlight != nil {
                let convertPoint = self.convertPoint(toLayout: touchPoint)
                let highlightInfo = self.getHighlight(at: convertPoint)
                if !self.state.touchMoved || highlightInfo.highlight == self.highlight {
                    // 把点击事件回调出去
                    self.highlight?.tapAction?(self, self.innerAttributedText, self.highlightRange, self.highlight?.userInfo)
                }
                self.removeHighlight(animated: true)
            }
        }
        if !self.state.swallowTouch {
            super.touchesEnded(touches, with: event)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesCancelled")
        self.endTouch()
        if !self.state.swallowTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}


extension SwiftyLabel: SwiftyTextAsyncLayerDelegate {
    open func newAsyncDisplayTask() -> SwiftyTextAsyncLayerDisplayTask {
        // 存储临时变量
        let contentsNeedFade_ = self.state.contentsNeedFade
        var text_: NSAttributedString = self.innerAttributedText
        var container_: SwiftyTextContainer? = self.innerContainer
        let verticalAlignment_: SwiftyTextVerticalAlignment = self.verticalAlignment
        
        let layoutNeedUpdate_ = self.state.layoutNeedUpdate
        
        let fadeForAsync_: Bool = self.displaysAsynchronously
        var layout_: SwiftyTextLayout? = (self.state.showingHighlight && self.highlight != nil) ? self.getHighlightLayout() : self.getInnerLayout()
        var shrinkLayout_: SwiftyTextLayout? = nil
        var layoutUpdated_: Bool = false
        
        if layoutNeedUpdate_ {
            text_ = text_.copy() as! NSAttributedString
            container_ = container_?.copy() as! SwiftyTextContainer?
        }
        
        // task
        let task = SwiftyTextAsyncLayerDisplayTask()
        
        
        task.willDisplay = { [weak self] (layer) in
            guard let self = self else { return }
            
            layer?.removeAnimation(forKey: "contents")
            
            for view in self.attachmentViews {
                if layoutNeedUpdate_ || !(layout_?.attachmentSet.contains(view) ?? false) {
                    if view.superview == self {
                        view.removeFromSuperview()
                    }
                }
            }
            for layer: CALayer in self.attachmentLayers {
                if layoutNeedUpdate_ || !(layout_?.attachmentSet.contains(layer) ?? false) {
                    if layer.superlayer == self.layer {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            self.attachmentViews.removeAll()
            self.attachmentLayers.removeAll()
        }
        
        task.display = { (context, size, isCancelled) in
            
            if isCancelled() {
                return
            }
            
            guard text_.length > 0 else {
                return
            }
            
            var drawLayout: SwiftyTextLayout? = layout_
            if layoutNeedUpdate_ {
                layout_ = SwiftyTextLayout.layout(container: container_, attributedText: text_) // 在这儿设置了`layout`
                shrinkLayout_ = SwiftyLabel.getShrinkLayout(layout: layout_)
                if isCancelled() {
                    return
                }
                layoutUpdated_ = true
                drawLayout = (shrinkLayout_ != nil) ? shrinkLayout_ : layout_
            }
            
            let boundingSize: CGSize = drawLayout?.textSize ?? .zero
            var point = CGPoint.zero
            if verticalAlignment_ == .center {
                point.y = (size.height - boundingSize.height) * 0.5
            } else if verticalAlignment_ == .bottom {
                point.y = size.height - boundingSize.height
            }
            
            SwiftyTextLayout.draw(layout: drawLayout, context: context, size: size, point: point, view: nil, layer: nil, cancel: isCancelled)
        }
        
        task.didDisplay = { [weak self] (layer, finished) in
            guard let self = self else { return }
            
            var drawLayout = layout_
            if layoutUpdated_ && (shrinkLayout_ != nil) {
                drawLayout = shrinkLayout_
            }
            if !finished {
                // If the display task is cancelled, we should clear the attachments.
                for attachment in drawLayout?.attachments ?? [] {
                    if (attachment.content is UIView) {
                        if (attachment.content as? UIView)?.superview === layer.delegate {
                            (attachment.content as? UIView)?.removeFromSuperview()
                        }
                    } else if (attachment.content is CALayer) {
                        if (attachment.content as? CALayer)?.superlayer == layer {
                            (attachment.content as? CALayer)?.removeFromSuperlayer()
                        }
                    }
                }
                return
            }
            layer.removeAnimation(forKey: "contents")
            
            
            guard let label = layer.delegate as? SwiftyLabel else {
                return
            }
            
            if label.state.layoutNeedUpdate && layoutUpdated_ {
                label.innerLayout = layout_
                label.shrinkInnerLayout = shrinkLayout_
                label.state.layoutNeedUpdate = false
            }
            
            
            
            let size = layer.bounds.size
            let boundingSize: CGSize = drawLayout?.textSize ?? .zero
            var point = CGPoint.zero
            if verticalAlignment_ == .center {
                point.y = (size.height - boundingSize.height) * 0.5
            } else if verticalAlignment_ == .bottom {
                point.y = size.height - boundingSize.height
            }
            SwiftyTextLayout.draw(layout: drawLayout, context: nil, size: size, point: point, view: label, layer: layer, cancel: nil)
            
            
            for attachment in drawLayout?.attachments ?? [] {
                if (attachment.content is UIView) {
                    self.attachmentViews.append(attachment.content as! UIView)
                } else if (attachment.content is CALayer) {
                    self.attachmentLayers.append(attachment.content as! CALayer)
                }
            }
            
            if contentsNeedFade_ {
                let transition = CATransition()
                transition.duration = kHighlightFadeDuration
                transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
                transition.type = .fade
                layer.add(transition, forKey: "contents")
            } else if fadeForAsync_ {
                let transition = CATransition()
                transition.duration = kAsyncFadeDuration
                transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
                transition.type = .fade
                layer.add(transition, forKey: "contents")
            }
        }
        
        return task
    }
}
