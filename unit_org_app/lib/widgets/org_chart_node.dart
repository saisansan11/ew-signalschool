import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../models/unit_models.dart';

/// Organization Chart Node Widget
class OrgChartNode extends StatelessWidget {
  final MilitaryUnit unit;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onExpand;

  const OrgChartNode({
    super.key,
    required this.unit,
    this.isExpanded = false,
    this.isSelected = false,
    this.onTap,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? unit.branch.color.withValues(alpha:0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected ? unit.branch.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: unit.branch.color.withValues(alpha:0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Unit symbol
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingS,
                vertical: AppSizes.paddingXS,
              ),
              decoration: BoxDecoration(
                color: unit.branch.color.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Text(
                unit.size.symbol,
                style: TextStyle(
                  fontSize: AppSizes.fontL,
                  fontWeight: FontWeight.bold,
                  color: unit.branch.color,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),

            // Unit icon
            Icon(
              unit.branch.icon,
              size: AppSizes.iconL,
              color: unit.branch.color,
            ),
            const SizedBox(height: AppSizes.paddingS),

            // Unit name
            Text(
              unit.nameThai,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Abbreviation
            Text(
              unit.abbreviation,
              style: AppTextStyles.labelSmall.copyWith(
                color: unit.branch.color,
              ),
            ),

            const SizedBox(height: AppSizes.paddingS),

            // Personnel count
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_outline,
                  size: AppSizes.iconS,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${unit.personnelMin}-${unit.personnelMax}',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),

            // Expand button if has children
            if (unit.childIds.isNotEmpty) ...[
              const SizedBox(height: AppSizes.paddingS),
              GestureDetector(
                onTap: onExpand,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: AppSizes.iconS,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact node for smaller displays
class OrgChartNodeCompact extends StatelessWidget {
  final MilitaryUnit unit;
  final bool isSelected;
  final VoidCallback? onTap;

  const OrgChartNodeCompact({
    super.key,
    required this.unit,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: isSelected
              ? unit.branch.color.withValues(alpha:0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
          border: Border.all(
            color: isSelected ? unit.branch.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Symbol
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: unit.branch.color.withValues(alpha:0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  unit.branch.icon,
                  size: AppSizes.iconS,
                  color: unit.branch.color,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unit.nameThai,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: AppSizes.fontS,
                  ),
                ),
                Text(
                  unit.abbreviation,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: unit.branch.color,
                    fontSize: AppSizes.fontXS,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
