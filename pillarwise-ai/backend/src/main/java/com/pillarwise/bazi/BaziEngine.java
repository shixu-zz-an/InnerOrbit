package com.pillarwise.bazi;

import com.pillarwise.profile.BirthProfile;

public interface BaziEngine {
  BaziChart calculate(BirthProfile profile);
}
