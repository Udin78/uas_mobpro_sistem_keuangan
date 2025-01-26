
class BudgetPlanningModel {
  String? id;
  double? budget;
  String? semester;

  BudgetPlanningModel({this.id, this.budget, this.semester});

  factory BudgetPlanningModel.fromMap(Map<String, dynamic> map) {
    return BudgetPlanningModel(
      id: map['id'],
      budget: map['budget'],
      semester: map['semester'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budget': budget,
      'semester': semester,
    };
  }
}
