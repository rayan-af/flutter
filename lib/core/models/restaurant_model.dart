class RestaurantModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final String distance;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.distance,
  });

  static List<RestaurantModel> get mockNearby => [
    const RestaurantModel(
      id: '1',
      name: 'Eatwell',
      imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=800&auto=format&fit=crop', // Placeholder
      rating: 5.0,
      reviewCount: 3800,
      category: 'Fine dining',
      distance: '500m',
    ),
    const RestaurantModel(
      id: '2',
      name: 'Al-Jazeera',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=800&auto=format&fit=crop', // Placeholder
      rating: 4.8,
      reviewCount: 3800,
      category: 'Buffet',
      distance: '1.2km',
    ),
    const RestaurantModel(
      id: '3',
      name: 'Sushi Master',
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800&auto=format&fit=crop', // Placeholder
      rating: 4.9,
      reviewCount: 1200,
      category: 'Casual',
      distance: '2.5km',
    ),
  ];

    static List<RestaurantModel> get mockNewLocations => [
    const RestaurantModel(
      id: '4',
      name: 'Le Mair',
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800&auto=format&fit=crop', // Placeholder
      rating: 4.5,
      reviewCount: 500,
      category: 'Cafe',
      distance: '800m',
    ),
    const RestaurantModel(
      id: '5',
      name: 'Tegal Spot',
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=800&auto=format&fit=crop', // Placeholder
      rating: 4.7,
      reviewCount: 230,
      category: 'Fast food',
      distance: '3.0km',
    ),
  ];
}
