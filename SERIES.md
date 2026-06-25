# AutoGLM Mobile Copilot 系列总览

> 基于官方 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 的手机 GUI Agent 产品化系列项目。  
> **建议从本页开始浏览**，再进入各版本仓库。

---

## 三个版本怎么选？

| 版本 | 仓库 | 一句话 | 适合谁看 |
| --- | --- | --- | --- |
| **USB v1（主仓库）** | [USB-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot) | USB 线 + 电脑本地后端，最稳定 | **老师 / 作业验收 / 第一次了解项目** |
| WiFi v1 | [WIFI-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot) | 同 WiFi 无线 ADB，不用一直插线 | 想看官方「远程调试」能力 |
| Cloud（进阶） | [CLOUD-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot) | 云 Docker + Tailscale，电脑不用开 | **面试官 / 工程落地亮点** |

### 为什么 USB 当主仓库，Cloud 反而花时间最多？

- **作业角度**：官方 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 核心是 USB + ADB + 智谱 API 跑通 Phone Agent。USB 版最贴合作业验收，所以作为主入口。
- **工程角度**：Cloud 版解决了跨网络远程控制、Docker 部署、远程截图慢、Take_over 非交互、美团演示稳定性等问题，**投入时间最长、技术深度最高**。
- **面试讲法**：「作业主线看 USB，工程能力看 Cloud，中间用 WiFi 衔接官方 remote ADB。」

---

## 演进路线

```text
USB v1（第一版，跑通闭环）
    ↓  去掉 USB 线，同 WiFi 无线 ADB
WiFi v1（对应官方远程调试章节）
    ↓  后端上云，Tailscale 跨网连手机
Cloud（真正远程控制，电脑可关）
```

---

## 统一架构（三个版本共用）

```text
Android App (mobile-app/)
        ↓ HTTP
FastAPI Server (server/main.py)
        ↓ subprocess
Open-AutoGLM PhoneAgent (Open-AutoGLM/main.py)
        ↓ phone_agent/ 内核
截图 → 智谱 VLM 决策 → ADB 执行 → 循环
        ↓ ADB
真实 Android 手机
```

各版本差异只在 **后端部署位置** 和 **ADB 连接方式**：

| 版本 | 后端 | ADB 连接 | App 填的地址 |
| --- | --- | --- | --- |
| USB | 本地 Windows | USB 线 | `http://127.0.0.1:8000` |
| WiFi | 本地 Windows | `adb connect 手机IP:5555` | `http://电脑局域网IP:8000` |
| Cloud | 云服务器 Docker | Tailscale + 无线 ADB | `http://云服务器IP:8000` |

详细目录对照 → [docs/phone_agent-目录对照.md](docs/phone_agent-目录对照.md)

---

## Demo 演示视频

各版本演示视频放在对应仓库的 **GitHub Releases**（避免大文件进 git 历史）：

| 版本 | 观看 / 下载 |
| --- | --- |
| USB v1 | [USB Demo Video](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/releases) |
| WiFi v1 | [WiFi Demo Video](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/releases) |
| Cloud | [Cloud Demo Video](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/releases) |

> 上传 Release 后，可在各仓库 README 的 Demo Video 小节把链接改成具体 Release 资产地址（如 `.../releases/download/v1.0-demo/demo_usb_v1.mp4`）。

视频建议包含：后端启动 → 设备连接 → App 发任务 → 真实手机操作 → Agent Trace 与结果。

---

## 各仓库文档导航

### USB v1（主）

- [README](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/blob/main/README.md)
- [作业对照与面试官导读](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/blob/main/docs/作业对照与面试官导读.md)
- [架构说明](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/blob/main/docs/architecture.md)
- [演示脚本](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/blob/main/docs/demo-script.md)

### WiFi v1

- [README](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/blob/main/README.md)
- [快速开始](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/blob/main/docs/quick-start.md)
- [作业对照与面试官导读](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/blob/main/docs/作业对照与面试官导读.md)

### Cloud

- [README](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/README.md)
- [云端部署](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/docs/cloud-deploy.md)
- [作业对照与面试官导读](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/docs/作业对照与面试官导读.md)

---

## 与 Open-AutoGLM 官方作业的关系

| 官方要求 | USB | WiFi | Cloud |
| --- | --- | --- | --- |
| Python + ADB + Android + ADB Keyboard | ✅ | ✅ | ✅ |
| 智谱 BigModel（autoglm-phone） | ✅ | ✅ | ✅ |
| phone_agent 内核 | ✅ | ✅ | ✅ |
| 自然语言控制手机 | ✅ | ✅ | ✅ |
| 官方 WiFi 远程调试 | — | ✅ | ✅（跨网扩展） |
| Docker 云端部署 | — | — | ⭐ 加分 |

**本系列工程化扩展（三版共有）：** FastAPI 封装 · Android App · Mock/Real · 结构化 Trace

---

## 30 秒系列介绍（面试可直接背）

> 我基于 Open-AutoGLM 做了 AutoGLM Mobile Copilot 系列。官方是 CLI Phone Agent，我加了 FastAPI 和 Android App，形成截图、VLM 决策、ADB 执行、Trace 可视化的闭环。USB 版是最稳定的第一版和作业主交付；WiFi 版对应官方无线 ADB；Cloud 版是我投入最多的进阶：Docker 上云、Tailscale 远程控手机，电脑不用一直开着。Agent 内核没有重写，主要做工程封装和远程场景问题排查。

---

## 致谢

基于 [zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM)。请遵守上游 License，勿公开 API Key 与隐私录屏。
