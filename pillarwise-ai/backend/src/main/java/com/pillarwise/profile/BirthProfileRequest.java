package com.pillarwise.profile;

public record BirthProfileRequest(
    String name,
    String birthDate,
    String birthTime,
    String birthTimePrecision,
    String birthPlaceText,
    Double latitude,
    Double longitude,
    String timezone,
    String sexForTraditionalCycle,
    Boolean trueSolarTimeEnabled,
    Boolean isPrimary
) {}
