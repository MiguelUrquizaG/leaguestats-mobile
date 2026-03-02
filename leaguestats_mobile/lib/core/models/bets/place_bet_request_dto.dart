class PlaceBetRequestDto {
  int? userId;
  int? betId;
  int? amount;
  bool? awarded;
  int? winnerSelected;

  PlaceBetRequestDto({
    this.userId,
    this.betId,
    this.amount,
    this.awarded,
    this.winnerSelected,
  });

  PlaceBetRequestDto.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    betId = json['bet_id'];
    amount = json['amount'];
    awarded = json['awarded'];
    winnerSelected = json['winner_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['bet_id'] = this.betId;
    data['amount'] = this.amount;
    data['awarded'] = this.awarded;
    data['winner_selected'] = this.winnerSelected;
    return data;
  }
}
