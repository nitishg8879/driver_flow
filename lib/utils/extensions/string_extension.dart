extension RuppessExt on num? {
  String get toRuppess {
    if (this == null) {
      return "N/A";
    }
    return "₹${this?.toStringAsFixed(2)}";
  }
}
