class Ville {
  int idVille;
  String nomVille;

  Ville({
    this.idVille = 0,
    this.nomVille = '',
  });
  @override
  int get hashCode => idVille.hashCode ^ nomVille.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ville &&
          runtimeType == other.runtimeType &&
          idVille == other.idVille &&
          nomVille == other.nomVille;
  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      idVille: json['id'] ?? 0,
      nomVille: json['nom_ville'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.idVille ?? 0;
    data['nom_ville'] = this.nomVille ?? '';

    return data;
  }
}
