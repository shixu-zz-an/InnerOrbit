package com.pillarwise.config;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.sql.Statement;
import java.util.logging.Logger;
import javax.sql.DataSource;
import org.sqlite.SQLiteDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
public class SqliteConfig {
  @Bean
  DataSource dataSource(AppProperties properties) {
    String dbPath = properties.sqlite().path();
    File file = new File(dbPath);
    File parent = file.getParentFile();
    if (parent != null) {
      parent.mkdirs();
    }
    SQLiteDataSource source = new SQLiteDataSource();
    source.setUrl("jdbc:sqlite:" + dbPath);
    return new PragmaDataSource(source);
  }

  @Bean
  JdbcTemplate jdbcTemplate(DataSource dataSource) {
    return new JdbcTemplate(dataSource);
  }

  static final class PragmaDataSource implements DataSource {
    private final SQLiteDataSource delegate;

    PragmaDataSource(SQLiteDataSource delegate) {
      this.delegate = delegate;
    }

    @Override
    public Connection getConnection() throws SQLException {
      return configure(delegate.getConnection());
    }

    @Override
    public Connection getConnection(String username, String password) throws SQLException {
      return configure(delegate.getConnection(username, password));
    }

    private Connection configure(Connection connection) throws SQLException {
      try (Statement statement = connection.createStatement()) {
        statement.execute("PRAGMA foreign_keys = ON");
        statement.execute("PRAGMA journal_mode = WAL");
        statement.execute("PRAGMA busy_timeout = 5000");
      }
      return connection;
    }

    @Override
    public PrintWriter getLogWriter() throws SQLException {
      return delegate.getLogWriter();
    }

    @Override
    public void setLogWriter(PrintWriter out) throws SQLException {
      delegate.setLogWriter(out);
    }

    @Override
    public void setLoginTimeout(int seconds) throws SQLException {
      delegate.setLoginTimeout(seconds);
    }

    @Override
    public int getLoginTimeout() throws SQLException {
      return delegate.getLoginTimeout();
    }

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
      return delegate.getParentLogger();
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
      return delegate.unwrap(iface);
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
      return delegate.isWrapperFor(iface);
    }
  }
}
