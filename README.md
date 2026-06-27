# Nova — Furina AI Assistant

> *"The Hydro Archon assists no one... except perhaps you."*

Nova is a fully offline Android AI assistant. She looks, sounds, and moves like Furina from Genshin Impact. She floats over your screen, listens for your voice, and controls your entire phone.

---

## Quick Start (GitHub Codespaces)

### 1. Open in Codespaces
Fork this repo → Code → Codespaces → New codespace

### 2. Run setup
```bash
chmod +x setup.sh && ./setup.sh
```
This installs Flutter, Android SDK, and all dependencies automatically.

### 3. Build APK
```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Project Structure

```
nova/
├── lib/
│   ├── main.dart                    # Entry point (app + overlay modes)
│   ├── core/
│   │   ├── llm/                     # Local LLM (GGUF via llama.cpp)
│   │   ├── memory/                  # SQLite memory system
│   │   ├── intent/                  # Command router
│   │   └── voice/                   # STT + TTS + RVC voice
│   ├── features/
│   │   ├── overlay/                 # Furina floating widget
│   │   ├── commands/                # All command executors
│   │   └── learning/                # Pattern learning system
│   ├── services/
│   │   ├── android/                 # App control, system APIs
│   │   ├── connectivity/            # WiFi / data detection
│   │   └── media/                   # Music, playback
│   └── ui/
│       ├── theme/                   # Nova visual identity
│       ├── screens/                 # Home + overlay screens
│       └── widgets/                 # Chat bubbles, input bar
├── assets/
│   ├── sprites/                     # Furina sprite sheets (Phase 3)
│   ├── audio/                       # Voice clips (Phase 4)
│   ├── models/                      # GGUF model (Phase 4)
│   └── memory/                      # Default memory seeds
└── android/
    └── app/src/main/
        ├── AndroidManifest.xml      # All permissions declared
        └── kotlin/com/nova/         # Native Android code
```

---

## Build Phases

| Phase | Status | What |
|-------|--------|------|
| 1 | ✅ Done | Project structure, core architecture |
| 2 | 🔲 Next | Android overlay, Furina on screen |
| 3 | 🔲 | Sprite animation system |
| 4 | 🔲 | Wake word + voice recognition |
| 5 | 🔲 | Local LLM + Furina personality |
| 6 | 🔲 | Voice output (Piper + RVC) |
| 7 | 🔲 | Full command set (WiFi, BT, calls...) |
| 8 | 🔲 | Online/offline routing |
| 9 | 🔲 | Learning system |
| 10 | 🔲 | Polish + lip sync |

---

## Wake / Hide

| You say | Nova does |
|---------|-----------|
| `Nova` | Appears on screen with entrance animation |
| `Nova hide` | Exits screen, runs silently in background |
| `Nova play Run Rabbit` | Opens Spotify (online) or local music (offline) |
| `Nova call Mom` | Dials from contacts |
| `Nova turn on WiFi` | Enables WiFi |

---

## Credits
Inspired by Maid-chan (Ryunosuke Akasaka).
Furina design © HoYoverse — fan project, not affiliated.
