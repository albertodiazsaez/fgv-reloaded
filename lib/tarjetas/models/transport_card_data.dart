class TransportCard {
  String cardNumber;
  String? title;
  String? zone;
  String? cardClass;
  DateTime? validityDate;
  dynamic balance;

  TransportCard(
      {required this.cardNumber,
      this.title,
      this.zone,
      this.cardClass,
      this.validityDate,
      this.balance});
}
