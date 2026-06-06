package com.pillarwise.profile;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziEngine;
import com.pillarwise.bazi.BaziRepository;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.common.AppException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class BirthProfileService {
  private final BirthProfileRepository profiles;
  private final BaziEngine baziEngine;
  private final BaziRepository charts;
  private final InsightMapper insightMapper;

  public BirthProfileService(
      BirthProfileRepository profiles,
      BaziEngine baziEngine,
      BaziRepository charts,
      InsightMapper insightMapper
  ) {
    this.profiles = profiles;
    this.baziEngine = baziEngine;
    this.charts = charts;
    this.insightMapper = insightMapper;
  }

  public CreateBirthProfileResult create(String userId, BirthProfileRequest request) {
    validate(request);
    boolean primary = request.isPrimary() == null || request.isPrimary();
    BirthProfile profile = profiles.insert(userId, normalize(request), primary);
    BaziChart chart = baziEngine.calculate(profile);
    charts.save(chart);
    InsightMapper.MappedInsight insight = insightMapper.map(chart);
    return new CreateBirthProfileResult(profile, chart, insight);
  }

  public CreateBirthProfileResult createSecondary(String userId, BirthProfileRequest request) {
    validate(request);
    BirthProfile profile = profiles.insert(userId, normalize(request), false);
    BaziChart chart = baziEngine.calculate(profile);
    charts.save(chart);
    return new CreateBirthProfileResult(profile, chart, insightMapper.map(chart));
  }

  public BirthProfile primary(String userId) {
    return profiles.findPrimaryByUser(userId).orElseThrow(() -> AppException.notFound("Create your blueprint first."));
  }

  public List<BirthProfile> all(String userId) {
    return profiles.findAllByUser(userId);
  }

  public void delete(String userId, String id) {
    profiles.deleteForUser(id, userId);
  }

  private static BirthProfileRequest normalize(BirthProfileRequest request) {
    String precision = request.birthTimePrecision() == null || request.birthTimePrecision().isBlank()
        ? "unknown"
        : request.birthTimePrecision();
    String birthTime = "unknown".equals(precision) ? null : request.birthTime();
    return new BirthProfileRequest(
        request.name(),
        request.birthDate(),
        birthTime,
        precision,
        request.birthPlaceText(),
        request.latitude(),
        request.longitude(),
        request.timezone(),
        request.sexForTraditionalCycle(),
        request.trueSolarTimeEnabled(),
        request.isPrimary()
    );
  }

  private static void validate(BirthProfileRequest request) {
    Map<String, Object> errors = new LinkedHashMap<>();
    LocalDate birthDate = null;
    if (request.birthDate() == null || request.birthDate().isBlank()) {
      errors.put("birthDate", "Please choose your birth date.");
    } else {
      try {
        birthDate = LocalDate.parse(request.birthDate());
        if (birthDate.isAfter(LocalDate.now())) {
          errors.put("birthDate", "Birth date can’t be in the future.");
        }
        if (birthDate.isBefore(LocalDate.of(1900, 1, 1))) {
          errors.put("birthDate", "Please choose a date after 1900.");
        }
      } catch (Exception ex) {
        errors.put("birthDate", "Use YYYY-MM-DD.");
      }
    }
    String precision = request.birthTimePrecision();
    if (precision == null || precision.isBlank()) {
      errors.put("birthTimePrecision", "Please choose a birth time option.");
    } else if (!List.of("exact", "approximate", "unknown").contains(precision)) {
      errors.put("birthTimePrecision", "Birth time precision is invalid.");
    } else if (!precision.equals("unknown")) {
      if (request.birthTime() == null || request.birthTime().isBlank()) {
        errors.put("birthTime", "Please choose a birth time or select “I don’t know.”");
      } else {
        try {
          LocalTime.parse(request.birthTime());
        } catch (Exception ex) {
          errors.put("birthTime", "Use HH:mm.");
        }
      }
    }
    if (request.birthPlaceText() == null || request.birthPlaceText().isBlank()) {
      errors.put("birthPlaceText", "Please enter your birthplace.");
    }
    if (request.timezone() == null || request.timezone().isBlank()) {
      errors.put("timezone", "Please choose a timezone.");
    } else {
      try {
        ZoneId.of(request.timezone());
      } catch (Exception ex) {
        errors.put("timezone", "Timezone is invalid.");
      }
    }
    if (request.latitude() != null && (request.latitude() < -90 || request.latitude() > 90)) {
      errors.put("latitude", "Latitude is invalid.");
    }
    if (request.longitude() != null && (request.longitude() < -180 || request.longitude() > 180)) {
      errors.put("longitude", "Longitude is invalid.");
    }
    if (!errors.isEmpty()) {
      throw AppException.validation("Check your birth details.", errors);
    }
  }

  public record CreateBirthProfileResult(
      BirthProfile profile,
      BaziChart chart,
      InsightMapper.MappedInsight insight
  ) {}
}
