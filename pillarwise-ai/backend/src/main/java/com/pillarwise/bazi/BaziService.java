package com.pillarwise.bazi;

import com.pillarwise.common.AppException;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import org.springframework.stereotype.Service;

@Service
public class BaziService {
  private final BirthProfileRepository birthProfiles;
  private final BaziRepository charts;

  public BaziService(BirthProfileRepository birthProfiles, BaziRepository charts) {
    this.birthProfiles = birthProfiles;
    this.charts = charts;
  }

  public BaziChart chartForUser(String userId, String birthProfileId) {
    BirthProfile profile = birthProfiles.findByIdForUser(birthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    return charts.findLatestByBirthProfileId(profile.id())
        .orElseThrow(() -> AppException.notFound("Chart was not found."));
  }
}
