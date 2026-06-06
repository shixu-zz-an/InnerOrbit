#!/usr/bin/env bash
set -euo pipefail

(cd backend && ./mvnw test)
(cd app && flutter analyze && flutter test)
