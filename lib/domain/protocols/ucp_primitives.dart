import 'package:flutter/foundation.dart';

/// Universal Commerce Protocol (UCP)
/// A hypothetical 2026 standard for agentic commerce discoverability.

@immutable
class UCPCatalogItem {
  final String ucpId; // Unique global catalog assigned identifier
  final String title;
  final String description;
  final double basePriceFiat;
  final List<String> tags;

  const UCPCatalogItem({
    required this.ucpId,
    required this.title,
    required this.description,
    required this.basePriceFiat,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
    'ucp_id': ucpId,
    'title': title,
    'description': description,
    'price_fiat': basePriceFiat,
    'tags': tags,
  };
}
