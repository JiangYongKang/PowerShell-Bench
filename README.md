# PowerShellBench

PowerShellBench 是一个面向 Windows 本地任务的终端 Agent 评测项目。它让模型在受控的 Windows 环境中使用 PowerShell 完成具体任务，并以任务结果为主要依据，分析模型使用 PowerShell 的正确性、安全性和效率。

相比常见 Linux Shell，模型在 PowerShell 中更容易混用 Bash 与 cmd 语法，并在路径、引号、编码和错误处理上出错。本项目希望把这些真实失败模式转化为可重复、可验证的 Windows 任务。

## 与 Terminal-Bench 的关系

Terminal-Bench 评测的是 Agent 在终端环境中完成真实任务的能力。Shell 是 Agent 操作环境的手段，任务本身可以来自软件开发、系统管理、数据处理等不同领域，并不要求都是编程任务。

PowerShellBench 借鉴 Terminal-Bench 的独立任务、结果验收和多轮执行方式，但聚焦 Windows 与 PowerShell。它不是 PowerShell 语法题集，也不要求模型输出与参考答案完全一致的命令。

## 评测方式

每道任务包含独立工作区、自然语言指令、初始化脚本、参考解法和检查逻辑。模型在多轮执行中可以读取命令输出、处理报错并调整方案。评测结束后，检查器验证最终文件、数据和环境状态，运行器同时保存完整执行轨迹。

评测重点不是某条命令是否标准，而是模型能否完成实际工作。实现方式可以不同，只要满足任务要求、没有破坏输入数据，也没有产生未授权副作用，就应被视为正确。

任务结果、PowerShell 使用质量和执行效率分别记录，不急于合并成单一总分。一个更短但错误或危险的命令不应获得更高评价。

## 评测指标

| 维度 | 主要指标 |
| --- | --- |
| 任务结果 | 成功率、数据完整性、最终状态是否符合要求 |
| PowerShell 质量 | 无效命令率、语法错误、路径与编码问题、错误恢复能力 |
| 执行效率 | 命令数量、执行耗时、工具调用轮数、重试次数 |
| 安全性 | 越界访问、误删、覆盖以及不必要的破坏性操作 |
| 方法偏离 | 是否绕开 PowerShell 改用 Python、cmd、WSL Bash 等方式 |

过程指标用于解释模型为什么成功或失败，不单独代替任务结果。选择短命令、长脚本或组合现有工具都可以，前提是结果正确且行为安全。

## 任务范围

首版任务优先覆盖普通 Windows 用户可能遇到的工作，包括文件和目录整理、文本与日志处理、中文编码、CSV 与 JSON 转换、外部工具调用、故障恢复和安全清理。

首版不追求覆盖通用软件工程、GUI 操作、云服务连接器、注册表和系统服务管理等需要更高权限或复杂隔离环境的能力。

## 环境与比较

比较不同模型时，必须固定 Agent scaffold、系统提示、PowerShell 版本、区域设置、可用工具、网络策略、超时和重试规则。否则无法判断差异来自模型、Agent 框架还是运行环境。

如果目标是评价 PowerShell 能力，应尽量减少 Python、cmd 和 WSL Bash 等替代路径，并记录模型是否绕开了 PowerShell。独立工作目录本身不是安全沙箱；执行不可信命令时，需要使用低权限机器或专用虚拟机。

## 项目结构

```text
PowerShell-Bench/
├── README.md
├── docs/
│   └── PowerShell-Bench设计草案.md
├── runner/
│   └── Invoke-Benchmark.ps1
└── tasks/
    └── <task-id>/
        ├── task.yaml
        ├── instruction.md
        ├── setup.ps1
        ├── check.ps1
        ├── reference.ps1
        └── fixtures/
```

`task.yaml` 保存任务元数据，`instruction.md` 是提供给模型的题目，`setup.ps1` 创建初始状态，`check.ps1` 验证最终结果，`reference.ps1` 用于确认任务可解和检查器有效，`fixtures/` 存放任务输入。

## 当前状态

项目目前处于初始化阶段。评测方向、任务结构和指标原则已经确定，详细设计见 [PowerShell-Bench 设计草案](docs/PowerShell-Bench设计草案.md)。运行器和任务模板尚未实现，下一步需要确定 `task.yaml` 字段、检查器输出协议和统一执行流程。
