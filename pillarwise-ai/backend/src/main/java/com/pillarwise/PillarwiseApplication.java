package com.pillarwise;

import com.pillarwise.config.AppProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(AppProperties.class)
public class PillarwiseApplication {
  public static void main(String[] args) {
    SpringApplication.run(PillarwiseApplication.class, args);
  }
}
