import 'package:flutter/material.dart';

class TagFlowWidget extends StatefulWidget {
  const TagFlowWidget({
    Key? key,
    required this.items,
    required this.foldedRowsNum,
    required this.itemHeight,
    this.onTap,
    this.borderRadius,
    this.horizontalPadding,
    this.spaceHorizontal = 0,
    this.spaceVertical = 0,
    this.itemBgColor,
    this.itemStyle,
  }) : super(key: key);
  /// 用于在组件中显示的字符串列表
  final List<String> items;
  /// 超多少行折叠
  final int foldedRowsNum;
  /// 项目之间的水平间距
  final double spaceHorizontal;
  /// 项目之间的垂直间距
  final double spaceVertical;
  /// 每个项目的高度
  final double itemHeight;
  /// 点击事件，可选
  final ValueChanged? onTap;
  /// 项目的背景颜色，可选
  final Color? itemBgColor;
  /// 项目的圆角半径，可选
  final BorderRadiusGeometry? borderRadius;
  /// 组件内部的水平内边距，可选
  final double? horizontalPadding;
  /// 项目的文本样式，可选
  final TextStyle? itemStyle;
  @override
  TagFlowWidgetState createState() => TagFlowWidgetState();
}
class TagFlowWidgetState extends State<TagFlowWidget> {
  int expandedRowsNum = 0;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxLayoutWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flow(
              delegate: TagFlowDelegate(
                foldedRowsNum: widget.foldedRowsNum,
                isExpanded: isExpanded,
                layoutWidth: maxLayoutWidth,
                itemHeight: widget.itemHeight,
                spaceHorizontal: widget.spaceHorizontal,
                spaceVertical: widget.spaceVertical,
                itemCount: widget.items.length,
                expandedRowsNum:expandedRowsNum,
                onLayoutChanged: (i) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                    expandedRowsNum = i;
                  })); 
                },
              ),
              children: [
                ...widget.items.map((item) {
                  return GestureDetector(
                    onTap: () => widget.onTap?.call(item),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPadding ?? 0,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: (maxLayoutWidth / 2 ) - (widget.spaceHorizontal / 2),
                        ),
                        height: widget.itemHeight,
                        decoration: BoxDecoration(
                          color: widget.itemBgColor,
                          borderRadius: widget.borderRadius,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: widget.itemStyle,
                            ),
                          ],
                        )),
                  );
                }).toList(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding ?? 0,
                    ),
                    height: widget.itemHeight,
                    decoration: BoxDecoration(
                      color: widget.itemBgColor,
                      borderRadius: widget.borderRadius,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF999999),
                    ),
                  )
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class TagFlowDelegate extends FlowDelegate{
  TagFlowDelegate({
    required this.layoutWidth,
    required this.itemCount,
    required this.spaceHorizontal,
    required this.spaceVertical,
    required this.foldedRowsNum,
    required this.isExpanded,
    required this.itemHeight,
    required this.onLayoutChanged,
    required this.expandedRowsNum,
  });
  /// 当前容器的宽度
  final double layoutWidth;
  /// 项之间的水平间距
  final double spaceHorizontal;
  /// 项之间的垂直间距
  final double spaceVertical;
  /// 是否展开
  final bool isExpanded;
  /// 每一项的高度
  final double itemHeight;
  /// 项目的数量
  final int itemCount;
  /// 重新绘制页面回调
  final ValueChanged onLayoutChanged;
  /// 超多少行折叠
  final int foldedRowsNum;
  /// 动态回调当前展开最大行数
  final int expandedRowsNum;
  /// 展开按钮的宽度
  late double _expandedBtnWidth;
  @override
  void paintChildren(FlowPaintingContext context) {
    int currentRow = 1;
    _expandedBtnWidth = context.getChildSize(itemCount)!.width;
    double offsetX = 0, offsetY = 0;
    Size childSize;
    for (int i = 0; i < itemCount; i++) {
      childSize = context.getChildSize(i)!;
      // 检查是否需要显示折叠按钮
      if (_shouldDrawFoldButton(currentRow, offsetX, childSize.width, _expandedBtnWidth)) {
        context.paintChild(itemCount, transform: Matrix4.translationValues(offsetX, offsetY, 0));
        currentRow ++;
        break;
      }
      // 判断当前行宽度是否已满，满了则换行
      if(offsetX + childSize.width > layoutWidth){
        currentRow ++;
        offsetX = 0;
        offsetY += itemHeight + spaceHorizontal;
      }
      context.paintChild(i, transform: Matrix4.translationValues(offsetX, offsetY, 0));
      offsetX += childSize.width + spaceVertical;
    }
    // 如果是展开状态，并且有内容需要展开，则绘制展开的按钮在最后
    if(isExpanded && expandedRowsNum > foldedRowsNum) {
      // 如果当前行宽度已满，则换行
      if(offsetX + _expandedBtnWidth > layoutWidth){
        currentRow ++;
        offsetX = 0;
        offsetY += itemHeight + spaceHorizontal;
      }
      context.paintChild(itemCount, transform: Matrix4.translationValues(offsetX, offsetY, 0));
    }
    /// 重新绘制页面，动态回调当前行数，以实现getSize的动态自适应子组件大小。
    onLayoutChanged.call(currentRow);
  }
  /// 折叠状态下，是否可以绘制折叠按钮
  bool _shouldDrawFoldButton(int currentRow, double offsetX, double childWidth, double buttonWidth) {
    //行数到了最大显示的行数，且还有没显示完的内容，且当前要绘制的内容的宽度放不下了，则将按钮绘制到当前行的最后
    return currentRow == foldedRowsNum &&
        expandedRowsNum > foldedRowsNum &&
        offsetX + childWidth + spaceVertical + buttonWidth > layoutWidth &&
        !isExpanded;
  }
  @override
  Size getSize(BoxConstraints constraints) {
    int currentRows = expandedRowsNum;
    //如果是折叠的状态，并且有内容需要折叠
    if(!isExpanded && expandedRowsNum > foldedRowsNum){
      currentRows = foldedRowsNum;
    }
    final height = (itemHeight * currentRows) + (spaceVertical * (currentRows - 1));
    return Size(constraints.maxWidth, height);
  }

  @override
  bool shouldRelayout(covariant TagFlowDelegate oldDelegate) {
    return expandedRowsNum != oldDelegate.expandedRowsNum || isExpanded != oldDelegate.isExpanded;
  }
  @override
  bool shouldRepaint(covariant TagFlowDelegate oldDelegate) {
    return expandedRowsNum != oldDelegate.expandedRowsNum || isExpanded != oldDelegate.isExpanded;
  }
}