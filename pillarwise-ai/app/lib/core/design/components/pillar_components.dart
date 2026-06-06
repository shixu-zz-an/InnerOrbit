import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../pillar_theme.dart';

class PillarButton extends StatelessWidget {
  const PillarButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.secondary = false,
    this.destructive = false,
    this.loading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool secondary;
  final bool destructive;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final background = destructive
        ? PillarColors.destructive
        : secondary
        ? PillarColors.accentSoft
        : PillarColors.accent;
    final foreground = secondary ? PillarColors.accent : CupertinoColors.white;
    return Semantics(
      button: true,
      enabled: enabled,
      label: text,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(52, 52),
        onPressed: enabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed?.call();
              }
            : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: enabled ? 1 : 0.42,
          child: Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(R.control),
            ),
            child: loading
                ? CupertinoActivityIndicator(color: foreground)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 19, color: foreground),
                        const SizedBox(width: S.xs),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PillarType.headline.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    this.label,
    required this.title,
    required this.body,
    this.locked = false,
    this.actionText,
    this.onAction,
    this.tone = PillarTone.neutral,
    this.compact = false,
  });

  final String? label;
  final String title;
  final String body;
  final bool locked;
  final String? actionText;
  final VoidCallback? onAction;
  final PillarTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? S.md : S.lg),
      decoration: BoxDecoration(
        color: PillarColors.surface,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: colors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null && label!.trim().isNotEmpty) ...[
            Text(
              label!,
              style: PillarType.caption.copyWith(color: colors.accent),
            ),
            const SizedBox(height: S.xs),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: compact ? PillarType.headline : PillarType.title2,
                ),
              ),
              if (locked) ...[
                const SizedBox(width: S.sm),
                _StatusGlyph(
                  icon: CupertinoIcons.lock_fill,
                  color: PillarColors.amber,
                  bg: PillarColors.amberSoft,
                ),
              ],
            ],
          ),
          if (body.trim().isNotEmpty) ...[
            const SizedBox(height: S.sm),
            Text(
              body,
              style: compact
                  ? PillarType.footnote.copyWith(
                      color: PillarColors.secondaryInk,
                    )
                  : PillarType.callout,
            ),
          ],
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: S.md),
            CupertinoButton(
              minimumSize: const Size(44, 44),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              onPressed: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      actionText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PillarType.headline.copyWith(
                        color: PillarColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: S.xxs),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 15,
                    color: PillarColors.accent,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PillarTextField extends StatelessWidget {
  const PillarTextField({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.maxLines = 1,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PillarType.subhead.copyWith(
            color: PillarColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: S.xs),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          minLines: maxLines,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          padding: const EdgeInsets.symmetric(horizontal: S.md, vertical: 14),
          style: PillarType.body,
          placeholderStyle: PillarType.body.copyWith(color: PillarColors.faint),
          decoration: BoxDecoration(
            color: PillarColors.surface,
            borderRadius: BorderRadius.circular(R.card),
            border: Border.all(color: PillarColors.hairline),
          ),
        ),
      ],
    );
  }
}

class PillarChip extends StatelessWidget {
  const PillarChip({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? PillarColors.ink : PillarColors.surface,
          borderRadius: BorderRadius.circular(R.control),
          border: Border.all(
            color: selected ? PillarColors.ink : PillarColors.hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? CupertinoColors.white : PillarColors.muted,
              ),
              const SizedBox(width: S.xxs),
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: PillarType.subhead.copyWith(
                  color: selected ? CupertinoColors.white : PillarColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PillarErrorView extends StatelessWidget {
  const PillarErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(S.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _StatusGlyph(
              icon: CupertinoIcons.exclamationmark_triangle_fill,
              color: PillarColors.warning,
              bg: PillarColors.amberSoft,
            ),
            const SizedBox(height: S.md),
            Text(title, textAlign: TextAlign.center, style: PillarType.title2),
            const SizedBox(height: S.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PillarType.callout.copyWith(color: PillarColors.muted),
            ),
            const SizedBox(height: S.lg),
            PillarButton(text: actionText, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

class PagePad extends StatelessWidget {
  const PagePad({super.key, required this.child, this.horizontal = S.lg});

  final Widget child;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: child,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: S.xs, bottom: S.xs),
      child: Text(
        text,
        style: PillarType.caption.copyWith(color: PillarColors.muted),
      ),
    );
  }
}

enum PillarTone { neutral, blue, teal, amber, rose }

extension on PillarTone {
  _ToneColors get colors {
    return switch (this) {
      PillarTone.blue => const _ToneColors(
        PillarColors.accent,
        PillarColors.accentSoft,
      ),
      PillarTone.teal => const _ToneColors(
        PillarColors.teal,
        PillarColors.tealSoft,
      ),
      PillarTone.amber => const _ToneColors(
        PillarColors.amber,
        PillarColors.amberSoft,
      ),
      PillarTone.rose => const _ToneColors(
        PillarColors.rose,
        PillarColors.roseSoft,
      ),
      PillarTone.neutral => const _ToneColors(
        PillarColors.muted,
        PillarColors.hairline,
      ),
    };
  }
}

class _ToneColors {
  const _ToneColors(this.accent, this.border);

  final Color accent;
  final Color border;
}

class _StatusGlyph extends StatelessWidget {
  const _StatusGlyph({
    required this.icon,
    required this.color,
    required this.bg,
  });

  final IconData icon;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(R.card),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
