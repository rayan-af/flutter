class DishModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewCount;
  final String category;
  final int calories;
  final String description;
  final List<String> ingredients;

  const DishModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.calories,
    required this.description,
    required this.ingredients,
  });

  static List<DishModel> get mockDishes => [
    // Entrees
    const DishModel(
      id: '1',
      name: 'Chicken Alfredo',
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=800&auto=format&fit=crop', // Generic Alfredo
      price: 26.49,
      rating: 4.8,
      reviewCount: 2500,
      category: 'Entrees',
      calories: 1570,
      description: 'Creamy homemade alfredo sauce tossed with fettuccine pasta and topped with grilled chicken.',
      ingredients: ['Fettuccine', 'Alfredo Sauce', 'Grilled Chicken', 'Parmesan'],
    ),
    const DishModel(
      id: '2',
      name: 'Chicken Parmigiana',
      imageUrl: 'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?q=80&w=800&auto=format&fit=crop', // Generic Parmigiana
      price: 20.29,
      rating: 4.7,
      reviewCount: 1800,
      category: 'Entrees',
      calories: 1020,
      description: 'Two lightly fried parmesan-breaded chicken breasts covered with homemade marinara and melted Italian cheeses. Served with a side of spaghetti.',
      ingredients: ['Chicken Breast', 'Marinara Sauce', 'Mozzarella', 'Spaghetti'],
    ),
    const DishModel(
      id: '3',
      name: 'Lasagna Classico',
      imageUrl: 'https://images.unsplash.com/photo-1574868233972-150e33819c96?q=80&w=800&auto=format&fit=crop', // Generic Lasagna
      price: 18.49,
      rating: 4.9,
      reviewCount: 3200,
      category: 'Entrees',
      calories: 940,
      description: 'Layers of pasta, parmesan, mozzarella, pecorino romano and our homemade meat sauce.',
      ingredients: ['Pasta Layers', 'Meat Sauce', 'Mozzarella', 'Ricotta', 'Parmesan'],
    ),
    const DishModel(
      id: '4',
      name: 'Shrimp Carbonara',
      imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?q=80&w=800&auto=format&fit=crop', // Generic Carbonara
      price: 23.49,
      rating: 4.6,
      reviewCount: 1200,
      category: 'Entrees',
      calories: 1200,
      description: 'Sautéed shrimp and spaghetti tossed in a creamy sauce with bacon and roasted red peppers.',
      ingredients: ['Shrimp', 'Spaghetti', 'Bacon', 'Roasted Red Peppers', 'Cream Sauce'],
    ),
    const DishModel(
      id: '5',
      name: 'Tour of Italy',
      imageUrl: 'https://images.unsplash.com/photo-1528612030006-2586551f33f3?q=80&w=800&auto=format&fit=crop', // Generic Italian Feast
      price: 22.49,
      rating: 4.9,
      reviewCount: 4500,
      category: 'Entrees',
      calories: 1550,
      description: 'Three OG classics all on one plate! Chicken Parmigiana, Lasagna Classico and our signature Fettuccine Alfredo.',
      ingredients: ['Chicken Parmigiana', 'Lasagna', 'Fettuccine Alfredo'],
    ),

    // Appetizers
    const DishModel(
      id: '6',
      name: 'Fried Mozzarella',
      imageUrl: 'https://images.unsplash.com/photo-1533728669866-9de831ac0f73?q=80&w=800&auto=format&fit=crop', // Generic Mozz sticks
      price: 8.99,
      rating: 4.5,
      reviewCount: 900,
      category: 'Appetizers',
      calories: 800,
      description: 'Fried mozzarella cheese topped with alfredo drizzle. Served with marinara sauce.',
      ingredients: ['Mozzarella', 'Breadcrumbs', 'Marinara Sauce', 'Alfredo Drizzle'],
    ),
    const DishModel(
      id: '7',
      name: 'Calamari',
      imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?q=80&w=800&auto=format&fit=crop', // Generic Calamari
      price: 12.29,
      rating: 4.6,
      reviewCount: 1100,
      category: 'Appetizers',
      calories: 670,
      description: 'Tender calamari, lightly breaded and fried. Served with marinara sauce and spicy ranch.',
      ingredients: ['Calamari', 'Marinara Sauce', 'Spicy Ranch'],
    ),
    const DishModel(
      id: '8',
      name: 'Spinach-Artichoke Dip',
      imageUrl: 'https://images.unsplash.com/photo-1576506295286-5cda18df43e7?q=80&w=800&auto=format&fit=crop', // Generic Dip
      price: 11.29,
      rating: 4.7,
      reviewCount: 1500,
      category: 'Appetizers',
      calories: 1160,
      description: 'A blend of creamy spinach, artichokes, and five cheeses. Served with flatbread crisps.',
      ingredients: ['Spinach', 'Artichokes', 'Five Cheese Blend', 'Flatbread Crisps'],
    ),

    // Desserts
    const DishModel(
      id: '9',
      name: 'Tiramisu',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?q=80&w=800&auto=format&fit=crop', // Generic Tiramisu
      price: 8.99,
      rating: 4.9,
      reviewCount: 2800,
      category: 'Desserts',
      calories: 470,
      description: 'The classic Italian dessert. A layer of creamy custard set atop espresso-soaked ladyfingers.',
      ingredients: ['Espresso', 'Ladyfingers', 'Custard', 'Cocoa Powder'],
    ),
    const DishModel(
      id: '10',
      name: 'Black Tie Mousse Cake',
      imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=800&auto=format&fit=crop', // Generic Choc Cake
      price: 9.49,
      rating: 4.8,
      reviewCount: 2000,
      category: 'Desserts',
      calories: 750,
      description: 'Rich chocolate cake, dark chocolate cheesecake and creamy custard mousse.',
      ingredients: ['Chocolate Cake', 'Dark Chocolate Cheesecake', 'Custard Mousse'],
    ),
    const DishModel(
      id: '11',
      name: 'Warm Italian Doughnuts',
      imageUrl: 'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?q=80&w=800&auto=format&fit=crop', // Generic Doughnuts
      price: 11.49,
      rating: 4.7,
      reviewCount: 1300,
      category: 'Desserts',
      calories: 810,
      description: 'Fried doughnuts tossed in vanilla sugar. Served with raspberry or chocolate sauce.',
      ingredients: ['Doughnuts', 'Vanilla Sugar', 'Raspberry Sauce', 'Chocolate Sauce'],
    ),
    // Burgers
    const DishModel(
      id: '12',
      name: 'Bear Burger',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800&auto=format&fit=crop', // Generic Burger
      price: 14.99,
      rating: 4.6,
      reviewCount: 500,
      category: 'Burgers',
      calories: 1100,
      description: 'Our signature burger! Double patty topped with bacon, cheddar, lettuce, tomato, and pickle.',
      ingredients: ['Beef Patties', 'Bacon', 'Cheddar', 'Lettuce', 'Tomato', 'Pickle', 'Bun'],
    ),
    const DishModel(
      id: '13',
      name: 'Mushroom Swiss Burger',
      imageUrl: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?q=80&w=800&auto=format&fit=crop', // Generic Mushroom Swiss
      price: 13.49,
      rating: 4.7,
      reviewCount: 420,
      category: 'Burgers',
      calories: 950,
      description: 'Juicy beef patty topped with sautéed wild mushrooms and melted Swiss cheese.',
      ingredients: ['Beef Patty', 'Swiss Cheese', 'Mushrooms', 'Bun'],
    ),
    const DishModel(
      id: '14',
      name: 'Oasis Cheeseburger',
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=800&auto=format&fit=crop', // Generic Cheeseburger
      price: 12.49,
      rating: 4.5,
      reviewCount: 600,
      category: 'Burgers',
      calories: 900,
      description: 'Classic cheeseburger with American cheese, lettuce, tomato, and onion.',
      ingredients: ['Beef Patty', 'American Cheese', 'Lettuce', 'Tomato', 'Onion', 'Bun'],
    ),

    // Sandwiches
    const DishModel(
      id: '15',
      name: 'Oasis Club Sandwich',
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?q=80&w=800&auto=format&fit=crop', // Generic Club
      price: 11.99,
      rating: 4.8,
      reviewCount: 350,
      category: 'Sandwiches',
      calories: 750,
      description: 'Triple-decker sandwich with turkey, ham, bacon, lettuce, tomato, and mayo.',
      ingredients: ['Turkey', 'Ham', 'Bacon', 'Lettuce', 'Tomato', 'Mayo', 'Toast'],
    ),
    const DishModel(
      id: '16',
      name: 'Grilled Cheese',
      imageUrl: 'https://images.unsplash.com/photo-1528736235302-52922dfa4e51?q=80&w=800&auto=format&fit=crop', // Generic Grilled Cheese
      price: 8.99,
      rating: 4.4,
      reviewCount: 200,
      category: 'Sandwiches',
      calories: 600,
      description: 'Golden toasted bread filled with melted American and Cheddar cheeses.',
      ingredients: ['American Cheese', 'Cheddar Cheese', 'Bread', 'Butter'],
    ),

    // Sides & Salads
    const DishModel(
      id: '17',
      name: 'Loaded Fries',
      imageUrl: 'https://images.unsplash.com/photo-1585109649139-36680186c5d1?q=80&w=800&auto=format&fit=crop', // Generic Loaded Fries
      price: 9.99,
      rating: 4.9,
      reviewCount: 800,
      category: 'Sides',
      calories: 1200,
      description: 'Crispy fries topped with melted cheese, bacon bits, jalapenos, and ranch drizzle.',
      ingredients: ['Fries', 'Cheese Sauce', 'Bacon', 'Jalapenos', 'Ranch'],
    ),
    const DishModel(
      id: '18',
      name: 'Oasis Salad',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800&auto=format&fit=crop', // Generic Salad
      price: 10.99,
      rating: 4.7,
      reviewCount: 300,
      category: 'Salads',
      calories: 450,
      description: 'Fresh greens with edamame, veggies, crispy wontons, and citrus vinaigrette.',
      ingredients: ['Mixed Greens', 'Edamame', 'Wontons', 'Vinaigrette'],
    ),

    // Chili's Items
    // Fajitas
    const DishModel(
      id: '19',
      name: 'Mix & Match Fajitas',
      imageUrl: 'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?q=80&w=800&auto=format&fit=crop', // Generic Fajitas
      price: 18.99,
      rating: 4.8,
      reviewCount: 1500,
      category: 'Fajitas',
      calories: 1100,
      description: 'Sizzling fajitas with your choice of two proteins: Chicken, Steak, or Shrimp. Served with mexican rice, black beans, and flour tortillas.',
      ingredients: ['Chicken/Steak/Shrimp', 'Peppers', 'Onions', 'Rice', 'Beans', 'Tortillas', 'Guacamole'],
    ),
    const DishModel(
      id: '20',
      name: 'Chicken Fajitas',
      imageUrl: 'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?q=80&w=800&auto=format&fit=crop', // Generic Chicken Tacos/Fajitas
      price: 16.49,
      rating: 4.7,
      reviewCount: 1200,
      category: 'Fajitas',
      calories: 980,
      description: 'Grilled chicken breast with bell peppers and onions. Served with all the fixings.',
      ingredients: ['Grilled Chicken', 'Bell Peppers', 'Onions', 'Sour Cream', 'Pico de Gallo', 'Salsa'],
    ),

    // Ribs
    const DishModel(
      id: '21',
      name: 'Original Baby Back Ribs',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800&auto=format&fit=crop', // Generic Ribs
      price: 22.99,
      rating: 4.9,
      reviewCount: 2200,
      category: 'Ribs',
      calories: 1400,
      description: 'Our world-famous baby back ribs, slow-cooked and smoked in-house over pecan wood. Served with fries and coleslaw.',
      ingredients: ['Pork Ribs', 'BBQ Sauce', 'Fries', 'Coleslaw'],
    ),
    const DishModel(
      id: '22',
      name: 'Smokehouse Combo',
      imageUrl: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?q=80&w=800&auto=format&fit=crop', // Generic BBQ Combo
      price: 19.99,
      rating: 4.8,
      reviewCount: 1800,
      category: 'Ribs',
      calories: 1250,
      description: 'Choose any two meat favorites: Half Rack of Ribs, Brisket, or Crispy Chicken Crispers. Served with corn on the cob and fries.',
      ingredients: ['Ribs', 'Brisket/Chicken', 'Corn', 'Fries', 'Garlic Toast'],
    ),

    // More Burgers (Chili's)
    const DishModel(
      id: '23',
      name: 'Oldtimer w/ Cheese',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800&auto=format&fit=crop', // Generic Burger
      price: 11.29,
      rating: 4.6,
      reviewCount: 950,
      category: 'Burgers',
      calories: 850,
      description: 'The burger that started it all. pickles, lettuce, tomato, red onion and mustard.',
      ingredients: ['Beef Patty', 'Cheddar', 'Pickles', 'Lettuce', 'Tomato', 'Mustard', 'Bun'],
    ),
    const DishModel(
      id: '24',
      name: 'Big Bacon BBQ Burger',
      imageUrl: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?q=80&w=800&auto=format&fit=crop', // Generic Bacon BBQ
      price: 14.49,
      rating: 4.8,
      reviewCount: 1100,
      category: 'Burgers',
      calories: 1300,
      description: 'Two beef patties, six slices of bacon, house BBQ sauce, cheddar, red onion and pickles.',
      ingredients: ['Double Beef Patty', 'Bacon', 'BBQ Sauce', 'Cheddar', 'Onion', 'Pickles'],
    ),
  ];
}
