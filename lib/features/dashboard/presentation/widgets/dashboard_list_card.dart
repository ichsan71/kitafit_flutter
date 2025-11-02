import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/features/dashboard/presentation/widgets/dashboard_card_section.dart';
import 'package:todo_clean_bloc/core/common/entities/card.dart';

class DashboardListCard extends StatelessWidget {
  final List<CardData> cards;
  final String? title;
  final EdgeInsets? padding;

  const DashboardListCard({
    super.key,
    required this.cards,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: card.onTap,
                  child: InfoCard(
                    image: card.image,
                    color: card.color,
                    width: 350,
                    height: 140,
                    borderRadius: 12,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
