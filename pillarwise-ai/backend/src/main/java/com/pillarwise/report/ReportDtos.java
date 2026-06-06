package com.pillarwise.report;

import java.util.List;
import java.util.Map;

public final class ReportDtos {
  private ReportDtos() {}

  public static Map<String, Object> response(Report report) {
    return Map.of(
        "reportId", report.id(),
        "reportType", report.reportType(),
        "unlocked", report.unlocked(),
        "preview", report.freePreview(),
        "fullReport", report.fullReport() == null ? Map.of() : report.fullReport(),
        "lockedSections", report.unlocked() ? List.of() : List.of("career", "love", "timeline")
    );
  }

  public static Map<String, Object> listItem(Report report) {
    return Map.of(
        "id", report.id(),
        "reportType", report.reportType(),
        "unlocked", report.unlocked(),
        "createdAt", report.createdAt(),
        "title", report.reportType().equals("life_blueprint") ? "Life Blueprint" : "Relationship Report"
    );
  }
}
