import 'package:flutter/material.dart';
import '../core/models/dish_model.dart';

class MockTranslations {
  static String getDishName(BuildContext context, DishModel dish) {
    final lang = Localizations.localeOf(context).languageCode;
    final map = _dishTranslations[dish.id];
    if (map != null && map[lang] != null && map[lang]!['name'] != null) {
      return map[lang]!['name']!;
    }
    return dish.name;
  }

  static String getDishDescription(BuildContext context, DishModel dish) {
    final lang = Localizations.localeOf(context).languageCode;
    final map = _dishTranslations[dish.id];
    if (map != null && map[lang] != null && map[lang]!['description'] != null) {
      return map[lang]!['description']!;
    }
    return dish.description;
  }

  static String getCategory(BuildContext context, String category) {
    final lang = Localizations.localeOf(context).languageCode;
    final map = _categoryTranslations[category];
    if (map != null && map[lang] != null) {
      return map[lang]!;
    }
    return category;
  }

  static String translate(BuildContext context, String text) {
    final lang = Localizations.localeOf(context).languageCode;
    final map = _staticTranslations[text];
    if (map != null && map[lang] != null) {
      return map[lang]!;
    }
    return text;
  }

  static final Map<String, Map<String, String>> _staticTranslations = {
    'Special Offers': {
      'es': 'Ofertas Especiales', 'fr': 'Offres Spéciales', 'ja': '特別オファー', 'ar': 'عروض خاصة'
    },
    '50% OFF': {
      'es': '50% DE DESCUENTO', 'fr': '50% DE RÉDUCTION', 'ja': '50%オフ', 'ar': 'خصم 50%'
    },
    'On your first order': {
      'es': 'En tu primer pedido', 'fr': 'Sur votre première commande', 'ja': '初回注文時', 'ar': 'على طلبك الأول'
    },
    'Use Code: WELCOME50': {
      'es': 'Usa Código: WELCOME50', 'fr': 'Code: WELCOME50', 'ja': 'コード: WELCOME50', 'ar': 'استخدم الكود: WELCOME50'
    },
    'FREE DELIVERY': {
      'es': 'ENTREGA GRATIS', 'fr': 'LIVRAISON GRATUITE', 'ja': '送料無料', 'ar': 'توصيل مجاني'
    },
    'For all burger categories': {
      'es': 'Para todas las hamburguesas', 'fr': 'Pour tous les burgers', 'ja': '全バーガー対象', 'ar': 'لجميع أنواع البرجر'
    },
    'Use Code: BURGERFREE': {
      'es': 'Usa Código: BURGERFREE', 'fr': 'Code: BURGERFREE', 'ja': 'コード: BURGERFREE', 'ar': 'استخدم الكود: BURGERFREE'
    },
    'BOGO DEAL': {
      'es': 'OFERTA 2x1', 'fr': 'OFFRE 1 ACHETÉ 1 OFFERT', 'ja': '1つ買うと1つ無料', 'ar': 'اشتر 1 واحصل على 1 مجاناً'
    },
    'Buy 1 Get 1 Free on Coffees': {
      'es': '2x1 en Cafés', 'fr': '2 pour 1 sur les cafés', 'ja': 'コーヒー2杯目無料', 'ar': '2 مقابل 1 على القهوة'
    },
    'Use Code: COFFEEBOGO': {
      'es': 'Usa Código: COFFEEBOGO', 'fr': 'Code: COFFEEBOGO', 'ja': 'コード: COFFEEBOGO', 'ar': 'استخدم الكود: COFFEEBOGO'
    },
  };

  static final Map<String, Map<String, String>> _categoryTranslations = {
    'Burgers': {
      'en': 'Burgers', 'es': 'Hamburguesas', 'fr': 'Burgers', 'ja': 'バーガー', 'ar': 'برجر'
    },
    'Coffee': {
      'en': 'Coffee', 'es': 'Café', 'fr': 'Café', 'ja': 'コーヒー', 'ar': 'قهوة'
    },
    'Drinks': {
      'en': 'Drinks', 'es': 'Bebidas', 'fr': 'Boissons', 'ja': 'ドリンク', 'ar': 'مشروبات'
    },
    'Salads': {
      'en': 'Salads', 'es': 'Ensaladas', 'fr': 'Salades', 'ja': 'サラダ', 'ar': 'سلطات'
    },
    'Pastries': {
      'en': 'Pastries', 'es': 'Pastelería', 'fr': 'Pâtisseries', 'ja': 'ペストリー', 'ar': 'معجنات'
    },
    'Breakfast': {
      'en': 'Breakfast', 'es': 'Desayuno', 'fr': 'Petit-déjeuner', 'ja': '朝食', 'ar': 'إفطار'
    },
    'Desserts': {
      'en': 'Desserts', 'es': 'Postres', 'fr': 'Desserts', 'ja': 'デザート', 'ar': 'حلويات'
    },
    'Entrees': {
      'en': 'Entrees', 'es': 'Platos Principales', 'fr': 'Plats Principaux', 'ja': 'メインディッシュ', 'ar': 'أطباق رئيسية'
    },
    'Appetizers': {
      'en': 'Appetizers', 'es': 'Aperitivos', 'fr': 'Apéritifs', 'ja': '前菜', 'ar': 'مقبلات'
    },
  };

