package com.pillarwise.relationship;

public record RelationshipRequest(
    String targetName,
    String relationshipType,
    String birthDate,
    String birthTime,
    String birthTimePrecision,
    String birthPlaceText,
    Double latitude,
    Double longitude,
    String timezone
) {}
