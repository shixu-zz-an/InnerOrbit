package com.pillarwise.settings;

import com.pillarwise.auth.AuthService;
import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Jsons;
import com.pillarwise.profile.BirthProfileDtos;
import com.pillarwise.profile.BirthProfileRepository;
import com.pillarwise.report.ReportDtos;
import com.pillarwise.report.ReportRepository;
import com.pillarwise.subscription.EntitlementService;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class MeService {
  private final JdbcTemplate jdbcTemplate;
  private final BirthProfileRepository birthProfiles;
  private final ReportRepository reports;
  private final EntitlementService entitlementService;
  private final AuthService authService;
  private final Jsons jsons;

  public MeService(
      JdbcTemplate jdbcTemplate,
      BirthProfileRepository birthProfiles,
      ReportRepository reports,
      EntitlementService entitlementService,
      AuthService authService,
      Jsons jsons
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.birthProfiles = birthProfiles;
    this.reports = reports;
    this.entitlementService = entitlementService;
    this.authService = authService;
    this.jsons = jsons;
  }

  public Map<String, Object> me(CurrentUser user) {
    Map<String, Object> map = new LinkedHashMap<>();
    map.put("id", user.id());
    map.put("email", null);
    map.put("displayName", user.displayName());
    map.put("locale", user.locale());
    map.put("hasPrimaryBirthProfile", birthProfiles.findPrimaryByUser(user.id()).isPresent());
    map.put("entitlement", entitlementService.current(user.id()).toMap());
    return map;
  }

  public Map<String, Object> export(CurrentUser user) {
    List<Map<String, Object>> conversations = jdbcTemplate.query(
        "SELECT * FROM conversations WHERE user_id = ? ORDER BY created_at DESC",
        (rs, rowNum) -> {
          Map<String, Object> map = new LinkedHashMap<>();
          String id = rs.getString("id");
          map.put("id", id);
          map.put("topic", rs.getString("topic"));
          map.put("createdAt", rs.getString("created_at"));
          map.put("messages", messages(id));
          return map;
        },
        user.id()
    );
    return Map.of(
        "user", me(user),
        "birthProfiles", birthProfiles.findAllByUser(user.id()).stream().map(BirthProfileDtos::summary).toList(),
        "reports", reports.listByUser(user.id()).stream().map(ReportDtos::response).toList(),
        "journalEntries", jdbcTemplate.queryForList("SELECT id, source_type, prompt, content, created_at FROM journal_entries WHERE user_id = ?", user.id()),
        "conversations", conversations
    );
  }

  public Map<String, Object> delete(CurrentUser user, DeleteAccountRequest request) {
    if (request == null || !"DELETE".equals(request.confirmation())) {
      throw AppException.validation("Type DELETE to confirm.", Map.of("confirmation", "Type DELETE to confirm."));
    }
    authService.clearSessions(user.id());
    jdbcTemplate.update("DELETE FROM users WHERE id = ?", user.id());
    return Map.of("deleted", true);
  }

  private List<Map<String, Object>> messages(String conversationId) {
    return jdbcTemplate.query(
        "SELECT role, content, answer_json, safety_label, created_at FROM messages WHERE conversation_id = ? ORDER BY created_at",
        (rs, rowNum) -> {
          Map<String, Object> map = new LinkedHashMap<>();
          map.put("role", rs.getString("role"));
          map.put("content", rs.getString("content"));
          map.put("answer", jsons.readMap(rs.getString("answer_json")));
          map.put("safetyLabel", rs.getString("safety_label"));
          map.put("createdAt", rs.getString("created_at"));
          return map;
        },
        conversationId
    );
  }
}
