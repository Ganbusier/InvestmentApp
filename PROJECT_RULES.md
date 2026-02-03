# 项目规则

## 规则 1：遵循 superpowers 技能的规范和流程

所有方案规划与开发工作必须按照 superpowers 技能的规范和流程进行：

- 在进行任何创意工作（创建功能、构建组件、添加功能或修改行为）之前，必须先使用 brainstorming 技能
- 重大功能或错误修复实现前，必须使用 test-driven-development 技能
- 代码完成后，必须使用 requesting-code-review 技能进行验证
- 接收代码审查反馈时，必须使用 receiving-code-review 技能
- 遇到 bug、测试失败或意外行为时，必须使用 systematic-debugging 技能
- 在独立会话中执行实现计划时，必须使用 subagent-driven-development 技能
- 使用执行计划时，必须使用 executing-plans 技能，并在检查点进行审查
- 完成开发工作后（所有测试通过），必须使用 finishing-a-development-branch 技能
- 开始需要隔离的工作时，必须使用 using-git-worktrees 技能
- 工作完成、修复或通过验证后，必须使用 verification-before-completion 技能

## 规则 2：方案保存位置

每次生成方案后，询问用户是否将方案保存到 `docs/plans/` 目录下。

### 方案文件命名规范
- 使用描述性名称，清晰表达方案内容
- 使用连字符或下划线分隔单词
- 包含版本号或日期以区分不同版本

### 方案内容要求
- 记录需求分析和设计思路
- 包含具体的实现步骤
- 列出依赖和前提条件
- 定义验收标准

## 规则 3：项目状态记录

每次完成功能开发或修复后，必须将项目当前状态记录到 `PROJECT_STATUS.md` 中，包括：
- 已完成的功能列表
- 当前版本号/里程碑
- 待完成的功能
- 已修复的 bug
- 已知问题
