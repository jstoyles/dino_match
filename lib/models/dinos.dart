class dinos {
  final int dino;
  bool selected;
  bool matched;
  bool show;

  dinos ({
    required this.dino,
    required this.selected,
    required this.matched,
    required this.show
  });

  factory dinos.fromJson(Map<String, dynamic> json) {
    return dinos(
        dino: json['dino'],
        selected: json['selected'],
        matched: json['matched'],
        show: json['show']
    );
  }
}