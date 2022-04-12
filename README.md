---
titile : 博客工作台程序
---

## 效果

![image1](http://m.qpic.cn/psc?/V540XOF325oHr63JD0zd026feh0HpMm8/TmEUgtj9EK6.7V8ajmQrEHGuZ13tojkCya7KgOonS9FmdWcsLaTzilapxhay0QOOA2yTotDZ7M7J3JHvqRd4.XGtLSlP6XrAxhhdnRtN4dg!/b&bo=8wY4BAAAAAADZ4s!&rf=viewer_4)
![image2](http://m.qpic.cn/psc?/V540XOF325oHr63JD0zd026feh0HpMm8/TmEUgtj9EK6.7V8ajmQrEJHZqjBxS*HejQBN*vf4UMmzQaBU7tbGMUmm4RtzVP2h8U.COh6KO22RH6V25dohbxKD5vCpwILUxS7fVx3EYek!/b&bo=7QY4BAAAAAADZ5U!&rf=viewer_4)

![image3](http://m.qpic.cn/psc?/V540XOF325oHr63JD0zd026feh0HpMm8/TmEUgtj9EK6.7V8ajmQrEP3*RmHR4s.c1Pvn2OyBqQ*ynIntINsJYkDSUaQIc9gqtnvfYc2jYnzKIhxphTyjP1qZ8qo7JVMGCnpFh5QEUDU!/b&bo=8wY4BAAAAAADd5s!&rf=viewer_4)

最近学习flutter，想尝试怎么样才能写好flutter，特别的flutter在桌面端的发展，我想是时候试试flutter了，因为自己经常写博客，并且用Hexo的方式发布到github上，所以就有了想尝试写一个软件来实现的想法。

## markdown支持

首先想到的一点就是要支持markdow，这点很重要，怎么来实现呢？首先我参考了一下国内博客写作的一些平台，发现采用markdown比较常见，所以感觉markdown来写博客比较有效

## 如何设计

参考了掘金的写作页面，我将写作和markdown展示区分在两个屏幕中，顶部实现markdown的快捷键按钮，这样一个初级的展示页面就显示出来了。

## 如何实现

首先我创建的了工程，然后添加了一些常用的插件，首先是要实现一个输入框和一个按钮组合来快捷生成markdown标记，我首先想到的就是先处理一个页面出来，然后再根据页面去布局，说干就干，我很顺利的绘制了一组按钮，但是当我想实现按钮对应文本框功能变化的时候，让我头疼的问题来了，如何去动态的 给输入框插入markdown的标记呢？最后我还是采用pub的搜索，找到了一个开源的插件markdown_text_input，这个插件是有问题的，当你从后面往前选择文本时候，插件中判断选择的起点位置和终点位置就会出问题，因为起点位置大于终点位置，再进行插入文本时候就会出现越界的情况，我修改了源码，之后采用了修改后的源码。并且调整了一些UI。

## 实现博客查看

能写博客了，当然也要能查看博客啊，所以我写了一个博客查看的页面，左侧是列表，右侧是显示博客，这就很完美了。

## 存在的问题

这个博客工作台最大的问题就是文本输入框了，这个输入框存在非常大的问题，我不知道是不是flutter的问题，当我在输入中文，拼音还没输入完成的时候，我点击删除键删除拼音的时候实际上是没有生效的，这非常的不利于输入，对于一个博客这样的文本输入的软件来讲，这是致命的，我不清楚有没有更好的办法，希望有人也能给点建议吧。还有就是输入联想，按左右键选择后面的文本也是不行的。我不知道是不是对mac的键盘支持不好，还是对所有键盘都不行。总之从开始设计到完成，总共3天的时间，应该来说flutter开发效率是挺快的，但是我查询了下桌面快捷键也是不能实现，必须要原生实现。还是会存在一些问题的，但是如果不是一个功能性应用，我觉得fultter是一个不错的选择
