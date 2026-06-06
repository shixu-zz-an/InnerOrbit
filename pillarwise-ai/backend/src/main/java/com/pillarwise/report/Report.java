package com.pillarwise.report;

import java.util.Map;

public record Report(
    String id,
    String userId,
    String birthProfileId,
    String relationshipProfileId,
    String reportType,
    String status,
    Map<String, Object> freePreview,
    Map<String, Object> fullReport,
    String modelVersion,
    String promptVersion,
    boolean paidRequired,
    boolean unlocked,
    String createdAt,
    String updatedAt
) {}