  static final Map<String, Map<String, Map<String, String>>> _dishTranslations = {
    'bev_1': {
      'es': {
        'name': 'Macchiato de Caramelo',
        'description': 'Leche recién al vapor con jarabe sabor a vainilla marcado con espresso y coronado con un chorrito de caramelo.',
      },
      'fr': {
        'name': 'Macchiato au Caramel',
        'description': 'Lait fraîchement cuit à la vapeur avec un sirop saveur vanille marqué avec un expresso et garni d\'un filet de caramel.',
      },
      'ja': {
        'name': 'キャラメルマキアート',
        'description': 'バニラ風味のシロップを入れたスチームミルクにエスプレッソを加え、キャラメルソースをトッピング。',
      },
      'ar': {
        'name': 'مكياتو بالكراميل',
        'description': 'حليب مبخر طازج مع شراب بنكهة الفانيليا ممزوج بقهوة الإسبريسو ومغطى بصلصة الكراميل.',
      }
    },
    'bev_2': {
      'es': {
        'name': 'Capuchino',
        'description': 'Espresso oscuro y rico aguarda bajo una capa suavizada y estirada de espuma de leche gruesa.',
      },
      'fr': {
        'name': 'Cappuccino',
        'description': 'Un expresso sombre et riche se cache sous une couche lissée et étirée de mousse de lait épaisse.',
      },
      'ja': {
        'name': 'カプチーノ',
        'description': 'ダークでリッチなエスプレッソが、滑らかに伸ばされた厚いミルクフォームの層の下で待っています。',
      },
      'ar': {
        'name': 'كابتشينو',
        'description': 'إسبريسو داكن وغني يكمن تحت طبقة ناعمة وممتدة من رغوة الحليب الكثيفة.',
      }
    },
    'bev_3': {
      'es': {
        'name': 'Caffè Latte',
        'description': 'Nuestro espresso oscuro y rico equilibrado con leche al vapor y una ligera capa de espuma.',
      },
      'fr': {
        'name': 'Caffè Latte',
        'description': 'Notre expresso sombre et riche équilibré avec du lait cuit à la vapeur et une légère couche de mousse.',
      },
      'ja': {
        'name': 'カフェラテ',
        'description': 'ダークでリッチなエスプレッソをスチームミルクと軽いフォームの層でバランスよく仕上げました。',
      },
      'ar': {
        'name': 'كافيه لاتيه',
        'description': 'إسبريسو داكن وغني متوازن مع الحليب المبخر وطبقة خفيفة من الرغوة.',
      }
    },
    'bev_4': {
      'es': {
        'name': 'Cold Brew',
        'description': 'Elaborado a mano en pequeños lotes diariamente, remojado lentamente en agua fría durante 20 horas.',
      },
      'fr': {
        'name': 'Café infusé à froid',
        'description': 'Fabriqué à la main en petites quantités tous les jours, infusé lentement dans de l\'eau froide pendant 20 heures.',
      },
      'ja': {
        'name': 'コールドブリュー',
        'description': '毎日少量ずつ手作りされ、冷水で20時間ゆっくりと浸出されています。',
      },
      'ar': {
        'name': 'قهوة باردة',
        'description': 'مصنوعة يدوياً بكميات صغيرة يومياً، تُنقع ببطء في ماء بارد لمدة 20 ساعة.',
      }
    },
    'food_1': {
      'es': {
        'name': 'Pollo Alfredo',
        'description': 'Salsa alfredo casera y cremosa mezclada con pasta fettuccine y cubierta con pollo a la parrilla.',
      },
      'fr': {
        'name': 'Poulet Alfredo',
        'description': 'Sauce alfredo maison crémeuse mélangée à des pâtes fettuccine et garnie de poulet grillé.',
      },
      'ja': {
        'name': 'チキンアルフレッド',
        'description': 'クリーミーな自家製アルフレッドソースをフェットチーネパスタに絡め、グリルチキンをトッピング。',
      },
      'ar': {
        'name': 'دجاج ألفريدو',
        'description': 'صلصة ألفريدو كريمية منزلية الصنع ممزوجة مع مكرونة فيتوتشيني ومغطاة بالدجاج المشوي.',
      }
    },
    'food_2': {
      'es': {
        'name': 'Hamburguesa Clásica',
        'description': 'Jugosa hamburguesa de res con lechuga, tomate y cebolla en un pan brioche.',
      },
      'fr': {
        'name': 'Burger Classique',
        'description': 'Galette de bœuf juteuse garnie de laitue, tomate et oignon sur un pain brioché.',
      },
      'ja': {
        'name': 'クラシックバーガー',
        'description': 'ジューシーなビーフパティにレタス、トマト、玉ねぎをのせ、ブリオッシュバンズで挟みました。',
      },
      'ar': {
        'name': 'برجر كلاسيكي',
        'description': 'شريحة لحم بقري عصارية مغطاة بالخس والطماطم والبصل في خبز بريوش.',
      }
    }
  };
}
