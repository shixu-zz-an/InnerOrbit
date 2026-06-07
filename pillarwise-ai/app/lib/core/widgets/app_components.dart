import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.page),
    this.bottomActionBar,
    this.resizeToAvoidBottomInset = true,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Widget? bottomActionBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: AppColors.background,
      navigationBar: !hasTitle
          ? null
          : AppNavigationBar(title: title!, trailing: trailing),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          bottom: bottomActionBar == null,
          child: Column(
            children: [
              Expanded(
                child: Padding(padding: padding, child: child),
              ),
              ?bottomActionBar,
            ],
          ),
        ),
      ),
    );
  }
}

class AppNavigationBar extends CupertinoNavigationBar {
  // CupertinoNavigationBar requires the title Text to be created from runtime
  // copy, so this constructor cannot be const.
  // ignore: prefer_const_constructors_in_immutables
  AppNavigationBar({super.key, required String title, super.trailing})
    : super(
        middle: Text(title),
        backgroundColor: const Color(0xF2F5F6F8),
        border: const Border(bottom: BorderSide(color: AppColors.lightDivider)),
      );
}

class AppTabBar extends CupertinoTabBar {
  const AppTabBar({
    super.key,
    required super.items,
    super.currentIndex,
    super.onTap,
  }) : super(
         activeColor: AppColors.primary,
         inactiveColor: AppColors.inkFaint,
         backgroundColor: AppColors.surfaceElevated,
         border: const Border(top: BorderSide(color: AppColors.lightDivider)),
       );
}

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null && eyebrow!.trim().isNotEmpty) ...[
                  Text(
                    eyebrow!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(title, style: AppTextStyles.title1),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTextStyles.callout.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.tone = AppTone.neutral,
    this.selected = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final AppTone tone;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: selected ? colors.accent : colors.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: card,
    );
  }
}

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) AppSectionHeader(text: title!, trailing: trailing),
          child,
        ],
      ),
    );
  }
}

class AppInsightCard extends StatelessWidget {
  const AppInsightCard({
    super.key,
    this.label,
    required this.title,
    required this.body,
    this.locked = false,
    this.actionText,
    this.onAction,
    this.actionLoading = false,
    this.tone = AppTone.neutral,
    this.compact = false,
  });

