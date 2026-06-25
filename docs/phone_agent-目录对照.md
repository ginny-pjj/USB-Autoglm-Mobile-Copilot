# phone_agent 目录对照（对齐 Open-AutoGLM 官方结构）

> 官方仓库：[zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM)  
> 本系列三个版本共用同一套 `Open-AutoGLM/phone_agent/` 内核，未重写 Agent 核心。

---

## 1. 官方标准结构（作业要求）

Open-AutoGLM README 中的 `phone_agent/` 结构：

```text
phone_agent/
├── __init__.py          # 包导出
├── agent.py             # PhoneAgent 主类（Observe → Think → Act 循环）
├── adb/                 # ADB 工具
│   ├── connection.py    # 远程/本地连接管理
│   ├── screenshot.py    # 屏幕截图
│   ├── input.py         # 文本输入 (ADB Keyboard)
│   └── device.py        # 设备控制 (点击、滑动等)
├── actions/             # 操作处理
│   └── handler.py       # 操作执行器（Launch / Tap / Type / Swipe ...）
├── config/              # 配置
│   ├── apps.py          # 支持的应用映射
│   ├── prompts_zh.py    # 中文系统提示词
│   └── prompts_en.py    # 英文系统提示词
└── model/               # AI 模型客户端
    └── client.py        # OpenAI 兼容客户端（智谱 autoglm-phone）
```

**官方 Agent 一步怎么走：**

```text
截图 (adb/screenshot.py)
  → 调 VLM (model/client.py)
  → 解析动作 (actions/handler.py)
  → ADB 执行 (adb/device.py, adb/input.py)
  → 循环直到 finish
```

---

## 2. 本项目的目录位置

在本系列仓库中，官方结构位于：

```text
Open-AutoGLM/
├── main.py                 # CLI 入口：检查设备/键盘/API → agent.run(task)
└── phone_agent/            # ← 上表官方结构
```

**产品化扩展层（作业之外的工程封装）：**

```text
server/main.py              # FastAPI：/tasks、Mock/Real、Trace 清洗、远程 ADB（Cloud）
mobile-app/App.tsx          # Android 控制端：发任务、看 Trace
```

---

## 3. 官方结构 vs 本项目实际文件

| 官方模块 | 本项目路径 | 作用 |
| --- | --- | --- |
| `agent.py` | `Open-AutoGLM/phone_agent/agent.py` | Agent 主循环 |
| `adb/connection.py` | 同路径 | WiFi/Cloud 远程 `adb connect` |
| `adb/screenshot.py` | 同路径 | 截图；Cloud 版含远程超时与压缩补丁 |
| `adb/input.py` | 同路径 | ADB Keyboard 输入 |
| `adb/device.py` | 同路径 | 点击、滑动、Launch |
| `actions/handler.py` | 同路径 | 动作执行；Cloud 版含 Take_over 非交互补丁 |
| `config/apps.py` | 同路径 | App 包名映射 + 别名 |
| `config/prompts_zh.py` | 同路径 | 中文 Prompt |
| `model/client.py` | 同路径 | 智谱 API 调用 |

**本项目额外文件（在官方基础上的扩展，非删减）：**

| 文件 | 说明 |
| --- | --- |
| `adb/ui_tree.py` | UI 树辅助定位（美团搜索等） |
| `device_factory.py` | 统一 adb / hdc 设备抽象 |

---

## 4. 三层调用关系

```text
┌─────────────────────────────────────────┐
│  mobile-app/          产品层             │
│  发任务、看 Trace                        │
└──────────────────┬──────────────────────┘
                   │ HTTP
┌──────────────────▼──────────────────────┐
│  server/main.py       API 封装层          │
│  Mock/Real、subprocess 调 Agent          │
└──────────────────┬──────────────────────┘
                   │ subprocess
┌──────────────────▼──────────────────────┐
│  Open-AutoGLM/main.py   官方 CLI 入口     │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│  phone_agent/         官方 Agent 内核     │
│  agent → model → actions → adb           │
└──────────────────┬──────────────────────┘
                   │ ADB
┌──────────────────▼──────────────────────┐
│  Android 手机                            │
└─────────────────────────────────────────┘
```

---

## 5. 支持的操作（官方 Agent 能力）

| 操作 | 说明 |
| --- | --- |
| Launch | 启动应用 |
| Tap | 点击坐标 |
| Type | 输入文本 |
| Swipe | 滑动 |
| Back / Home | 返回 / 回桌面 |
| Long Press / Double Tap | 长按 / 双击 |
| Wait | 等待加载 |
| Take_over | 人工接管（登录/验证码；Cloud 版自动跳过非交互场景） |

运行 `python main.py --list-apps` 可查看支持的应用列表。

系列总览 → [SERIES.md](../SERIES.md)
