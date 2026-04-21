// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get profileTitle => 'Modifier le profil';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHint => 'Votre nom';

  @override
  String get nameError => 'Veuillez entrer un nom';

  @override
  String get profileImageLabel => 'URL de l\'image de profil';

  @override
  String get profileImageHint => 'https://...';

  @override
  String get saveChanges => 'Sauvegarder les modifications';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès !';

  @override
  String get profileUpdateFailed => 'Échec de la mise à jour du profil.';

  @override
  String get themeSettings => 'Paramètres du thème';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navPOS => 'Terminal POS';

  @override
  String get navInventory => 'Inventaire';

  @override
  String get navCosting => 'Coût des recettes';

  @override
  String get navWaste => 'Registre des déchets';

  @override
  String get navAI => 'Assistant IA';

  @override
  String get navTableMap => 'Plan des tables';

  @override
  String get navChefOrders => 'Commandes Chef';

  @override
  String get navDrinks => 'Boissons';

  @override
  String get navMenu => 'Menu';

  @override
  String get navLogin => 'Connexion';

  @override
  String get navLogout => 'Déconnexion';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navOrders => 'Commandes';

  @override
  String get navSchedule => 'Horaire';

  @override
  String greeting(String name) {
    return 'Salut, $name';
  }

  @override
  String get hungry => 'Faim ?';

  @override
  String get searchDishes => 'Rechercher des plats...';

  @override
  String get browseByCategory => 'Parcourir par catégorie';

  @override
  String get popularDishes => 'Plats populaires';

  @override
  String get trySomethingNew => 'Essayer quelque chose de nouveau';

  @override
  String get seeMore => 'Voir plus';

  @override
  String get noPopularDishes => 'Aucun plat populaire trouvé';

  @override
  String get noNewDishes => 'Aucun autre plat trouvé';

  @override
  String get loginTitle => 'RestoManager';

  @override
  String get loginSubtitle => 'Connectez-vous à votre compte pour continuer';

  @override
  String get emailLabel => 'E-mail *';

  @override
  String get emailHint => 'Email@email.com';

  @override
  String get passwordLabel => 'Mot de passe *';

  @override
  String get passwordHint => '************';

  @override
  String get loginButton => 'Connexion';

  @override
  String get signupButton => 'S\'inscrire';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get emailError => 'Veuillez entrer votre e-mail';

  @override
  String get passwordError => 'Veuillez entrer votre mot de passe';

  @override
  String get invalidCredentials => 'E-mail ou mot de passe invalide';

  @override
  String get registrationFailedError =>
      'L\'inscription a échoué. L\'e-mail est peut-être déjà utilisé.';

  @override
  String get signupTitle => 'Rejoignez-nous';

  @override
  String get signupSubtitle => 'Créez un compte pour commencer';

  @override
  String get fullNameLabel => 'Nom complet *';

  @override
  String get fullNameHint => 'Jean Dupont';

  @override
  String get fullNameError => 'Veuillez entrer votre nom';

  @override
  String get emailInvalidError => 'Veuillez entrer un e-mail valide';

  @override
  String get navCreateAccount => 'Créer un compte';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get aiAssistant => 'Assistant IA';

  @override
  String get bookTable => 'Réserver une table';

  @override
  String get catAll => 'Tout';

  @override
  String get catFastFood => 'Restauration rapide';

  @override
  String get catCasual => 'Décontracté';

  @override
  String get catFineDining => 'Gastronomie';

  @override
  String get catCafe => 'Café';

  @override
  String get catBuffet => 'Buffet';

  @override
  String get menuTitle => 'Notre Menu';

  @override
  String addedToCart(String name) {
    return '$name ajouté au panier';
  }

  @override
  String get catAppetizers => 'Entrées';

  @override
  String get catEntrees => 'Plats Principaux';

  @override
  String get catFajitas => 'Fajitas';

  @override
  String get catRibs => 'Côtes';

  @override
  String get catBurgers => 'Burgers';

  @override
  String get catSandwiches => 'Sandwiches';

  @override
  String get catSalads => 'Salades';

  @override
  String get catSides => 'Accompagnements';

  @override
  String get catDesserts => 'Desserts';

  @override
  String get catKidsMenu => 'Menu Enfant';

  @override
  String get catDrinks => 'Boissons';

  @override
  String get drinksFoodTitle => 'Boissons et Nourriture';

  @override
  String get tabDrinks => 'Boissons';

  @override
  String get tabFood => 'Nourriture';

  @override
  String noItemsAvailable(String type) {
    return 'Pas de $type disponible';
  }

  @override
  String get dashTitle => 'Tableau de bord intelligent';

  @override
  String get keyMetrics => 'MÉTRIQUES CLÉS';

  @override
  String get quickActions => 'ACTIONS RAPIDES';

  @override
  String get liveActivity => 'FLUX D\'ACTIVITÉ EN DIRECT';

  @override
  String get lowStockAlert => 'CRITIQUE : STOCK FAIBLE';

  @override
  String lowStockCount(Object count) {
    return '$count articles sont tombés en dessous de leur seuil minimal.';
  }

  @override
  String get resolve => 'Résoudre';

  @override
  String get resetPopDishes => 'Réinitialiser les plats populaires';

  @override
  String get resetPopDishesSub =>
      'Effacer toutes les statistiques de commandes POS et réinitialiser les plats populaires.';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetPopDishesSuccess =>
      'Les statistiques des plats populaires ont été réinitialisées.';

  @override
  String get dailySales => 'Ventes quotidiennes';

  @override
  String get activeOrders => 'Commandes actives';

  @override
  String get wasteLoss => 'Perte de déchets (7j)';

  @override
  String get invHealth => 'Santé de l\'inventaire';

  @override
  String get noActivity => 'Aucune activité récente enregistrée.';

  @override
  String get newOrderActivity => 'Nouvelle commande créée';

  @override
  String get wasteLoggedActivity => 'Déchet enregistré';

  @override
  String get lost => 'Perdu';

  @override
  String get qty => 'Qté';

  @override
  String get reason => 'Raison';

  @override
  String get aiAssistantTitle => 'Assistant Café IA';

  @override
  String get aiAssistantHint =>
      'Demandez des informations sur le menu ou les réservations...';

  @override
  String get aiAssistantError =>
      'Désolé, j\'ai du mal à me connecter pour le moment. 😔';
}
