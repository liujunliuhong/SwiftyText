# SwiftyText
基于`CoreText`，用`Swift`实现的轻量级自定义Label，在`YYText`的基础上，解决了许多`issues`中未解决的问题。

# Demo以及细节部分正在完善中，稳定之后将支持pod
# Demo以及细节部分正在完善中，稳定之后将支持pod
# Demo以及细节部分正在完善中，稳定之后将支持pod

# 背景
在开发中，使用到富文本在所难免，大家用的最多的可能就是`YYText`了，但是`YYtext`已经有3年没更新了，而iOS系统却一直在更新，一个再好的三方库，如果不一直维护，也会随着系统的不断升级出现各种bug。在我使用`YYText`的过程中，就出现了各种问题，比如高度计算不准确、文本垂直居中有问题等等。也正是因为这些原因，促使我写了这个库，同时仔细阅读`YYText`源码，并翻阅其他各种富文本三方库，写一个属于自己的富文本框架

在编写该框架过程中，借鉴了许多三方库:
- [YYtext](https://github.com/ibireme/YYText)(主要)
- [BSText](https://github.com/a1049145827/BSText)(Swift版本的YYText)
- [TYAttributedLabel](https://github.com/12207480/TYAttributedLabel)
- [TYText](https://github.com/12207480/TYText)
- [DTCoreText](https://github.com/Cocoanetics/DTCoreText)
- [M80AttributedLabel](https://github.com/xiangwangfeng/M80AttributedLabel)

# 针对`YYText`中目前未被Close的问题，本人接下来会一一进行解答
- [YYTextAsyncLayer类中对contentsScale的设置是有问题的...](https://github.com/ibireme/YYText/issues/920)

该问题，本人对源码进行了仔细阅读，发现在`YYTextAsyncLayer`和`YYLabel`中中，都同时设置了`contentsScale`，因此不会出现该问题

- [使用特殊文本时，YYLabel会有一长串的空格](https://github.com/ibireme/YYText/issues/915)

待解决

- [可以进行iOS13黑暗模式适配吗](https://github.com/ibireme/YYText/issues/911)

之后的更新会加上，前期该功能先暂时忽略

- [文字带下划线，可以调整下划线与文字的间距吗？](https://github.com/ibireme/YYText/issues/908)

待解决

- [YYLabel设置NSLineBreakByTruncatingHead、NSLineBreakByTruncatingMiddle、YYTextTruncationTypeStart、YYTextTruncationTypeMiddle和UILabel显示效果不一样](https://github.com/ibireme/YYText/issues/907)

已解决。在`CTLineTruncationType`为`start`和`middle`的情况下，需要单独设置下`lastLineAttributedText`。
原问题有人已经给出了解决办法，但是有限制，本人进行了优化。

- [YYTextAsyncLayer非主线程刷新](https://github.com/ibireme/YYText/issues/904)

该问题本人猜测是由于`displaysAsynchronously`设置为`true`，但是却在非主线程操作UI导致的，本人在`displaysAsynchronously`为`true`时，加入了
```
dispatch_async(dispatch_get_main_queue(), ^{

});
```

- [YYLabel 动画过程中不响应 highlightTapAction](https://github.com/ibireme/YYText/issues/901)

待解决

- [YYTextLayout计算的高度不准确](https://github.com/ibireme/YYText/issues/900)

待解决
