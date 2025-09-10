#!/usr/bin/env bash
set -euo pipefail

echo "➡︎ Checking Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew not found. Install from https://brew.sh/ and re-run."
  exit 1
fi

echo "➡︎ Installing XcodeGen (if needed)..."
brew list xcodegen >/dev/null 2>&1 || brew install xcodegen

echo "➡︎ Generating Xcode project with XcodeGen..."
xcodegen generate

echo "➡︎ Installing CocoaPods dependencies..."
if ! command -v pod >/dev/null 2>&1; then
  sudo gem install cocoapods
fi
pod install

echo "✅ Done. Open the workspace:"
echo "open VideoAdsServer.xcworkspace"
