import 'package:flutter/material.dart';

class FormRow extends StatelessWidget {
  FormRow({required this.title, this.subtitle, this.trailing, this.onTap});

  final Widget title;

  final Widget? subtitle;

  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(14, 10, 8, 10),
          constraints: BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17),
                      child: title,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15),
                          child: subtitle!,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
                  child: IconTheme(
                    data: IconThemeData(color: Theme.of(context).disabledColor, size: 22),
                    child: trailing!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  FormSection({required this.children, this.header, this.footer});

  final List<Widget> children;

  final Widget? header;

  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          if (header != null)
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.fromLTRB(16, 0, 10, 4),
              constraints: BoxConstraints(minHeight: 36),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 13),
                child: header!,
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Theme.of(context).dividerColor),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: List.generate(
                children.isEmpty ? 0 : children.length * 2 - 1,
                (i) => i.isOdd ? Divider(height: 1, thickness: 1) : children[i ~/ 2],
              ),
            ),
          ),
          if (footer != null)
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(16, 4, 10, 0),
              constraints: BoxConstraints(minHeight: 36),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 13),
                child: footer!,
              ),
            ),
        ],
      ),
    );
  }
}
