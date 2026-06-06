package com.pillarwise.auth;

public record CurrentUser(
    String id,
    String locale,
    String displayName
) {}