  final String? label;
  final String title;
  final String body;
  final bool locked;
  final String? actionText;
  final VoidCallback? onAction;
  final bool actionLoading;
  final AppTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    return AppCard(
      tone: tone,
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null && label!.trim().isNotEmpty) ...[
            Text(
              label!,
              style: AppTextStyles.caption.copyWith(color: colors.accent),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: compact
                      ? AppTextStyles.headline
                      : AppTextStyles.title2,
                ),
              ),
              if (locked) ...[
                const SizedBox(width: AppSpacing.sm),
                const AppAvatar(
                  icon: CupertinoIcons.lock_fill,
                  tone: AppTone.warning,
                  size: 34,
                ),
              ],
            ],
          ),
          if (body.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: compact
                  ? AppTextStyles.footnote.copyWith(
                      color: AppColors.inkSecondary,
                    )
                  : AppTextStyles.callout,
            ),
          ],
          if (actionText != null && (onAction != null || actionLoading)) ...[
            const SizedBox(height: AppSpacing.md),
            CupertinoButton(
              minimumSize: const Size(44, 44),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              onPressed: actionLoading ? null : onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionLoading) ...[
                    const CupertinoActivityIndicator(radius: 9),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Flexible(
                    child: Opacity(
                      opacity: actionLoading ? 0.58 : 1,
                      child: Text(
                        actionText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headline.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (!actionLoading) ...[
                    const SizedBox(width: AppSpacing.xxs),
                    const Icon(
                      CupertinoIcons.chevron_right,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final colors = variant.colors;
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
              color: colors.background,
              borderRadius: BorderRadius.circular(AppRadius.control),
              border: colors.border == null
                  ? null
                  : Border.all(color: colors.border!),
            ),
            child: loading
                ? CupertinoActivityIndicator(color: colors.foreground)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 19, color: colors.foreground),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headline.copyWith(
                            color: colors.foreground,
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

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.destructive = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final color = destructive ? AppColors.destructive : AppColors.primary;
    return Semantics(
      button: true,
      label: label,
      enabled: enabled,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(44, 44),
        onPressed: enabled
            ? () {
                HapticFeedback.selectionClick();
                onPressed?.call();
              }
            : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          opacity: enabled ? 1 : 0.42,
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType,
    this.errorText,
  });

  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.trim().isNotEmpty) ...[
          Text(
            label!,
            style: AppTextStyles.subhead.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          minLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          style: AppTextStyles.body,
          placeholderStyle: AppTextStyles.body.copyWith(
            color: AppColors.inkFaint,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: errorText == null
                  ? AppColors.lightBorder
                  : AppColors.destructive,
            ),
          ),
        ),
        if (errorText != null && errorText!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTextStyles.footnote.copyWith(
              color: AppColors.destructive,
            ),
          ),
        ],
      ],
    );
  }
}

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.placeholder,
    this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      placeholder: placeholder,
      onChanged: onChanged,
      backgroundColor: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.control),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      style: AppTextStyles.body,
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({super.key, required this.text, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.inkMuted,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class AppInfoRow extends StatelessWidget {
  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.inkMuted),
          const SizedBox(width: AppSpacing.xs),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.footnote.copyWith(color: AppColors.inkMuted),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subhead.copyWith(color: AppColors.ink),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.showChevron,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;
  final bool? showChevron;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.lightDivider))
            : null,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: destructive ? AppColors.destructive : AppColors.ink,
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.footnote.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
          if (showChevron ?? (onTap != null && trailing == null)) ...[
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: AppColors.inkFaint,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return content;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: content,
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = CupertinoIcons.tray,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(icon: icon, tone: AppTone.secondary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.title2),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ?action,
          ],
        ],
      ),
    );
  }
}

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CupertinoActivityIndicator(radius: 14),
          const SizedBox(height: AppSpacing.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class AppLoadingState extends AppLoading {
  const AppLoadingState({super.key, required super.text});
}

class AppRetryButton extends StatelessWidget {
  const AppRetryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      icon: CupertinoIcons.arrow_clockwise,
      onPressed: onPressed,
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppAvatar(
              icon: CupertinoIcons.exclamationmark_triangle_fill,
              tone: AppTone.warning,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.title2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(text: actionText, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

class AppSuccessState extends StatelessWidget {
  const AppSuccessState({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: CupertinoIcons.checkmark_seal_fill,
      action: actionText == null || onAction == null
          ? null
          : AppButton(text: actionText!, onPressed: onAction),
    );
  }
}

class AppOfflineState extends StatelessWidget {
  const AppOfflineState({
    super.key,
    required this.onRetry,
    this.title = 'Connection unavailable',
    this.message = 'Check your network and try again.',
    this.retryText = 'Try again',
  });

  final VoidCallback onRetry;
  final String title;
  final String message;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      title: title,
      message: message,
      actionText: retryText,
      onAction: onRetry,
    );
  }
}

class AppPermissionState extends StatelessWidget {
  const AppPermissionState({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: CupertinoIcons.lock_shield,
      action: actionText == null || onAction == null
          ? null
          : AppButton(text: actionText!, onPressed: onAction),
    );
  }
}

class AppLockedState extends StatelessWidget {
  const AppLockedState({
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
    return AppEmptyState(
      title: title,
      message: message,
      icon: CupertinoIcons.lock_fill,
      action: AppButton(
        text: actionText,
        icon: CupertinoIcons.sparkles,
        onPressed: onAction,
      ),
    );
  }
}

class AppBottomActionBar extends StatelessWidget {
  const AppBottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          border: Border(top: BorderSide(color: AppColors.lightDivider)),
        ),
        child: child,
      ),
    );
  }
}

class AppStatusTag extends StatelessWidget {
  const AppStatusTag({
    super.key,
    required this.text,
    this.tone = AppTone.neutral,
  });

  final String text;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: colors.accent),
      ),
    );
  }
}

class AppProBadge extends StatelessWidget {
  const AppProBadge({super.key, this.text = 'Pro'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppStatusTag(text: text, tone: AppTone.warning);
  }
}

class AppFeatureLock extends StatelessWidget {
  const AppFeatureLock({
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
    return AppCard(
      tone: AppTone.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppProBadge(),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTextStyles.title3),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: AppTextStyles.callout.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: actionText,
            icon: CupertinoIcons.sparkles,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.tone = AppTone.neutral,
  });

