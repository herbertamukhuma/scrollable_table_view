import 'dart:math';

import 'package:flutter/material.dart';

import 'utils.dart';

class ScrollableTableView extends StatefulWidget {
  const ScrollableTableView({
    Key? key,
    required this.rows,
    required this.columns,
    this.headerHeight = 40,
    this.rowDividerHeight = 1.0,
  }) : super(key: key);

  final List<TableViewColumn> columns;
  final List<TableViewRow> rows;
  final double headerHeight;
  final double rowDividerHeight;

  double get contentHeight {
    var height = 0.0;

    for (var row in rows) {
      height += row.height + rowDividerHeight;
    }

    return height;
  }

  double get contentWidth {
    var width = 0.0;

    for (var column in columns) {
      width += column.getWidth();
    }

    return width;
  }

  @override
  State<ScrollableTableView> createState() => _ScrollableTableViewState();
}

class _ScrollableTableViewState extends State<ScrollableTableView> {
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController1 = ScrollController();
  final _verticalScrollController2 = ScrollController();

  final double _horizontalScrollViewPadding = 10;

  void _updateVerticalPosition1() {
    setState(() {
      _verticalScrollController1.jumpTo(_verticalScrollController2.position.pixels);
    });
  }

  void _updateVerticalPosition2() {
    setState(() {
      _verticalScrollController2.jumpTo(_verticalScrollController1.position.pixels);
    });
  }

  @override
  void initState() {
    _verticalScrollController1.addListener(_updateVerticalPosition2);
    _verticalScrollController2.addListener(_updateVerticalPosition1);
    super.initState();
  }

  @override
  void dispose() {
    _verticalScrollController1.removeListener(_updateVerticalPosition2);
    _verticalScrollController2.removeListener(_updateVerticalPosition1);

    _horizontalScrollController.dispose();
    _verticalScrollController1.dispose();
    _verticalScrollController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: _horizontalScrollViewPadding),
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: widget.headerHeight,
                              child: Row(
                                children: widget.columns,
                              ),
                            ),
                            Container(
                              height: widget.rowDividerHeight,
                              width: widget.contentWidth,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              controller: _verticalScrollController1,
                              child: Column(
                                children: widget.rows,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
                height: double.infinity,

                /// Padding will allow for [_verticalScrollController1] and [_verticalScrollController2]
                /// to have the same maxScrollExtent. This ensures that a user can scroll to the end of
                /// the vertical [SingleChildScrollView]. We achieve this by ensuring that the [ScrollBar]
                /// thumb of [_verticalScrollController2] below starts around the same vertical space as
                /// the vertical [SingleChildScrollView].
                ///
                /// The padding is hence achieved by adding the table header height, the vertical padding
                /// of the horizontal [SingleChildScrollView] and the row divider height within the header.
                padding: EdgeInsets.only(
                  top: widget.headerHeight + (_horizontalScrollViewPadding * 2) + widget.rowDividerHeight,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Scrollbar(
                    controller: _verticalScrollController2,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController2,
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: 10,
                        height: widget.contentHeight,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class TableViewColumn extends StatelessWidget {
  const TableViewColumn({
    Key? key,
    this.width,
    this.height,
    required this.label,
    this.spacing = 0,
    this.labelFontSize = 14,
    this.minWidth = 80,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double spacing;
  final String label;
  final double labelFontSize;
  final double minWidth;

  double getWidth() {
    return width ?? max((0.7 * labelFontSize) * label.length, minWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(),
      height: height,
      margin: EdgeInsets.symmetric(horizontal: spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class TableViewRow extends StatelessWidget {
  const TableViewRow({
    Key? key,
    required this.cells,
    this.height = 40,
  }) : super(key: key);

  final List<TableViewCell> cells;
  final double height;

  @override
  Widget build(BuildContext context) {
    var tableView = context.findAncestorWidgetOfExactType<ScrollableTableView>();
    assert(tableView != null);
    var columns = tableView!.columns;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Row(
            children: Utils.map(cells, (index, cell) {
              /// [SizedBox] below acts as a parent to each of the cells.
              /// Its width ensures that all cells in a column have the
              /// same width as the respective [TableViewColumn]
              return SizedBox(
                width: columns[index].getWidth(),
                child: cell,
              );
            }),
          ),
        ),
        Container(
          height: tableView.rowDividerHeight,
          width: tableView.contentWidth,
          color: Colors.black12,
        ),
      ],
    );
  }
}

class TableViewCell extends StatelessWidget {
  const TableViewCell({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: child,
      ),
    );
  }
}
