class BillingWorkbenchPageState {
  final int currentPage;
  final int rowsPerPage;
  final int totalItems;

  const BillingWorkbenchPageState({
    required this.currentPage,
    required this.rowsPerPage,
    required this.totalItems,
  });

  int get totalPages {
    if (totalItems <= 0) {
      return 1;
    }

    final pages = (totalItems / rowsPerPage).ceil();
    return pages <= 0 ? 1 : pages;
  }

  int get safeCurrentPage {
    if (currentPage < 1) {
      return 1;
    }

    if (currentPage > totalPages) {
      return totalPages;
    }

    return currentPage;
  }

  int get startIndex {
    if (totalItems == 0) {
      return 0;
    }

    return (safeCurrentPage - 1) * rowsPerPage;
  }

  int get endIndexExclusive {
    final candidate = startIndex + rowsPerPage;
    return candidate > totalItems ? totalItems : candidate;
  }

  int get visibleFrom {
    if (totalItems == 0) {
      return 0;
    }

    return startIndex + 1;
  }

  int get visibleTo {
    if (totalItems == 0) {
      return 0;
    }

    return endIndexExclusive;
  }

  BillingWorkbenchPageState copyWith({
    int? currentPage,
    int? rowsPerPage,
    int? totalItems,
  }) {
    return BillingWorkbenchPageState(
      currentPage: currentPage ?? this.currentPage,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  BillingWorkbenchPageState normalizedForTotalItems(int nextTotalItems) {
    return BillingWorkbenchPageState(
      currentPage: currentPage,
      rowsPerPage: rowsPerPage,
      totalItems: nextTotalItems,
    ).copyWith(
      currentPage: BillingWorkbenchPageState(
        currentPage: currentPage,
        rowsPerPage: rowsPerPage,
        totalItems: nextTotalItems,
      ).safeCurrentPage,
      totalItems: nextTotalItems,
    );
  }
}
