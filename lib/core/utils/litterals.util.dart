class LitteralsUtil {
  static String getGameCategory(String category) {
    switch (category) {
      case 'mainGame':
        return 'Jeu principal';
      case 'dlcAddon':
        return 'DLC / Addon';
      case 'expansion':
        return 'Extension';
      case 'bundle':
        return 'Bundle';
      case 'standaloneExpansion':
        return 'Extension autonome';
      case 'mod':
        return 'Mod';
      case 'episode':
        return 'Épisode';
      case 'season':
        return 'Saison';
      case 'remake':
        return 'Remake';
      case 'remaster':
        return 'Remaster';
      case 'expandedGame':
        return 'Jeu étendu';
      case 'port':
        return 'Port';
      case 'fork':
        return 'Fork';
      case 'pack':
        return 'Pack';
      case 'update':
        return 'Mise à jour';
      default:
        return 'Inconnu';
    }
  }
}
