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
  String get navSchedule => 'Horario';

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
}
