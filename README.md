<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This is a multi axis scrollable data table, that allows you to scroll on both the vertical and horizontal axis, with the header remaining static on the vertical axis. Please look at the demo below.

## Features
### Demo
![](https://github.com/herbertamukhuma/scrollable_table_view/blob/fd47a2acb0ce7d11c848035394650e7e465210df/assets/gifs/scrollable-table-view.gif)

This widget serves the same purpose as a DataTable, with the advantage that it can scroll in both the horizontal and vertical axis, while maintaining the vertical position of the header.

### Note
For more complex features like freezing columns and rows, kindly take a look at the [data_table_2](https://pub.dev/packages/data_table_2) package

## Getting started

Simply add into your dependencies the following line.

```dart
dependencies:
  scrollable_table_view: <latest-version>
```

## Usage

```dart
ScrollableTableView(
  headers: [
    "product_id",
    "product_name",
    "price",
  ].map((label) {
    return TableViewHeader(
      label: label,
    );
  }).toList(),
  rows: [
    ["PR1000", "Milk", "20.00"],
    ["PR1001", "Soap", "10.00"],
  ].map((record) {
    return TableViewRow(
      height: 60,
      cells: record.map((value) {
        return TableViewCell(
          child: Text(value),
        );
      }).toList(),
    );
  }).toList(),
);
```
### Pagination
Pagination is supported from version 1.0.0-beta. First, initialize a `PaginationController` as follows:

```dart
final PaginationController paginationController = PaginationController(
    rowCount: many_products.length,
    rowsPerPage: 10,
  );
```

Next, initialize your table and pass the pagination controller to the `paginationController` parameter:

```dart
ScrollableTableView(
  paginationController: paginationController,
  headers: labels.map((label) {
    return TableViewHeader(
      label: label,
    );
  }).toList(),
  rows: many_products.map((product) {
    return TableViewRow(
      height: 60,
      cells: labels.map((label) {
        return TableViewCell(
          child: Text(product[label] ?? ""),
        );
      }).toList(),
    );
  }).toList(),
)
```

With the above setup, navigate forward and backwards using `paginationController.next()` and `paginationController.backwards()` respectively. To jump to a page directly, use `paginationController.jumpTo(pageToJumpTo)`.

For the full example, go to the main.dart file in the example project.

## Additional information

GitHub Repo: https://github.com/herbertamukhuma/scrollable_table_view
Raise Issues and Feature requests: https://github.com/herbertamukhuma/scrollable_table_view/issues

## Common Issues
1. **Loading too many records**: From version 1.0.0-beta, pagination has been implemented. Kindly use this to avoid loading too many records at a time, which will inturn overwhelm your app.