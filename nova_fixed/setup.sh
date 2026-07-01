#!/usr/bin/env bash
# Nova — GitHub Codespaces Setup Script
# Handles: Flutter, Java 17, Android SDK, Gradle, APK build
set -e

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║         Nova Setup — Full Build          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── 1. Java 17 ───────────────────────────────────────────────
echo "▶ Checking Java..."
if [ -x /usr/lib/jvm/java-17-openjdk-amd64/bin/java ]; then
  JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
elif [ -x /usr/lib/jvm/java-17-openjdk/bin/java ]; then
  JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
else
  echo "Installing Java 17..."
  sudo apt-get update -qq
  sudo apt-get install -y openjdk-17-jdk
  JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"
echo "✓ Java: $(java -version 2>&1 | head -1)"

# ── 2. Flutter ───────────────────────────────────────────────
FLUTTER_DIR=/home/codespace/flutter
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "▶ Installing Flutter 3.19.x (stable)..."
  git clone https://github.com/flutter/flutter.git \
    -b stable --depth 1 "$FLUTTER_DIR"
fi
export PATH="$PATH:$FLUTTER_DIR/bin"
echo "export PATH=\"\$PATH:$FLUTTER_DIR/bin\"" >> ~/.bashrc
echo "✓ Flutter: $(flutter --version | head -1)"

# ── 3. Android SDK ───────────────────────────────────────────
ANDROID_HOME=/home/codespace/android-sdk
if [ ! -d "$ANDROID_HOME" ]; then
  echo "▶ Installing Android SDK..."
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  cd /tmp
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    -O cmdline-tools.zip
  unzip -q cmdline-tools.zip
  mv cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
fi
export ANDROID_HOME="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc
echo "export PATH=\"\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools\"" >> ~/.bashrc

# Accept licenses & install required packages
yes | sdkmanager --licenses > /dev/null 2>&1 || true
sdkmanager \
  "platform-tools" \
  "platforms;android-34" \
  "build-tools;34.0.0" \
  "ndk;25.1.8937393"
echo "✓ Android SDK ready"

# ── 4. Generate local.properties ─────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
cd "$PROJECT_DIR"
cat > "$PROJECT_DIR/android/local.properties" << PROPS
flutter.sdk=$FLUTTER_DIR
sdk.dir=$ANDROID_HOME
flutter.versionName=1.0.0
flutter.versionCode=1
PROPS
echo "✓ local.properties written"

# ── 5. Flutter create (fills missing boilerplate) ────────────
echo "▶ Filling Flutter boilerplate..."
flutter create . --org com.nova.assistant --project-name nova 2>/dev/null || true

# ── 6. Pull dependencies ─────────────────────────────────────
echo "▶ Running flutter pub get..."
flutter pub get

# ── 7. Flutter doctor ────────────────────────────────────────
flutter doctor --android-licenses 2>/dev/null || true
flutter doctor

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║          Setup Complete! ✓               ║"
echo "╠══════════════════════════════════════════╣"
echo "║  Build debug APK (faster):               ║"
echo "║  flutter build apk --debug               ║"
echo "║                                          ║"
echo "║  Build release APK:                      ║"
echo "║  flutter build apk --release             ║"
echo "║                                          ║"
echo "║  APK location:                           ║"
echo "║  build/app/outputs/flutter-apk/          ║"
echo "╚══════════════════════════════════════════╝"
