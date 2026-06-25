# AutoGLM Mobile Copilot USB v1

> 基于 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 的手机 AI Agent **USB 本地第一版**。  
> Windows 电脑跑 FastAPI 后端，USB ADB 控制真实 Android 手机，App 通过 `adb reverse` 访问 `http://127.0.0.1:8000`。

**📌 给面试官：** 这是三个版本里**最贴近官方 USB 作业要求**的主展示仓库。  
**📖 系列总览：** [SERIES.md](SERIES.md)（三版导航 · 演进路线 · 全部 Demo 链接）  
**📖 本仓库：** [作业对照与面试官导读](docs/作业对照与面试官导读.md) · [phone_agent 目录对照](docs/phone_agent-目录对照.md) · [架构说明](docs/architecture.md)

---

## 系列项目一览

| 版本 | GitHub 仓库 | 部署方式 | 定位 |
| --- | --- | --- | --- |
| **USB v1（本仓库 · 主入口）** | [USB-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot) | USB 线 + 电脑本地后端 | ✅ **作业主交付**，最稳定 |
| WiFi v1 | [WIFI-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot) | 同 WiFi 无线 ADB | ✅ 官方「远程调试」章节 |
| Cloud（投入时间最多） | [CLOUD-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot) | 云 Docker + Tailscale | ⭐ 工程进阶 / 面试亮点 |

> Cloud 版花费时间最长，但 **USB 仍建议作为主仓库**：最贴 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 作业验收。面试时可说：「作业看 USB，工程深度看 Cloud。」

---

## 1. 项目定位
这是 **AutoGLM Mobile Copilot 的 USB 本地第一版**。

本仓库只聚焦 USB 本地运行。WiFi 版见 [WIFI-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot)，云端版见 [CLOUD-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot)。

USB v1 的价值：

- 跑通真实 Android 手机控制闭环。
- 验证 App → FastAPI → Open-AutoGLM → ADB → 手机 的基本链路。
- 作为后续云端版的第一阶段原型。

## 2. 项目背景

Open-AutoGLM 官方项目提供 Phone Agent CLI。本项目第一版先用最稳定、最容易调试的 USB 方式接入真实手机：

1. Windows 电脑运行 FastAPI 后端。
2. 手机通过 USB 连接电脑。
3. `adb reverse` 让手机 App 访问电脑本地服务。
4. 后端调用 Open-AutoGLM，并通过 USB ADB 控制手机。

## 3. 核心功能

| 功能 | 说明 |
| --- | --- |
| 手机 App 控制端 | 输入任务、配置本地地址、选择 Mock/Real、查看 Trace |
| FastAPI 任务服务 | 提供 `/health`、`/devices`、`/tasks`、`/tasks/{id}/trace` |
| Open-AutoGLM 集成 | 后端通过 subprocess 调用 `Open-AutoGLM/main.py` |
| USB ADB 控制 | 电脑通过 USB 调试控制真实 Android 手机 |
| adb reverse | 手机 App 访问 `http://127.0.0.1:8000` 时转发到电脑后端 |
| 结构化 Trace | 展示 Observe / Think / Action / Result |
| Mock / Real 双模式 | Mock 用于 UI 联调；Real 调用真实 Agent |

## 4. 系统架构

```text
Android App
  输入任务 / 展示 Trace
        ↓ http://127.0.0.1:8000
ADB reverse
        ↓
Windows PC FastAPI Server
        ↓ subprocess
Open-AutoGLM PhoneAgent
        ↓ USB ADB
真实 Android 手机
```

建议补充图片：

```text
assets/architecture-usb.png
assets/app-home-usb.png
assets/usb-demo-result.png
```

## 5. 项目结构

```text
autoglm-mobile-copilot-usb-v1/
├── README.md
├── SERIES.md                  # 三版系列总导航（建议老师/面试官先看）
├── NOTICE.md
├── .gitignore
├── ADBKeyboard.apk
├── Open-AutoGLM/              # 官方 Phone Agent 代码与本项目补丁
├── server/                    # FastAPI 封装层
│   ├── main.py
│   ├── requirements.txt
│   ├── start_server.bat       # 启动本地后端
│   ├── connect_phone.bat      # USB 设备检查与 adb reverse
│   ├── connect_phone_wifi.bat # 可选 WiFi 调试脚本
│   └── .env.example
├── mobile-app/                # 手机控制端 App
├── docs/
│   ├── 作业对照与面试官导读.md
│   ├── architecture.md
│   ├── demo-script.md
│   ├── faq.md
│   └── vibe-coding-log.md
├── assets/                    # 架构图、App 截图、运行结果截图
├── demo/                      # USB 第一版演示视频
├── dist/                      # APK 构建产物占位
└── releases/                  # Release 附件占位
```

## 6. 实现逻辑

