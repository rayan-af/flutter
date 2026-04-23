// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get profileTitle => 'Editar perfil';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'Tu nombre';

  @override
  String get nameError => 'Por favor, introduce un nombre';

  @override
  String get profileImageLabel => 'URL de la imagen de perfil';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get profileUpdated => '¡Perfil actualizado con éxito!';

  @override
  String get profileUpdateFailed => 'Error al actualizar el perfil.';

  @override
  String get themeSettings => 'Configuración del tema';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get update => 'Actualizar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get unit => 'Unidad';

  @override
  String get navHome => 'Inicio';

  @override
  String get navDashboard => 'Panel de control';

  @override
  String get navPOS => 'Terminal POS';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navCosting => 'Costeo de recetas';

  @override
  String get navWaste => 'Registro de residuos';

  @override
  String get navAI => 'Asistente de IA';

  @override
  String get navTableMap => 'Mapeo de mesas';

  @override
  String get navChefOrders => 'Pedidos del Chef';

  @override
  String get navDrinks => 'Bebidas';

  @override
  String get navMenu => 'Menú';

  @override
  String get navLogin => 'Iniciar sesión';

  @override
  String get navLogout => 'Cerrar sesión';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navSchedule => 'Tiempo de trabajo';

  @override
  String greeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get hungry => '¿Tienes hambre?';

  @override
  String get searchDishes => 'Buscar platos...';

  @override
  String get browseByCategory => 'Explorar por categoría';

  @override
  String get popularDishes => 'Platos populares';

  @override
  String get trySomethingNew => 'Prueba algo nuevo';

  @override
  String get seeMore => 'Ver más';

  @override
  String get noPopularDishes => 'No se encontraron platos populares';

  @override
  String get noNewDishes => 'No se encontraron otros platos';

  @override
  String get loginTitle => 'RestoManager';

  @override
  String get loginSubtitle => 'Inicie sesión en su cuenta para continuar';

  @override
  String get emailLabel => 'Correo electrónico *';

  @override
  String get emailHint => 'Email@email.com';

  @override
  String get passwordLabel => 'Contraseña *';

  @override
  String get passwordHint => '************';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get signupButton => 'Registrarse';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get emailError => 'Por favor, introduzca su correo electrónico';

  @override
  String get passwordError => 'Por favor, introduzca su contraseña';

  @override
  String get invalidCredentials => 'Correo electrónico o contraseña no válidos';

  @override
  String get registrationFailedError =>
      'Error de registro. El correo electrónico ya podría estar en uso.';

  @override
  String get signupTitle => 'Únete a nosotros';

  @override
  String get signupSubtitle => 'Crea una cuenta para empezar';

  @override
  String get fullNameLabel => 'Nombre completo *';

  @override
  String get fullNameHint => 'Juan Pérez';

  @override
  String get fullNameError => 'Por favor, introduce tu nombre';

  @override
  String get emailInvalidError =>
      'Por favor, introduzca un correo electrónico válido';

  @override
  String get navCreateAccount => 'Crear cuenta';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get aiAssistant => 'Asistente de IA';

  @override
  String get bookTable => 'Reservar una mesa';

  @override
  String get catAll => 'Todos';

  @override
  String get catFastFood => 'Comida rápida';

  @override
  String get catCasual => 'Informal';

  @override
  String get catFineDining => 'Alta cocina';

  @override
  String get catCafe => 'Cafetería';

  @override
  String get catBuffet => 'Bufé';

  @override
  String get menuTitle => 'Nuestro Menú';

  @override
  String addedToCart(String name) {
    return '$name añadido al carrito';
  }

  @override
  String get catAppetizers => 'Aperitivos';

  @override
  String get catEntrees => 'Platos Principales';

  @override
  String get catFajitas => 'Fajitas';

  @override
  String get catRibs => 'Costillas';

  @override
  String get catBurgers => 'Hamburguesas';

  @override
  String get catSandwiches => 'Sándwiches';

  @override
  String get catSalads => 'Ensaladas';

  @override
  String get catSides => 'Acompañamientos';

  @override
  String get catDesserts => 'Postres';

  @override
  String get catKidsMenu => 'Menú Infantil';

  @override
  String get catDrinks => 'Bebidas';

  @override
  String get drinksFoodTitle => 'Bebidas y Comida';

  @override
  String get tabDrinks => 'Bebidas';

  @override
  String get tabFood => 'Comida';

  @override
  String noItemsAvailable(String type) {
    return 'No hay $type disponibles';
  }

  @override
  String get dashTitle => 'Panel de Inteligencia';

  @override
  String get keyMetrics => 'MÉTRICAS CLAVE';

  @override
  String get quickActions => 'ACCIONES RÁPIDAS';

  @override
  String get liveActivity => 'FLUJO DE ACTIVIDAD EN VIVO';

  @override
  String get lowStockAlert => 'CRÍTICO: STOCK BAJO';

  @override
  String lowStockCount(Object count) {
    return '$count artículos han caído por debajo de su umbral mínimo.';
  }

  @override
  String get resolve => 'Resolver';

  @override
  String get resetPopDishes => 'Restablecer platos populares';

  @override
  String get resetPopDishesSub =>
      'Borrar todas las estadísticas de pedidos POS y restablecer los platos populares.';

  @override
  String get reset => 'Restablecer';

  @override
  String get resetPopDishesSuccess =>
      'Se han restablecido las estadísticas de platos populares.';

  @override
  String get dailySales => 'Ventas diarias';

  @override
  String get activeOrders => 'Pedidos activos';

  @override
  String get wasteLoss => 'Pérdida por desperdicio (7d)';

  @override
  String get invHealth => 'Salud del inventario';

  @override
  String get noActivity => 'No se registró actividad reciente.';

  @override
  String get newOrderActivity => 'Nuevo pedido creado';

  @override
  String get wasteLoggedActivity => 'Desperdicio registrado';

  @override
  String get total => 'Total';

  @override
  String get status => 'Estado';

  @override
  String get lost => 'Perdido';

  @override
  String get qty => 'Cant';

  @override
  String get reason => 'Razón';

  @override
  String get aiAssistantTitle => 'Asistente de IA de Cafe';

  @override
  String get aiAssistantHint => 'Pregunta sobre el menú o las reservas...';

  @override
  String get aiAssistantError =>
      'Lo siento, tengo problemas para conectarme ahora mismo. 😔';

  @override
  String get recipeCostingTitle => 'Costeo de recetas';

  @override
  String get selectTemplate => 'Seleccionar plantilla';

  @override
  String get selectMenuItem => 'Seleccionar artículo del menú (Opcional)';

  @override
  String get plateInputs => 'Entradas del plato';

  @override
  String get plateCostLabel => 'Costo total del plato (\$)';

  @override
  String get plateCostHelper =>
      'Calculado automáticamente desde la receta o manual.';

  @override
  String get targetPriceLabel => 'Precio de venta objetivo (\$)';

  @override
  String get targetPriceHelper => 'Precio del menú para el cliente.';

  @override
  String get grossProfitMargin => 'MARGEN DE UTILIDAD BRUTA';

  @override
  String get profitPerPlate => 'Beneficio por plato';

  @override
  String get missingIngredientsWarning =>
      'Advertencia: Algunos ingredientes no se encontraron en el inventario. El costo puede ser inexacto.';

  @override
  String get tableMappingTitle => 'Mapeo de mesas';

  @override
  String get chefOrdersTitle => 'Pedidos del chef';

  @override
  String get inventoryTitle => 'Inventario';

  @override
  String get posTitle => 'Terminal POS';

  @override
  String get wasteLogTitle => 'Registro de desperdicios';

  @override
  String get cartEmpty => 'Carrito vacío';

  @override
  String get itemsCount => 'Artículos';

  @override
  String get addMenuItem => 'Añadir artículo al menú';

  @override
  String get noItemsInMenu => 'No hay artículos en el menú.';

  @override
  String get addToCart => 'Añadir al carrito';

  @override
  String get sessionLog => 'Registro de sesión';

  @override
  String get confirmOrder => 'Confirmar pedido';

  @override
  String get clearCart => 'Limpiar carrito';

  @override
  String get orderConfirmed => '¡Pedido confirmado con éxito!';

  @override
  String get quantity => 'Cantidad';

  @override
  String get scheduleTitle => 'Tiempo de trabajo';

  @override
  String get inventoryListing => 'Listado de inventario';

  @override
  String get inventoryManagement => 'Gestión de inventario';

  @override
  String get newItem => 'Nuevo artículo';

  @override
  String get itemName => 'Nombre del artículo';

  @override
  String get category => 'Categoría';

  @override
  String get priceCost => 'Precio (Costo)';

  @override
  String get quickQuantity => 'Cantidad rápida';

  @override
  String get actions => 'Acciones';

  @override
  String get lowStock => 'Bajo stock';

  @override
  String get inStock => 'En stock';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String removeInventoryItem(Object name) {
    return '¿Eliminar $name del inventario?';
  }

  @override
  String updateItem(Object name) {
    return 'Actualizar $name';
  }

  @override
  String get addQuantity => 'Añadir cantidad';

  @override
  String get addInventoryItem => 'Añadir artículo al inventario';

  @override
  String get costPrice => 'Costo / Precio';

  @override
  String get addItemSuccess => '¡Artículo añadido al inventario!';

  @override
  String get liquid => 'Líquido';

  @override
  String get solid => 'Sólido';

  @override
  String get groundFloor => 'Planta baja';

  @override
  String get firstFloor => '1ª planta';

  @override
  String get secondFloor => '2ª planta';

  @override
  String get rooftop => 'Azotea';

  @override
  String seats(int count) {
    return '$count asientos';
  }

  @override
  String get seatWalkIn => 'Sentar cliente sin reserva';

  @override
  String get markReserved => 'Marcar como reservado';

  @override
  String get clearTableAvailable => 'Limpiar mesa (Disponible)';

  @override
  String get occupied => 'Ocupado';

  @override
  String get available => 'Disponible';

  @override
  String get reserved => 'Reservado';

  @override
  String get logSpoilage => 'Registrar merma / desperdicio';

  @override
  String get quantityWasted => 'Cantidad desperdiciada';

  @override
  String get expired => 'Vencido';

  @override
  String get spilled => 'Derramado';

  @override
  String get badQuality => 'Mala calidad';

  @override
  String get mistake => 'Error';

  @override
  String get logWaste => 'REGISTRAR DESPERDICIO';

  @override
  String get recentWasteLogs => 'Registros de desperdicios recientes';

  @override
  String get noWasteLogs => 'No hay registros de desperdicios.';

  @override
  String get wasteLoggedSuccess => 'Desperdicio registrado con éxito';

  @override
  String get selectItem => 'Por favor seleccione un artículo';

  @override
  String get selectReason => 'Seleccione una razón';

  @override
  String get enterQuantity => 'Ingrese la cantidad';

  @override
  String get invalidNumber => 'Número no válido';

  @override
  String get item => 'Artículo';

  @override
  String get markCompleted => 'Toca dos veces para marcar como hecho';

  @override
  String get totalWeeklyHours => 'Total de horas semanales';

  @override
  String get upcomingShifts => 'Próximos turnos';

  @override
  String get today => 'HOY';

  @override
  String get justNow => 'Justo ahora';

  @override
  String minsAgo(int mins) {
    return 'Hace $mins min';
  }

  @override
  String hoursMinsAgo(int hours, int mins) {
    return 'Hace ${hours}h ${mins}m';
  }

  @override
  String errorMsg(String error) {
    return 'Error: $error';
  }
}
