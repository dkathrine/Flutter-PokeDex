String capitalizeFirstLetter(String? word) {
  if (word == null || word.isEmpty) return "";
  return word[0].toUpperCase() + word.substring(1);
}

String capitalizeWords(String? text) {
  if (text == null || text.isEmpty) return "";
  return text
      .split(" ")
      .map((word) {
        return word
            .split("-")
            .map((part) => capitalizeFirstLetter(part))
            .join("-");
      })
      .join(" ");
}

const Set<String> hyphenNameExceptions = {
  'ho-oh',
  'porygon-z',
  'jangmo-o',
  'hakamo-o',
  'kommo-o',
  'tapu-koko',
  'tapu-lele',
  'tapu-bulu',
  'tapu-fini',
  'mr-mime',
  'mime-jr',
  'type-null',
  'mr-rime',
  'great-tusk',
  'scream-tail',
  'brute-bonnet',
  'flutter-mane',
  'slither-wing',
  'sandy-shocks',
  'iron-treads',
  'iron-bundle',
  'iron-hands',
  'iron-jugulis',
  'iron-moth',
  'iron-thorns',
  'wo-chien',
  'chien-pao',
  'ting-lu',
  'chi-yu',
  'roaring-moon',
  'iron-valiant',
  'walking-wake',
  'iron-leaves',
  'gouging-fire',
  'raging-bolt',
  'iron-boulder',
  'iron-crown',
};

String cleanPokemonName(String rawName) {
  final lowerName = rawName.toLowerCase();

  // do not modify if name is in exceptions
  if (hyphenNameExceptions.contains(lowerName)) return lowerName;

  // otherwise, modify name by removing everthing after the first "-"
  return lowerName.split("-").first;
}
