# USB 版系统架构

## 总体调用链

```text
手机 App
  → http://127.0.0.1:8000
  → adb reverse
  → Windows 本地 FastAPI Server
  → Open-AutoGLM main.py
  → PhoneAgent.run(task)
  → 截图 / 模型决策 / USB ADB 执行
  → 真实 Android 手机
```

USB v1 的核心是：电脑跑后端，USB 连接手机，手机 App 通过 `adb reverse` 访问电脑本地服务。

## 2. 分层说明

| 层 | 位置 | 作用 |
| --- | --- | --- |
| 移动端 | `mobile-app/App.tsx` | 输入任务、配置 `127.0.0.1:8000`、展示状态和 Trace |
| 本地 API | `server/main.py` | 提供任务接口，管理任务状态，调用 Open-AutoGLM |
| 启动脚本 | `server/start_server.bat` | 启动本地 FastAPI 服务 |
| 连接脚本 | `server/connect_phone.bat` | 检查 USB ADB，并设置 `adb reverse` |
| Agent 入口 | `Open-AutoGLM/main.py` | 检查设备、键盘、模型 API，启动 PhoneAgent |
| Agent 主循环 | `Open-AutoGLM/phone_agent/agent.py` | Observe → Think → Act 多轮循环 |
| 动作执行 | `Open-AutoGLM/phone_agent/actions/handler.py` | 执行 Launch、Tap、Type、Swipe、Back、Home 等动作 |
| 设备控制 | `Open-AutoGLM/phone_agent/adb/` | 截图、输入、点击、滑动、USB 设备连接 |

## 3. Real 模式执行流程

```text
POST /tasks { task, mode: real }
  → 手机请求被 adb reverse 转发到电脑后端
  → 检查 API Key、Python、Open-AutoGLM、USB ADB 设备
  → 可选唤醒手机、解锁、回桌面
  → 启动 Open-AutoGLM 子进程
  → Agent 获取手机截图
  → VLM 理解当前屏幕并输出动作
  → handler 调用 USB ADB 执行动作
  → 再次截图确认结果
  → 到达 finish 或超时后返回结果
```

## 4. USB v1 运行条件

| 条件 | 说明 |
| --- | --- |
| Windows 电脑 | 运行后端服务 |
| PowerShell / CMD | 保持 `start_server.bat` 不关闭 |
| USB 数据线 | 连接手机与电脑 |
| 手机 USB 调试 | 允许电脑通过 ADB 控制手机 |
| ADB / platform-tools | 执行 `adb devices`、`adb reverse`、点击输入等操作 |
| 智谱 API Key | 模型推理必需 |

## 5. 和云端版的区别

| 项目 | USB v1 |
| --- | --- |
| 后端位置 | 本地电脑 |
| 手机连接 | USB ADB |
| App 地址 | `http://127.0.0.1:8000` |
| 是否需要云服务器 | 不需要 |
| 是否需要 Tailscale | 不需要 |
| 是否需要电脑一直开 | 需要 |

## 6. 展示时可讲的一句话

> USB v1 是项目的第一阶段：我先在本地电脑上跑通 App、FastAPI、Open-AutoGLM 和 USB ADB 的真实手机控制闭环，再把这个链路升级成云端远程版。
