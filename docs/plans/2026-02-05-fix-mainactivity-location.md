# MainActivity.kt 包名路径修复计划

**目标：** 将 MainActivity.kt 从旧包名路径移动到新包名路径，并更新包名声明

**架构说明：** 包名从 `com.example.investment_app` 改为 `com.investment.permanentportfolio` 后，MainActivity.kt 仍在旧目录下，需要移动并更新包名声明

**技术栈：** Kotlin, Flutter Android

---

## 任务 1：创建新包名目录并移动 MainActivity.kt

**文件：**
- 移动: `android/app/src/main/kotlin/com/example/investment_app/MainActivity.kt`
- 到: `android/app/src/main/kotlin/com/investment/permanentportfolio/MainActivity.kt`

**步骤 1：创建新目录**

```bash
mkdir -p android/app/src/main/kotlin/com/investment/permanentportfolio
```

**步骤 2：更新文件内容（包名声明）**

```kotlin
package com.investment.permanentportfolio

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
```

**步骤 3：删除旧文件**

```bash
rm android/app/src/main/kotlin/com/example/investment_app/MainActivity.kt
```

**步骤 4：删除旧空目录**

```bash
rmdir android/app/src/main/kotlin/com/example/investment_app
rmdir android/app/src/main/kotlin/com/example
```

**步骤 5：清理并重新构建**

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

**步骤 6：提交更改**

```bash
git add -A
git commit -m "fix(android): move MainActivity.kt to correct package path"
```

---

**注意：** 由于包名已更改，无法覆盖安装，需要先卸载手机上的旧版本应用再安装新版本。
