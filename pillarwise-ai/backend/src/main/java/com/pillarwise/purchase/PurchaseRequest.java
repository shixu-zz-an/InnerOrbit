package com.pillarwise.purchase;

public record PurchaseRequest(
    String productId,
    String reportId
) {}
