<div align=center>
<img width=64 src="doc/preview/fluent_design.svg">

# QML FluentUI

一个 Qt QML 的 Fluent Design 组件库，需要 PySide6 [PySide6-FluentUI-QML](https://github.com/zhuzichu520/PySide6-FluentUI-QML)。

</div>

![win-badge] ![ubuntu-badge] ![macos-badge] ![release-badge] ![download-badge] ![download-latest]

<div align=center>

[English](README.md) | 简体中文

<img src="doc/preview/demo_large.png">

</div>

[win-link]: https://github.com/zhuzichu520/FluentUI/actions?query=workflow%3AWindows "WindowsAction"
[win-badge]: https://github.com/zhuzichu520/FluentUI/workflows/Windows/badge.svg  "Windows"
[ubuntu-link]: https://github.com/zhuzichu520/FluentUI/actions?query=workflow%3AUbuntu "UbuntuAction"
[ubuntu-badge]: https://github.com/zhuzichu520/FluentUI/workflows/Ubuntu/badge.svg "Ubuntu"
[macos-link]: https://github.com/zhuzichu520/FluentUI/actions?query=workflow%3AMacOS "MacOSAction"
[macos-badge]: https://github.com/zhuzichu520/FluentUI/workflows/MacOS/badge.svg "MacOS"
[release-link]: https://github.com/zhuzichu520/FluentUI/releases "Release status"
[release-badge]: https://img.shields.io/github/release/zhuzichu520/FluentUI.svg?style=flat-square "Release status"
[download-link]: https://github.com/zhuzichu520/FluentUI/releases/latest "Download status"
[download-badge]: https://img.shields.io/github/downloads/zhuzichu520/FluentUI/total.svg "Download status"
[download-latest]: https://img.shields.io/github/downloads/zhuzichu520/FluentUI/latest/total.svg "latest status"

<p align=center>
这是一个基于 Qt QML 的漂亮 FluentUI 组件库。目前主分支支持 Qt 6。如果您想在 Qt 5 中使用它，请切换至 Qt 5 分支。
</p>

## 必要条件

+ Qt Core、Qt Quick、Qt QML、Qt ShaderTool、Qt 5 Compatibility Module.（**重要**）
+ Qt LinguistTool（可选，用于翻译）
+ Qt Svg（可选，但对于 Qt 5 来说必不可少）

在使用库之前使用 [Qt 在线安装程序](https://download.qt.io/archive/online_installers/) 获取模块（**推荐**），或先编译模块。

## ⚽ 快速开始

+ 下载 [预编译版本](https://github.com/zhuzichu520/FluentUI/releases)。（请注意您的平台和编译器）。

+ 运行 `example` 程序。

或者

+ 克隆此仓库

```bash
git clone --recursive https://github.com/zhuzichu520/FluentUI.git
```

+ 构建

```bash
git clone --recursive https://github.com/zhuzichu520/FluentUI.git
cd FluentUI
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH=<YOUR_QT_SDK_DIR_PATH> -DCMAKE_BUILD_TYPE=Release -GNinja <仓库路径>
cmake --build . --config Release --target all --parallel
```

+ 使用 IDE（`Qt Creator` 或者 `CLion`）打开项目。（仅支持 **CMake**）。

<div align=center>
  <img src="doc/preview/qt_creator_project.png">
</div>

+ 编译项目。然后尝试执行 `example` 演示程序。

+ 太好了！现在您可以编写第一个 QML FluentUI 程序了！查看文档了解更多详情。

## 📑 文档

(正在进行中...🚀)

## 支持的组件

|        目录         |       详情       |                    备注 / Demos                     |
| :-----------------: | :--------------: | :-------------------------------------------------: |
|       FluApp        |   程序初始入口   |                   支持路由（SPA）                   |
|      FluWindow      |     无框窗口     |                  *仅适用于 Windows                  |
|      FluAppBar      | 窗口顶部的标题栏 |          支持拖动、最小化、最大化和关闭。           |
|       FluText       |     通用文本     |                                                     |
|      FluButton      |     通用按钮     |      ![btn](doc/preview/demo_standardbtn.png)       |
|   FluFilledButton   |   Filled 按钮    |    ![filledbtn](doc/preview/demo_filledbtn.png)     |
|    FluTextButton    |     文本按钮     |      ![textbtn](doc/preview/demo_textbtn.png)       |
|   FluToggleButton   |     切换按钮     |    ![togglebtn](doc/preview/demo_toggle_btn.png)    |
|       FluIcon       |     通用图标     |         ![icons](doc/preview/demo_icon.png)         |
|   FluRadioButton    |      单选框      |     ![radiobtn](doc/preview/demo_radiobtn.png)      |
|     FluTextBox      |    单行输入框    |      ![textbox](doc/preview/demo_textbox.png)       |
| FluMultiLineTextBox |    多行输入框    | ![textarea](doc/preview/demo_multiline_textbox.png) |
|   FluToggleSwitch   |       开关       | ![toggleswitch](doc/preview/demo_toggle_switch.png) |

在 [`这里`](doc/md/all_components.md) 查看更多！

## 参考

+ [**Windows 设计**：Microsoft 的设计指南和工具包。](https://learn.microsoft.com/zh-CN/windows/apps/design/)
+ [**Microsoft/WinUI-Gallery**: Microsoft's demo](https://github.com/microsoft/WinUI-Gallery)

## 许可

本 FluentUI 库目前采用 [MIT License](./License) 许可。

## 星标历史

[![星标历史图表](https://api.star-history.com/svg?repos=zhuzichu520/FluentUI&type=Date)](https://star-history.com/#zhuzichu520/FluentUI&Date)

## ⚡ 游客数量

![游客数量](https://profile-counter.glitch.me/zhuzichu520-FluentUI/count.svg)