  final String label;
  final String value;
  final IconData? icon;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      tone: tone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: colors.accent, size: 20),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headline,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.footnote.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class AppSettingItem extends AppListTile {
  const AppSettingItem({
    super.key,
    required super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.onTap,
    super.destructive,
    super.showChevron,
    super.showDivider,
  });
}

class AppComposer extends StatelessWidget {
  const AppComposer({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.canSend,
    required this.onChanged,
    required this.onSend,
    this.sending = false,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool canSend;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final bool sending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            textCapitalization: TextCapitalization.sentences,
            onChanged: onChanged,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 13,
            ),
            style: AppTextStyles.body,
            placeholderStyle: AppTextStyles.body.copyWith(
              color: AppColors.inkFaint,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppRadius.control),
              border: Border.all(color: AppColors.lightBorder),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(46, 46),
          onPressed: canSend && !sending
              ? () {
                  HapticFeedback.lightImpact();
                  onSend();
                }
              : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: canSend || sending ? 1 : 0.42,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: sending
                  ? const CupertinoActivityIndicator(
                      color: CupertinoColors.white,
                    )
                  : const Icon(
                      CupertinoIcons.arrow_up,
                      color: CupertinoColors.white,
                      size: 22,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppTag extends StatelessWidget {
  const AppTag({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
    this.icon,
    this.tone = AppTone.neutral,
  });

  final String text;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    final tag = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? colors.accent : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.control),
        border: Border.all(
          color: selected ? colors.accent : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: selected ? CupertinoColors.white : AppColors.inkMuted,
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subhead.copyWith(
                color: selected ? CupertinoColors.white : AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return tag;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: tag,
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.icon,
    this.tone = AppTone.primary,
    this.size = 36,
  });

  final IconData icon;
  final AppTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = tone.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Icon(icon, color: colors.accent, size: size * 0.52),
    );
  }
}

class AppMessageBubble extends StatelessWidget {
  const AppMessageBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          child: Text(
            text,
            style: AppTextStyles.callout.copyWith(color: CupertinoColors.white),
          ),
        ),
      ),
    );
  }
}

class AppPickerPanel extends StatelessWidget {
  const AppPickerPanel({super.key, required this.child, this.height = 220});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.lightDivider),
      ),
      child: child,
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.lightPressed,
            borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: constraints.maxWidth * value.clamp(0, 1),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 18,
            left: 18,
            child: _AppMarkTile(color: AppColors.primary),
          ),
          Positioned(
            top: 18,
            right: 18,
            child: _AppMarkTile(color: AppColors.secondary),
          ),
          Positioned(
            bottom: 18,
            left: 18,
            child: _AppMarkTile(color: AppColors.warning),
          ),
          Positioned(
            bottom: 18,
            right: 18,
            child: _AppMarkTile(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _AppMarkTile extends StatelessWidget {
  const _AppMarkTile({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary, destructive, ghost }

extension on AppButtonVariant {
  _ButtonColors get colors {
    return switch (this) {
      AppButtonVariant.primary => const _ButtonColors(
        background: AppColors.primary,
        foreground: CupertinoColors.white,
      ),
      AppButtonVariant.secondary => const _ButtonColors(
        background: AppColors.primarySoft,
        foreground: AppColors.primary,
      ),
      AppButtonVariant.destructive => const _ButtonColors(
        background: AppColors.destructive,
        foreground: CupertinoColors.white,
      ),
      AppButtonVariant.ghost => const _ButtonColors(
        background: AppColors.lightSurface,
        foreground: AppColors.primary,
        border: AppColors.lightBorder,
      ),
    };
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}

enum AppTone { neutral, primary, secondary, warning, destructive, success }

extension AppToneColors on AppTone {
  AppToneColorSet get colors {
    return switch (this) {
      AppTone.primary => const AppToneColorSet(
        AppColors.primary,
        AppColors.primarySoft,
        AppColors.primarySoft,
      ),
      AppTone.secondary => const AppToneColorSet(
        AppColors.secondary,
        AppColors.secondarySoft,
        AppColors.secondarySoft,
      ),
      AppTone.warning => const AppToneColorSet(
        AppColors.warning,
        AppColors.warningSoft,
        AppColors.warningSoft,
      ),
      AppTone.destructive => const AppToneColorSet(
        AppColors.destructive,
        AppColors.destructiveSoft,
        AppColors.destructiveSoft,
      ),
      AppTone.success => const AppToneColorSet(
        AppColors.success,
        AppColors.successSoft,
        AppColors.successSoft,
      ),
      AppTone.neutral => const AppToneColorSet(
        AppColors.inkMuted,
        AppColors.lightSurfaceSubtle,
        AppColors.lightBorder,
      ),
    };
  }
}

class AppToneColorSet {
  const AppToneColorSet(this.accent, this.soft, this.border);

  final Color accent;
  final Color soft;
  final Color border;
}