```text
App POST /tasks
  → adb reverse 转发到电脑 localhost:8000
  → server/main.py 创建任务
  → 检查 BIGMODEL_API_KEY、Open-AutoGLM 路径、USB ADB 设备
  → 可选 prepare_device：唤醒、解锁、回桌面
  → subprocess 启动 Open-AutoGLM/main.py
  → PhoneAgent.run(task)
      → 截图当前手机屏幕
      → 调用智谱 autoglm-phone 理解界面并生成动作
      → handler.py 执行 Launch / Tap / Type / Swipe 等动作
      → 再次截图进入下一轮
  → server 清洗日志为结构化 Trace
  → App 轮询任务状态并展示结果
```

一句话概括：

> USB v1 让电脑作为 Agent 后端，通过 USB ADB 控制真实手机，手机 App 使用 `adb reverse` 访问电脑本地服务。

## 7. 运行条件

| 条件 | 说明 |
| --- | --- |
| Windows 电脑 | 必须运行 FastAPI 后端 |
| PowerShell / CMD | 需要保持 `start_server.bat` 窗口开启 |
| Python 环境 | 用于运行后端和 Open-AutoGLM |
| Android 手机 | 开启开发者选项与 USB 调试 |
| USB 数据线 | 连接电脑与手机 |
| ADB / platform-tools | 用于连接手机和执行操作 |
| 智谱 API Key | 用于调用 `autoglm-phone` |
| ADB Keyboard | 建议安装，提升中文输入稳定性 |

USB v1 **不需要云服务器、不需要 Docker、不需要 Tailscale**。

## 8. 快速开始

### 8.1 配置环境变量

复制：

```text
server/.env.example → server/.env
```

填写：

```text
BIGMODEL_API_KEY=你的智谱APIKey
AUTOGLM_WORK_ROOT=你的项目路径
ADB_PATH=你的adb.exe路径
```

### 8.2 启动本地后端

```cmd
server\start_server.bat
```

保持窗口不要关闭。

### 8.3 连接手机并设置转发

```cmd
server\connect_phone.bat
```

或手动执行：

```cmd
adb devices
adb reverse tcp:8000 tcp:8000
```

### 8.4 App 配置

手机 App 中填写服务器地址：

```text
http://127.0.0.1:8000
```

然后点击连接测试，选择 Real 模式执行任务。

## 9. 推荐演示任务

```text
打开设置查看WLAN
打开美团搜索蜜雪冰城
打开浏览器搜索 Open-AutoGLM
```

演示时建议先从“打开设置查看 WLAN”开始，因为它依赖少、稳定性高。

## 10. Demo Video（演示视频）

本项目包含真实设备任务执行的录屏演示，视频托管在 **GitHub Releases**（避免大文件进入 git 历史）。

- **USB v1 Demo：** [观看 / 下载演示视频](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/releases)

视频内容包含：

- 本地后端启动（`start_server.bat`）
- USB 连接与 `adb reverse` 设置
- 手机 App 提交任务（Real 模式）
- 真实 Android 手机自动操作
- Agent Trace 与最终结果

**全系列 Demo 汇总：** [SERIES.md → Demo 演示视频](SERIES.md#demo-演示视频)

<!-- 上传 Release 后，可将上方链接改为具体资产，例如：
- [USB v1 Demo](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/releases/download/v1.0-demo/demo_usb_v1.mp4)
-->

### 截图（可选）

```text
assets/architecture-usb.png
assets/app-home-usb.png
assets/trace-view-usb.png
```

## 11. phone_agent 目录对照

本仓库保留官方 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 的 `phone_agent/` 内核结构，在其上扩展 `server/` 与 `mobile-app/`。

详细对照表（官方结构 + 本项目扩展 + 调用关系图）→ **[docs/phone_agent-目录对照.md](docs/phone_agent-目录对照.md)**

## 12. 本项目优化点

- 将 Open-AutoGLM CLI 封装为 FastAPI 服务。
- 手机 App 可以发任务、看状态、看 Trace。
- 使用 Mock / Real 两种模式，便于调试。
- 用 `adb reverse` 解决手机访问电脑 localhost 的问题。
- 任务前自动回桌面，提高 Real 模式成功率。
- 将日志整理为结构化 Trace，方便作业展示和排错。

## 13. 后续升级方向

USB v1 后续演进见系列另两个仓库：

- WiFi：[WIFI-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot)
- Cloud：[CLOUD-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot)

## 14. 对照 Open-AutoGLM 作业要求

| 官方要求 | 本仓库 |
| --- | --- |
| Python + ADB + Android 设备 + ADB Keyboard | ✅ |
| 智谱 BigModel API（autoglm-phone） | ✅ `server/.env` |
| 自然语言控制手机（截图→VLM→ADB） | ✅ `phone_agent/` 内核 |
| phone_agent 标准目录结构 | ✅ [docs/phone_agent-目录对照.md](docs/phone_agent-目录对照.md) |
| **扩展：移动端 App + FastAPI + Trace** | ✅ 工程化封装 |

完整对照表、面试话术、常问 5 题 → **[docs/作业对照与面试官导读.md](docs/作业对照与面试官导读.md)**

## 15. 致谢

本项目基于 [zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 进行工程封装和 USB 本地运行改造。请遵守上游项目的 License 与引用要求。

请勿提交真实 API Key 或包含隐私信息的录屏。
