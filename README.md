# amir0zx.github.io

This repo hosts the **GitHub Pages** site for amir0zx.

- Flutter app source: `app/`
- Build output is copied to repo root for Pages.

## Build

```bash
export PATH=~/.local/flutter-sdk/bin:$PATH
cd app
flutter pub get
flutter build web --release --base-href /
cp -a build/web/* ..
```
