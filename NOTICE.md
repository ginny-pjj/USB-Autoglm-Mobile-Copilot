# 第三方声明（NOTICE）

本项目基于 [zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 构建。

Open-AutoGLM 提供 Phone Agent 核心能力，包括多模态屏幕理解、动作规划与 ADB 设备控制。本仓库在其上增加了面向应用的产品化层：

- FastAPI 任务服务（`server/`）
- Android 控制端 App（`mobile-app/`）
- Mock / Real 双模式与结构化 Trace
- USB 本地部署方案（本系列 usb-v1 仓库）
- WiFi 无线调试方案（wifi-v1 仓库）
- 云端 Docker + 远程 ADB 方案（cloud 仓库）

请遵守上游 Open-AutoGLM 的 License 与引用要求。

**请勿公开：** 真实 API Key、服务器 IP、Tailscale 地址、含隐私的截图或录屏。
