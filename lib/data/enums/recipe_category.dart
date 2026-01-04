enum RecipeCategory {
  appetizer(1, "Appetizer"),
  breakfast(2, "Breakfast"),
  dessert(3, "Dessert"),
  drink(4, "Drink"),
  mainDish(5, "Main Dish"),
  pastry(6, "Pastry"),
  salad(7, "Salad"),
  sideDish(8, "Side Dish"),
  soup(9, "Soup"),
  snack(10, "Snack"),
  other(11, "Other");

  const RecipeCategory(this.value, this.label);
  final int value;
  final String label;

  static RecipeCategory fromValue(int value) {
    return RecipeCategory.values.firstWhere(
      (element) => element.value == value,
      orElse: () => RecipeCategory.other,
    );
  }
}
