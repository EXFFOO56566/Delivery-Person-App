class Sortable {
  String option_key;
  String name;

  Sortable(this.option_key, this.name);

  static List<Sortable> getDatewiseSortList() {
    return <Sortable>[
      Sortable('', 'All'),
      Sortable('today', 'Today'),
      Sortable('this_week', 'This Week'),
      Sortable('this_month', 'This Month'),

    ];
  }

  static List<Sortable> getPaymentTypeSortList() {
    return <Sortable>[
      Sortable('', 'All'),
      Sortable('cod', 'COD'),
      Sortable('non-cod', 'NON-COD'),
    ];
  }
}

