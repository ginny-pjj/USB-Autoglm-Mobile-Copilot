# USB 版 FAQ

## 1. 和 WiFi / Cloud 版有什么区别？

USB v1 的后端运行在本地 Windows 电脑上，手机通过 USB ADB 连接电脑。云端版的后端运行在云服务器上，手机通过 Tailscale / 无线 ADB 连接云端。

## 2. 运行时电脑必须开着吗？

必须。USB v1 的 FastAPI 后端在电脑上运行，`start_server.bat` 窗口不能关闭。

## 3. 需要云服务器吗？

不需要。USB v1 全部在本地电脑和真实手机之间完成。

## 4. App 为什么填 `http://127.0.0.1:8000`？

因为 USB v1 使用 `adb reverse tcp:8000 tcp:8000`。手机访问自己的 `127.0.0.1:8000` 时，会被 ADB 转发到电脑本地的 FastAPI 服务。

## 5. REAL 模式显示无设备怎么办？

检查：

1. USB 数据线是否正常。
2. 手机是否开启 USB 调试。
3. 手机是否弹出授权确认。
4. `adb devices` 是否显示 `device`。
5. 是否执行过 `adb reverse tcp:8000 tcp:8000`。

## 6. API Key 可以提交到 GitHub 吗？

不可以。只能提交 `.env.example`，真实 `server/.env` 必须被 `.gitignore` 排除。

## 7. ADB Keyboard 必须安装吗？

不是绝对必须，但建议安装并启用。它可以提升中文输入和复杂输入的稳定性。

## 8. 当前版本的基准是什么？

USB v1 的基准是跑通本地 App → FastAPI → Open-AutoGLM → USB ADB → 真实手机的完整闭环。
