package com.pillarwise.bazi;

import com.pillarwise.common.AppException;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import org.springframework.stereotype.Service;

@Service
public class BaziService {
  private final BirthProfileRepository birthProfiles;
  private final BaziRepository charts;
  private final BaziEngine baziEngine;

  public BaziService(BirthProfileRepository birthProfiles, BaziRepository charts, BaziEngine baziEngine) {
    this.birthProfiles = birthProfiles;
    this.charts = charts;
    this.baziEngine = baziEngine;
  }

  public BaziChart chartForUser(String userId, String birthProfileId) {
    BirthProfile profile = birthProfiles.findByIdForUser(birthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    return chartForProfile(profile);
  }

  public BaziChart chartForProfile(BirthProfile profile) {
    BaziChart latest = charts.findLatestByBirthProfileId(profile.id()).orElse(null);
    if (latest != null && baziEngine.calcVersion().equals(latest.calcVersion())) {
      return latest;
    }
    BaziChart recalculated = baziEngine.calculate(profile);
    charts.save(recalculated);
    return recalculated;
  }

  public BaziChart chartForUserProfile(String userId, String birthProfileId) {
    BirthProfile profile = birthProfiles.findByIdForUser(birthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    return chartForProfile(profile);
  }

  public BaziChart chartForUserPrimary(String userId) {
    BirthProfile profile = birthProfiles.findPrimaryByUser(userId)
        .orElseThrow(() -> AppException.notFound("Create your blueprint first."));
    return charts.findLatestByBirthProfileId(profile.id())
        .filter(chart -> baziEngine.calcVersion().equals(chart.calcVersion()))
        .orElseGet(() -> chartForProfile(profile));
  }
}
