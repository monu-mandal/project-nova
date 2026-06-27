#!/usr/bin/env bash
# Nova — GitHub Codespaces Setup Script
# Run once after cloning. Sets up Flutter + Android SDK automatically.
set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║       Nova Setup — Phase 1           ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Flutter ──────────────────────────────────────────────────────────────────
if ! command -v flutter &>/dev/null; then
  echo "▶ Installing Flutter..."
  cd /home/codespace
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
  export PATH="$PATH:/home/codespace/flutter/bin"
  echo 'export PATH="$PATH:/home/codespace/flutter/bin"' >> ~/.bashrc
  echo "✓ Flutter installed"
else
  echo "✓ Flutter already installed"
fi

# ── Java ─────────────────────────────────────────────────────────────────────
if ! command -v java &>/dev/null; then
  echo "▶ Installing Java 17..."
  sudo apt-get install -y openjdk-17-jdk
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
  echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
fi
echo "✓ Java: $(java -version 2>&1 | head -1)"

# ── Android SDK ──────────────────────────────────────────────────────────────
ANDROID_HOME="$HOME/android-sdk"
if [ ! -d "$ANDROID_HOME" ]; then
  echo "▶ Installing Android SDK..."
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  cd /tmp
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  unzip -q commandlinetools-linux-11076708_latest.zip
  mv cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
  export ANDROID_HOME="$ANDROID_HOME"
  export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
  echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc
  echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"' >> ~/.bashrc
  yes | sdkmanager --licenses &>/dev/null
  sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
  echo "✓ Android SDK installed"
else
  echo "✓ Android SDK already installed"
fi

# ── Flutter doctor ────────────────────────────────────────────────────────────
cd /workspaces/nova 2>/dev/null || cd ~/nova 2>/dev/null || true
flutter config --no-analytics
flutter pub get
echo ""
echo "╔══════════════════════════════════════╗"
echo "║       Setup Complete! ✓              ║"
echo "╠══════════════════════════════════════╣"
echo "║  Build APK:                          ║"
echo "║  flutter build apk --release         ║"
echo "╚══════════════════════════════════════╝"
