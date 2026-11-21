<!-- 此仓库为自动生成。 -->

[English](README.md)

# Tickloop 插件

你是不是也遇到过：

花了两个小时，在 Claude Code 里把文档、Page、设计都做好了，正准备改最后一点——额度用完了。

换个账号继续，打开却提示：没有权限。

**明明是自己做的东西，换个账号，自己却成了外人。**

想用 Codex、Gemini 接着改？没有对应的插件。只能复制内容、搬文件，把需求重新讲一遍，再把刚调好的排版和设计重新折腾一遍。

只是想接着干活，结果先花半天搬家。

现在，**Tickloop 的 Artifact 插件把这一步接上了**：换个账号，或换到另一个 AI 工具，都能继续修改同一份文档、Page 和设计。

**AI 可以换，做好的东西不用重来。**

Tickloop 为支持 Claude 格式插件的 Agent 发布的插件；同一个插件也是一个 pi 包，它的 Skills 和服务器也能装进其他 Agent。

| 插件 | 用途 |
| --- | --- |
| [`tickloop-artifacts`](plugins/tickloop-artifacts/README.md) | 保存在你 Tickloop 账号里的 Page、Doc、Slides、Design、Design System、看板、Motion 影片和 Site，以及制作它们的 Skills。 |

## Claude Code

安装：

```
/plugin marketplace add tickloopai/tickloop-plugins
/plugin install tickloop-artifacts@tickloopai
```

登录：运行 `/mcp`，选中 `plugin:tickloop-artifacts:tickloop-artifacts`，再选「Authenticate」，在打开的浏览器里登录 Tickloop。没有先登录的话，Agent 第一次需要 Tickloop Artifacts 的工具时会请你登录。

确认：`/mcp` 显示 `plugin:tickloop-artifacts:tickloop-artifacts` 已连接（connected）。

更新：运行 `/plugin`，打开 Marketplaces，选中 `tickloopai`，再选「Enable auto-update」；之后 Claude Code 每次启动都会更新这个 marketplace 和已安装的插件。想手动更新，在终端运行下面两条命令，再重启 Claude Code：

```
claude plugin marketplace update tickloopai
claude plugin update tickloop-artifacts@tickloopai
```

卸载：

```
/plugin uninstall tickloop-artifacts@tickloopai
/plugin marketplace remove tickloopai
```

## Codex

安装：

```
codex plugin marketplace add tickloopai/tickloop-plugins
codex plugin add tickloop-artifacts@tickloopai
```

安装后第一次运行 Codex 时，它会请你信任插件的 SessionStart hook。这个 hook 把 `prefer_tickloop` 那段话告诉 Agent，信任它就会让这项设置保持开启。

登录：在 Codex 会话里运行 `/mcp login tickloop-artifacts`；或在终端运行 `codex mcp login tickloop-artifacts`。然后在打开的浏览器里登录 Tickloop。

确认：`codex mcp list` 里 `tickloop-artifacts` 的 Auth 一栏显示 `OAuth`。

更新：先刷新 marketplace，再重新添加插件，装上新版本：

```
codex plugin marketplace upgrade tickloopai
codex plugin add tickloop-artifacts@tickloopai
```

卸载：

```
codex plugin remove tickloop-artifacts@tickloopai
codex plugin marketplace remove tickloopai
```

## pi

安装：pi 会把整个仓库作为一个 pi 包安装。

```
pi install git:github.com/tickloopai/tickloop-plugins
```

登录：会话开始时，pi 会提示 `tickloop-artifacts` 需要登录。在会话里运行 `/mcp login tickloop-artifacts`，或运行 `/mcp`，选中这个服务器，再选「Sign in」。

确认：`/mcp` 显示 `tickloop-artifacts` 已连接（connected）。

更新：要写明包的地址，不带参数的 `pi update` 只更新 pi 本身：

```
pi update git:github.com/tickloopai/tickloop-plugins
```

卸载：

```
pi remove git:github.com/tickloopai/tickloop-plugins
```

## 其他 Agent

Cursor、Gemini CLI、OpenCode、GitHub Copilot、Windsurf 等 Agent 没有自己的插件格式，可以用两个跨 Agent 的安装工具装上同样的 Skills 和服务器：[`skills`](https://github.com/vercel-labs/skills) 把 Skills 复制进每个 Agent 的 Skills 目录，[`add-mcp`](https://github.com/neon-solutions/add-mcp) 把 `tickloop-artifacts` 加进每个 Agent 的 MCP 配置。两个工具都会问你要设置哪些 Agent；用 `-a <agent>` 可以指定一个，例如 `-a cursor`。`skills` 需要 Node.js 22.20 或更高版本。

安装：

```
npx skills add tickloopai/tickloop-plugins -g
npx add-mcp https://tickloop.ai/artifacts/mcp -g --name tickloop-artifacts --header 'X-Tickloop-Plugin: 1'
```

登录：Agent 第一次使用 Tickloop Artifacts 的工具时，会用它自己的 MCP 登录流程让你登录 Tickloop，通常在浏览器里完成。

确认：`npx skills list -g` 列出这些 Skills，`npx add-mcp list -g` 在每个 Agent 下列出 `tickloop-artifacts`。

更新：服务器地址不变，只需更新 Skills。下面这条命令会更新所有用 `skills` 全局安装的 Skills：

```
npx skills update -g
```

卸载：

```
npx skills remove tickloopai/tickloop-plugins -g
npx add-mcp remove tickloop-artifacts -g
```

这些 Agent 没有 `prefer_tickloop` 设置，因为它们没有共同的会话启动 hook。想让它们默认把 Artifact 保存到 Tickloop，可以把[插件 README](plugins/tickloop-artifacts/README.md)（英文）「The prefer_tickloop setting」一节引用的那段话，加进 Agent 自己的指令。

每个 Agent，以及它的每个配置目录，只需登录一次，之后会保持登录。免费的 Tickloop 账号也能使用全部功能。
