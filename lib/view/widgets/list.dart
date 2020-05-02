import 'package:flutter/material.dart';

class ListCell extends StatelessWidget {
  const ListCell({
    Key key,
    @required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 17),
                    child: title,
                  ),

                  if (subtitle != null)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15),
                        child: subtitle,
                      ),
                    ),
                ],
              ),
            ),

            if (trailing != null)
              Container(
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
                  child: IconTheme(
                    data: IconThemeData(color: Theme.of(context).disabledColor, size: 20),
                    child: trailing,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ListCellButton extends StatelessWidget {
  const ListCellButton({
    Key key,
    @required this.title,
    @required this.onTap,
    this.trailing,
    this.subtitle,
  }) : super(key: key);

  final Widget title;
  final Widget trailing;
  final Widget subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor = onTap == null
      ? Theme.of(context).disabledColor
      : Theme.of(context).accentColor;
    return ListCell(
      title: DefaultTextStyle(style: TextStyle(color: textColor, fontSize: 17), child: title),
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class ListCellGroup extends StatelessWidget {
  const ListCellGroup({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    int length = children.isEmpty ? 0 : children.length * 2 - 1;
    return Card(
      margin: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(length, (i) => i.isEven ? children[i ~/ 2] : Divider(height: 1)),
      ),
    );
  }
}
