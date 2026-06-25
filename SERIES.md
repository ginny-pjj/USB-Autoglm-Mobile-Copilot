# AutoGLM Mobile Copilot 系列

基于 [Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM) 的手机 GUI Agent，在官方 Phone Agent 之上增加了 FastAPI 后端与 Android 控制端 App。

## 仓库列表

| 版本 | 仓库 | 后端 | 手机连接 | App 地址 |
| --- | --- | --- | --- | --- |
| USB | [USB-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot) | Windows 本地 | USB 数据线 | `http://127.0.0.1:8000` |
| WiFi | [WIFI-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot) | Windows 本地 | 同 WiFi 无线 ADB | `http://电脑IP:8000` |
| Cloud | [CLOUD-Autoglm-Mobile-Copilot](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot) | 云服务器 Docker | Tailscale + 远程 ADB | `http://云服务器IP:8000` |

## 架构概览

三个版本共用 **App → FastAPI → Open-AutoGLM PhoneAgent → ADB → 手机** 链路，差异在部署位置与连接方式：

| 版本 | 架构图 |
| --- | --- |
| USB | [architecture-usb.png](assets/architecture-usb.png) |
| WiFi | [WIFI 仓库架构图](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/blob/main/assets/architecture-wifi.png) |
| Cloud | [Cloud 仓库架构图](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/assets/architecture-cloud.png) |

## 演示视频

| 版本 | 链接 |
| --- | --- |
| USB | [USB-demo.mp4](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/releases/download/usb-demo/USB-demo.mp4) |
| WiFi | [WIFI-demo.mp4](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/releases/download/demo-wifi/WIFI-demo.mp4) |
| Cloud | [Releases](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/releases) |

## 文档

- [USB README](https://github.com/ginny-pjj/USB-Autoglm-Mobile-Copilot/blob/main/README.md)
- [WiFi README](https://github.com/ginny-pjj/WIFI-Autoglm-Mobile-Copilot/blob/main/README.md)
- [Cloud README](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/README.md) · [云端部署](https://github.com/ginny-pjj/CLOUD-Autoglm-Mobile-Copilot/blob/main/docs/cloud-deploy.md)

## 致谢

基于 [zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM)，遵循上游 License。
