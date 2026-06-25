# USB v1 演示脚本

## 1. 演示目标

展示 Windows 本地后端通过 USB ADB 控制真实 Android 手机，手机 App 通过 `adb reverse` 访问本地服务并执行 Real 模式任务。

推荐任务：

```text
打开设置查看WLAN
```

也可以演示：

```text
打开美团搜索蜜雪冰城
```

## 2. 演示前准备

1. Windows 电脑已安装 Python 依赖。
2. 手机开启开发者选项和 USB 调试。
3. 手机用 USB 数据线连接电脑。
4. 执行 `server/start_server.bat`，后端保持运行。
5. 执行 `server/connect_phone.bat`，确认 `adb devices` 有设备，且 `adb reverse` 设置成功。
6. 手机 App 服务器地址填写 `http://127.0.0.1:8000`。

## 3. 录屏建议

建议视频文件名：

```text
demo/demo_usb_v1.mp4
```

录屏画面建议包含：

1. PowerShell / CMD 中后端已启动。
2. `adb devices` 能看到手机。
3. App 输入任务。
4. 点击连接测试。
5. 选择 Real 模式。
6. 展示真实手机被自动操作。
7. 展示 App Trace 和最终结果。

## 4. 答辩讲解顺序

### 项目一句话

这是项目第一版，用电脑运行后端，通过 USB ADB 控制真实手机，并在手机 App 中查看任务执行过程。

### 架构说明

```text
App → adb reverse → 本地 FastAPI → Open-AutoGLM PhoneAgent → USB ADB → Android 手机
```

### 关键亮点

- 先跑通真实手机 Agent 闭环。
- App 不是只做界面，而是真的能发任务给后端。
- 后端调用 Open-AutoGLM，不重写 Agent 核心。
- Trace 能展示 Agent 的观察、思考和动作。

## 5. 视频说明文字

> 本视频展示 AutoGLM Mobile Copilot USB 第一版。Windows 电脑运行 FastAPI 后端，通过 USB ADB 连接真实 Android 手机；手机 App 通过 `adb reverse` 访问本地服务，并在 Real 模式下调用 Open-AutoGLM Phone Agent 完成任务。
