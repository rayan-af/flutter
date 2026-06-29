const fs = require('fs');

const newKeys = {
  en: {
    descriptionLabel: 'Description',
    ingredientsLabel: 'Ingredients',
    freeDelivery: 'Free Delivery',
    addToCartLabel: 'Add to Cart',
    kcalLabel: 'kcal',
    minLabel: 'min',
    menuEditorTitle: 'Menu Editor',
    errorLoadingMenu: 'Error loading menu',
    noMenuItemsFound: 'No menu items found',
    addDishLabel: 'Add Dish',
    editDishLabel: 'Edit Dish',
    basicDetails: 'Basic Details',
    dishNameLabel: 'Dish Name',
    priceLabel: 'Price',
    categoryLabel: 'Category',
    imageUrlLabel: 'Image URL',
    saveDishLabel: 'Save Dish',
    fullNameLabel: 'Full Name',
    phoneNumberLabel: 'Phone Number',
    dateLabel: 'Date',
    timeLabel: 'Time',
    partySizeLabel: 'Party Size',
    notesLabel: 'Notes',
    specialRequests: 'Special requests...'
  },
  es: {
    descriptionLabel: 'Descripción',
    ingredientsLabel: 'Ingredientes',
    freeDelivery: 'Entrega gratis',
    addToCartLabel: 'Añadir al carrito',
    kcalLabel: 'kcal',
    minLabel: 'min',
    menuEditorTitle: 'Editor de menú',
    errorLoadingMenu: 'Error al cargar el menú',
    noMenuItemsFound: 'No se encontraron platos',
    addDishLabel: 'Añadir plato',
    editDishLabel: 'Editar plato',
    basicDetails: 'Detalles básicos',
    dishNameLabel: 'Nombre del plato',
    priceLabel: 'Precio',
    categoryLabel: 'Categoría',
    imageUrlLabel: 'URL de la imagen',
    saveDishLabel: 'Guardar plato',
    fullNameLabel: 'Nombre completo',
    phoneNumberLabel: 'Número de teléfono',
    dateLabel: 'Fecha',
    timeLabel: 'Hora',
    partySizeLabel: 'Número de personas',
    notesLabel: 'Notas',
    specialRequests: 'Peticiones especiales...'
  },
  fr: {
    descriptionLabel: 'Description',
    ingredientsLabel: 'Ingrédients',
    freeDelivery: 'Livraison gratuite',
    addToCartLabel: 'Ajouter au panier',
    kcalLabel: 'kcal',
    minLabel: 'min',
    menuEditorTitle: 'Éditeur de menu',
    errorLoadingMenu: 'Erreur de chargement du menu',
    noMenuItemsFound: 'Aucun plat trouvé',
    addDishLabel: 'Ajouter un plat',
    editDishLabel: 'Modifier le plat',
    basicDetails: 'Détails de base',
    dishNameLabel: 'Nom du plat',
    priceLabel: 'Prix',
    categoryLabel: 'Catégorie',
    imageUrlLabel: 'URL de l\'image',
    saveDishLabel: 'Enregistrer le plat',
    fullNameLabel: 'Nom complet',
    phoneNumberLabel: 'Numéro de téléphone',
    dateLabel: 'Date',
    timeLabel: 'Heure',
    partySizeLabel: 'Nombre de personnes',
    notesLabel: 'Notes',
    specialRequests: 'Demandes spéciales...'
  },
  ja: {
    descriptionLabel: '説明',
    ingredientsLabel: '材料',
    freeDelivery: '送料無料',
    addToCartLabel: 'カートに追加',
    kcalLabel: 'kcal',
    minLabel: '分',
    menuEditorTitle: 'メニューエディタ',
    errorLoadingMenu: 'メニューの読み込みエラー',
    noMenuItemsFound: 'メニューが見つかりません',
    addDishLabel: '料理を追加',
    editDishLabel: '料理を編集',
    basicDetails: '基本情報',
    dishNameLabel: '料理名',
    priceLabel: '価格',
    categoryLabel: 'カテゴリー',
    imageUrlLabel: '画像URL',
    saveDishLabel: '料理を保存',
    fullNameLabel: 'フルネーム',
    phoneNumberLabel: '電話番号',
    dateLabel: '日付',
    timeLabel: '時間',
    partySizeLabel: '人数',
    notesLabel: '備考',
    specialRequests: '特別なリクエスト...'
  },
  ar: {
    descriptionLabel: 'الوصف',
    ingredientsLabel: 'المكونات',
    freeDelivery: 'توصيل مجاني',
    addToCartLabel: 'أضف إلى السلة',
    kcalLabel: 'سعرة حرارية',
    minLabel: 'دقيقة',
    menuEditorTitle: 'محرر القائمة',
    errorLoadingMenu: 'خطأ في تحميل القائمة',
    noMenuItemsFound: 'لم يتم العثور على أطباق',
    addDishLabel: 'إضافة طبق',
    editDishLabel: 'تعديل الطبق',
    basicDetails: 'التفاصيل الأساسية',
    dishNameLabel: 'اسم الطبق',
    priceLabel: 'السعر',
    categoryLabel: 'الفئة',
    imageUrlLabel: 'رابط الصورة',
    saveDishLabel: 'حفظ الطبق',
    fullNameLabel: 'الاسم الكامل',
    phoneNumberLabel: 'رقم الهاتف',
    dateLabel: 'التاريخ',
    timeLabel: 'الوقت',
    partySizeLabel: 'عدد الأشخاص',
    notesLabel: 'ملاحظات',
    specialRequests: 'طلبات خاصة...'
  }
};

const langs = ['en', 'es', 'fr', 'ja', 'ar'];

for (const lang of langs) {
  const filePath = `lib/l10n/app_${lang}.arb`;
  if (fs.existsSync(filePath)) {
    let raw = fs.readFileSync(filePath, 'utf8');
    let obj = JSON.parse(raw);
    Object.assign(obj, newKeys[lang]);
    fs.writeFileSync(filePath, JSON.stringify(obj, null, 2), 'utf8');
    console.log(`Updated ${lang}`);
  } else {
    console.log(`File not found: ${filePath}`);
  }
}
