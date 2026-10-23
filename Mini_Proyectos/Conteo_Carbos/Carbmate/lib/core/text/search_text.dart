String normalizeSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp('[áàâãäå]'), 'a')
      .replaceAll('ç', 'c')
      .replaceAll(RegExp('[éèêë]'), 'e')
      .replaceAll(RegExp('[íìîï]'), 'i')
      .replaceAll('ñ', 'n')
      .replaceAll(RegExp('[óòôõö]'), 'o')
      .replaceAll(RegExp('[úùûü]'), 'u')
      .replaceAll(RegExp('[ýÿ]'), 'y');
}
