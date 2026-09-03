#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="${TMPDIR:-/tmp}/flutter-sdk"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter config --enable-web --no-analytics
flutter pub get
flutter analyze
flutter test
flutter build web --release
