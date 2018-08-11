class RavepayCard {
  String expirymonth;
  String expiryyear;
  String cardBIN;
  String last4digits;
  String brand;
  List<Map<dynamic, dynamic>> cardTokens;
  String lifeTimeToken;

  RavepayCard({
    this.expirymonth,
    this.expiryyear,
    this.cardBIN,
    this.last4digits,
    this.brand,
    this.cardTokens,
    this.lifeTimeToken,
  });

  factory RavepayCard.fromMap(Map map) {
    return new RavepayCard(
      expirymonth: map["expirymonth"],
      expiryyear: map["expiryyear"],
      cardBIN: map["cardBIN"],
      last4digits: map["last4digits"],
      brand: map["brand"],
      cardTokens: _parseTokenList(map["card_tokens"]),
      lifeTimeToken: map["life_time_token"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "expirymonth": expirymonth,
      "expiryyear": expiryyear,
      "cardBIN": cardBIN,
      "last4digits": last4digits,
      "brand": brand,
      "cardTokens": cardTokens,
      "lifeTimeToken": lifeTimeToken,
    };
  }
}

List<Map<dynamic, dynamic>> _parseTokenList(List<dynamic> tokens) {
  if (tokens == null) {
    return [];
  }

  return new List.from(
    tokens.map<Map<String, dynamic>>(
      (dynamic token) => Map<String, dynamic>.from(token),
    ),
  );
}
