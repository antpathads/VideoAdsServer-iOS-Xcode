# AntPath Ads — iOS (AVPlayer + Google IMA) — XcodeGen + CocoaPods

This repo ships **sources + `project.yml` (XcodeGen)** and a **Podfile**.
Run the bootstrap script to generate a valid **.xcodeproj** on your Mac and install IMA.

## Quick Start
```bash
cd VideoAdsServer-iOS-XcodeGen
./bootstrap.sh
open VideoAdsServer.xcworkspace
```

If `bootstrap.sh` isn't executable:
```bash
chmod +x bootstrap.sh
```

## What it does
1) Uses **XcodeGen** to generate `VideoAdsServer.xcodeproj` from `project.yml`.
2) Runs **CocoaPods** to install `GoogleAds-IMA-iOS-SDK` and creates `VideoAdsServer.xcworkspace`.
3) Open the workspace and run on simulator/device.

### Content & Tags
- Content: https://adserver.antpathads.com/videotest/videotest.mp4
- Pre: zoneid=1
- Mid: zoneid=2
- Post: zoneid=3
