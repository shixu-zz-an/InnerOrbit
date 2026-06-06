package com.pillarwise.profile;

public record BirthProfile(
    String id,
    String userId,
    String name,
    String birthDate,
    String birthTime,
    String birthTimePrecision,
    String birthPlaceText,
    Double latitude,
    Double longitude,
    String timezone,
    String sexForTraditionalCycle,
    boolean trueSolarTimeEnabled,
    boolean primary
) {}
