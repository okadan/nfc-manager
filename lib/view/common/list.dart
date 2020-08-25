import 'package:flutter/material.dart';

class ListCell extends StatelessWidget {
  const ListCell({
    @required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 10, trailing is Icon ? 4 : 10, 10),
        constraints: BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                    child: title,
                  ),

                  if (subtitle != null)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
                        child: subtitle,
                      ),
                    ),
                ],
              ),
            ),

            if (trailing != null)
              Container(
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15),
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
    @required this.title,
    @required this.onTap,
    this.trailing,
    this.subtitle,
  });

  final Widget title;
  final Widget trailing;
  final Widget subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = onTap == null
      ? Theme.of(context).disabledColor
      : Theme.of(context).accentColor;
    return ListCell(
      title: DefaultTextStyle(style: TextStyle(color: textColor, fontSize: 16), child: title),
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({ this.label });

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      constraints: BoxConstraints(minHeight: 24),
      padding: EdgeInsets.only(left: 14, right: 14, bottom: 2),
      child: label == null ? null : DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: Theme.of(context).disabledColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        child: label,
      ),
    );
  }
}

class ListFooter extends StatelessWidget {
  const ListFooter({ this.label });

  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      constraints: BoxConstraints(minHeight: 24),
      padding: EdgeInsets.only(left: 14, right: 14, top: 2),
      child: label == null ? null : DefaultTextStyle(
        style: TextStyle(fontSize: 13, color: Theme.of(context).disabledColor),
        child: label,
      ),
    );
  }
}

class ListCellGroup extends StatelessWidget {
  const ListCellGroup({ @required this.children });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final length = children.isEmpty ? 0 : children.length * 2 - 1;
    return Card(
      margin: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(length, (i) => i.isEven ? children[i ~/ 2] : Divider(height: 1)),
      ),
    );
  }
}
