String formatWeight(double? n) {
  return n != null
      ? '${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1)} kg'
      : 'n/a';
}
