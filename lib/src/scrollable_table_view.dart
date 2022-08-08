import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_table_view/src/utils.dart';

class ScrollableTableView extends StatefulWidget {
  const ScrollableTableView({
    Key? key,
    required this.rows,
    required this.columns,
    this.headerHeight = 40,
    this.rowDividerHeight = 1.0,
  }) : super(key: key);

  /// Column widgets displayed in the table header.
  final List<TableViewColumn> columns;

  /// Row widgets displayed in the content area of the table.
  final List<TableViewRow> rows;

  /// The height of the table header.
  final double headerHeight;

  /// The height of the row divider
  final double rowDividerHeight;

  /// Combined height of the table rows plus their dividers
  ///
  /// We use this to enable effective vertical scrolling
  double get contentHeight {
    var height = 0.0;

    for (var row in rows) {
      height += row.height + rowDividerHeight;
    }

    return height;
  }

  /// Width of the tables content. Each row and the header will
  /// have this exact width.
  ///
  /// We use this to ensure the width of the row dividers matches
  /// that of the rows.
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
      _verticalScrollController1
          .jumpTo(_verticalScrollController2.position.pixels);
    });
  }

  void _updateVerticalPosition2() {
    setState(() {
      _verticalScrollController2
          .jumpTo(_verticalScrollController1.position.pixels);
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
                    padding: EdgeInsets.symmetric(
                        vertical: _horizontalScrollViewPadding),
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
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
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
                  top: widget.headerHeight +
                      (_horizontalScrollViewPadding * 2) +
                      widget.rowDividerHeight,
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
    this.labelFontSize = 14,
    this.minWidth = 80,
  }) : super(key: key);

  /// The width of the column.
  /// If the [width] is not provided, a width is calculated
  /// based on the contents of the column. If the calculated
  /// width is less than the [minWidth], then the [minWidth]
  /// is applied
  final double? width;

  /// Column height.
  ///
  /// Kindly note that the table header also has a height, which
  /// means that this height will not have a visual effect outside
  /// of the table header
  final double? height;

  /// A string to act as the label for the column
  final String label;

  /// Font size of the label
  final double labelFontSize;

  /// The minimum width of the column. This is applied if the provided
  /// or calculated width is less.
  final double minWidth;

  // Returns the effective width of the column
  double getWidth() {
    return width ?? max((0.7 * labelFontSize) * label.length, minWidth);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(),
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style:
                TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
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
    this.onTap,
  }) : super(key: key);

  /// Cells within the row.
  ///
  /// [cells.length] must be equal to the number of columns
  /// provided.
  final List<TableViewCell> cells;

  /// Row height
  final double height;

  /// Will be called any time a user taps a row
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var tableView =
        context.findAncestorWidgetOfExactType<ScrollableTableView>();
    assert(tableView != null);
    var columns = tableView!.columns;

    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}

class TableViewCell extends StatelessWidget {
  const TableViewCell({
    Key? key,
    this.child,
  }) : super(key: key);

  /// Child of the cell
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
