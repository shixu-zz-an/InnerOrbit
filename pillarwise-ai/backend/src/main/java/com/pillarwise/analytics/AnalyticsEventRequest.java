package com.pillarwise.analytics;

import java.util.Map;

public record AnalyticsEventRequest(
    String eventName,
    Map<String, Object> properties
) {}
