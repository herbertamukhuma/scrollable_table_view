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

## Getting started

Simply add into your dependencies the following line.

```dart
dependencies:
  scrollable_table_view: <latest-version>
```

## Usage

```dart
ScrollableTableView(
  columns: [
    "product_id",
    "product_name",
    "price",
  ].map((column) {
    return TableViewColumn(
      label: column,
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

## Additional information

GitHub Repo: https://github.com/herbertamukhuma/scrollable_table_view
Raise Issues and Feature requests: https://github.com/herbertamukhuma/scrollable_table_view/issues

## Common Issues
1. **Loading too many records**: As with any list of values/records, adding too many records to the underlying model will overwhelm you app. Remember that this table will load all the rows in your model, whether they are visible on the screen or not. This is unlike other widgets like the **ListView.builder** which only paints items when they are scrolled into view. In this regard, only load a few records at a time by implementing your own pagination. My recommendation would be **20 - 30** records in mobile apps, and up to **50** for web apps. You can do your own tests to see how many your app can handle without stuttering.