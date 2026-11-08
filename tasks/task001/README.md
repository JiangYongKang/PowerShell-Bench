# task001

用于验证本地 runner 的最小冒烟任务。Agent 需要在临时工作区根目录创建 `hello.txt`，独立验收进程检查文件位置和内容。

`task.json` 的 `status` 为 `ready`，`setup.ps1`、`reference.ps1` 和 `check.ps1` 都接收 `-WorkspacePath` 参数。`check.ps1` 向标准输出写入 JSON，并使用退出码表示验收结果。
