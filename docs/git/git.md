#### commit 规范

`[x-y]<type>: <message>(#issue)`

`\[\d{2}\-\d{2}\](feat|fix|docs|test|style|conf|ui): .*\(#\d+\)`

`x` : 功能一级特性，编号从 01 开始。

`y` : 功能二级特性，编号从 01 开始。

`<type>` : 

```text
* feat:     新功能
* fix:      修改bug
* docs:     修改文档
* style:    格式化代码结构（不影响代码运行的变动）
* test:     增加或修改测试
* conf:     修改配置文件或脚本
* ui:       界面设计

```

`<message>` : 对 commit 的简短描述

#### merge request 规范

`[x-y]<message>(#issue)`

`\[\d{2}\-\d{2}\].*\(#\d+\)`

#### branch 规范

`<type>-<message>`

`(feat|fix)\-.*`

`<type>` : 

```
* feat:     新功能
* fix:      修改bug

```


