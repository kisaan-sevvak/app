class MarketPrice {
  final String commodity;
  final String variety;
  final String market;
  final String state;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final DateTime date;

  MarketPrice({
    required this.commodity,
    required this.variety,
    required this.market,
    required this.state,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.date,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      commodity: json['commodity'],
      variety: json['variety'],
      market: json['market'],
      state: json['state'],
      minPrice: json['min_price'].toDouble(),
      maxPrice: json['max_price'].toDouble(),
      modalPrice: json['modal_price'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodity': commodity,
      'variety': variety,
      'market': market,
      'state': state,
      'min_price': minPrice,
      'max_price': maxPrice,
      'modal_price': modalPrice,
      'date': date.toIso8601String(),
    };
  }
}

class MarketTrend {
  final String commodity;
  final String market;
  final double priceChange;
  final double percentageChange;
  final String trend; // 'up', 'down', or 'stable'
  final DateTime startDate;
  final DateTime endDate;

  MarketTrend({
    required this.commodity,
    required this.market,
    required this.priceChange,
    required this.percentageChange,
    required this.trend,
    required this.startDate,
    required this.endDate,
  });

  factory MarketTrend.fromJson(Map<String, dynamic> json) {
    return MarketTrend(
      commodity: json['commodity'],
      market: json['market'],
      priceChange: json['price_change'].toDouble(),
      percentageChange: json['percentage_change'].toDouble(),
      trend: json['trend'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodity': commodity,
      'market': market,
      'price_change': priceChange,
      'percentage_change': percentageChange,
      'trend': trend,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}

class MarketSummary {
  final String commodity;
  final double averagePrice;
  final double lowestPrice;
  final double highestPrice;
  final String lowestPriceMarket;
  final String highestPriceMarket;
  final DateTime date;

  MarketSummary({
    required this.commodity,
    required this.averagePrice,
    required this.lowestPrice,
    required this.highestPrice,
    required this.lowestPriceMarket,
    required this.highestPriceMarket,
    required this.date,
  });

  factory MarketSummary.fromJson(Map<String, dynamic> json) {
    return MarketSummary(
      commodity: json['commodity'],
      averagePrice: json['average_price'].toDouble(),
      lowestPrice: json['lowest_price'].toDouble(),
      highestPrice: json['highest_price'].toDouble(),
      lowestPriceMarket: json['lowest_price_market'],
      highestPriceMarket: json['highest_price_market'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodity': commodity,
      'average_price': averagePrice,
      'lowest_price': lowestPrice,
      'highest_price': highestPrice,
      'lowest_price_market': lowestPriceMarket,
      'highest_price_market': highestPriceMarket,
      'date': date.toIso8601String(),
    };
  }
} 