package com.pillarwise.journal;

public record JournalEntryRequest(
    String sourceType,
    String sourceId,
    String prompt,
    String content
) {}
