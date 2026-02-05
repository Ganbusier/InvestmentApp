# 应用名称与包名修改实现计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**目标：** 将应用名称从 "Investment App" 改为 "永久投资组合模拟器"，包名从 `com.example.investment_app` 改为 `com.investment.permanentportfolio`

**架构说明：** 需要修改 Flutter 项目中所有涉及应用名称和包名的配置文件，包括 pubspec.yaml、Android Gradle 配置、AndroidManifest、iOS Info.plist 和 Xcode 项目文件

**技术栈：** Flutter, Gradle Kotlin DSL, Xcode

---

## 修改汇总

| 文件 | 当前值 | 新值 |
|------|--------|------|
| `pubspec.yaml:1` | `name: investment_app` | `name: permanent_portfolio` |
| `pubspec.yaml:2` | `description: 永久投资组合理财App` | `description: 永久投资组合模拟器` |
| `android/app/build.gradle.kts:9` | `namespace = "com.example.investment_app"` | `namespace = "com.investment.permanentportfolio"` |
| `android/app/build.gradle.kts:24` | `applicationId = "com.example.investment_app"` | `applicationId = "com.investment.permanentportfolio"` |
| `android/app/src/main/AndroidManifest.xml:3` | `android:label="investment_app"` | `android:label="永久投资组合模拟器"` |
| `ios/Runner/Info.plist:8` | `Investment App` | `永久投资组合模拟器` |
| `ios/Runner/Info.plist:16` | `investment_app` | `permanent_portfolio` |
| `ios/Runner.xcodeproj/project.pbxproj:371` | `com.example.investmentApp` | `com.investment.permanentportfolio` |

---

## 任务 1：修改 pubspec.yaml

**文件：**
- 修改: `pubspec.yaml:1-2`

**步骤 1：修改包名和描述**

```yaml
name: permanent_portfolio
description: 永久投资组合模拟器
```

**步骤 2：运行 flutter pub get**

```bash
flutter pub get
```

**步骤 3：验证修改**

```bash
flutter analyze
```

**步骤 4：提交更改**

```bash
git add pubspec.yaml
git commit -m "rename: change app name to 永久投资组合模拟器 and package name to permanent_portfolio"
```

---

## 任务 2：修改 Android 配置

**文件：**
- 修改: `android/app/build.gradle.kts:9,24`
- 修改: `android/app/src/main/AndroidManifest.xml:3`

**步骤 1：修改 namespace 和 applicationId**

```kotlin
// android/app/build.gradle.kts 第9行
namespace = "com.investment.permanentportfolio"

// android/app/build.gradle.kts 第24行
applicationId = "com.investment.permanentportfolio"
```

**步骤 2：修改 AndroidManifest label**

```xml
<!-- android/app/src/main/AndroidManifest.xml 第3行 -->
android:label="永久投资组合模拟器"
```

**步骤 3：运行 flutter clean && flutter pub get**

```bash
flutter clean
flutter pub get
```

**步骤 4：验证 Android 配置**

```bash
flutter build apk --debug
```

**步骤 5：提交更改**

```bash
git add android/app/build.gradle.kts android/app/src/main/AndroidManifest.xml
git commit -m "feat(android): update namespace and applicationId to com.investment.permanentportfolio"
```

---

## 任务 3：修改 iOS 配置

**文件：**
- 修改: `ios/Runner/Info.plist:8,16`
- 修改: `ios/Runner.xcodeproj/project.pbxproj:371`

**步骤 1：修改 Info.plist**

```xml
<!-- ios/Runner/Info.plist 第8行 -->
<string>永久投资组合模拟器</string>

<!-- ios/Runner/Info.plist 第16行 -->
<string>permanent_portfolio</string>
```

**步骤 2：修改 Xcode 项目文件**

```bash
# 使用 sed 修改或手动编辑
# 第371行: PRODUCT_BUNDLE_IDENTIFIER = com.example.investmentApp;
# 改为: PRODUCT_BUNDLE_IDENTIFIER = com.investment.permanentportfolio;
```

**步骤 3：运行 flutter clean && flutter pub get**

```bash
flutter clean
flutter pub get
```

**步骤 4：验证 iOS 配置**

```bash
flutter build ios --debug --no-codesign
```

**步骤 5：提交更改**

```bash
git add ios/Runner/Info.plist ios/Runner.xcodeproj/project.pbxproj
git commit -m "feat(ios): update bundle name and display name to 永久投资组合模拟器"
```

---

## 任务 4：清理和验证

**步骤 1：清理构建产物**

```bash
flutter clean
flutter pub get
```

**步骤 2：完整验证**

```bash
flutter analyze
flutter test
```

**步骤 3：运行应用测试**

启动应用确认：
- Android 桌面图标下显示"永久投资组合模拟器"
- iOS 桌面图标下显示"永久投资组合模拟器"
- 应用内标题正确显示

**步骤 4：提交最终更改**

```bash
git add .
git commit -m "chore: finalize app rename to 永久投资组合模拟器"
```

---

## 风险提示

1. **包名变更后无法覆盖安装**：修改 applicationId 后，商店中的旧版本将无法被覆盖安装，需要先卸载旧版本
2. **Hive 数据迁移**：如果使用了 Hive 存储，包名变更后本地数据可能无法访问（可在应用内添加数据迁移逻辑）
3. **Xcode 项目修改**：`project.pbxproj` 修改后可能需要重新打开 Xcode

---

**计划已完成并保存到：** `docs/plans/2026-02-05-app-rename.md`

**确认事项：**
- 新显示名称：**永久投资组合模拟器**
- 新包名：**com.investment.permanentportfolio**
- 新 Dart 包名：**permanent_portfolio**
