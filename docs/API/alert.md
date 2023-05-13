## 总述

包含两张表：警告表和警告配置表。每天更新资产信息后将遍历所有警告配置，并创建对应的警告。注意，警告只会在更新资产信息后被后端自动创建，无法通过API创建。资产管理员可以手动删除警告（来表示该警告已解决/忽略）。

每条警告配置包含指定部门、资产类型、警告类型和一个数字value。对于每条警告配置，当：

给定部门（含子树）的给定类型资产

+ "VALUE": 总价值小于等于value
+ "NUM": 总数量小于等于value
+ "TO_RETIRE"：存在一个资产的rest_life小于等于value

条件满足时，则创建警报。

#### /alert/config/create

创建警报配置

权限：本部门或祖先的资产管理员


```json
{
	"token": "",
    "department_uuid": uuid,
    "category_uuid": uuid,
    "type": "", //"VALUE", "NUM", "TO_RETIRE"
    "value": number // >= 0
}
Success
{
	"code": 0,
	"info": "Succeed",
    "data": { "config_uuid": uuid }
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 部门不存在或无权限： `code = 10, message = "invalid department uuid"`
- 类别不存在： `code = 11, message = "invalid category"`

#### /alert/config/delete

删除警报配置

权限：本部门或祖先的资产管理员

```json
{
	"token": "",
    "config_uuid": uuid,
}
Success
{
	"code": 0,
	"info": "Succeed",
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 警告配置不存在或无权限： `code = 10, message = "invalid alert config uuid"`

#### /alert/config/list

列出指定部门（不含子部门）的警告

权限：本部门或祖先的资产管理员

```json
{
	"token": "",
    "department_uuid": uuid,
}
Success
{
	"code": 0,
	"info": "Succeed",
    "data": {[
        "config_uuid": uuid,
        "category_uuid": uuid,
        "type": "", //"VALUE", "NUM", "TO_RETIRE"
        "value": number // >= 0
    ]}
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 部门不存在或无权限： `code = 10, message = "invalid department uuid"`


#### /alert/delete

删除警报

权限：本部门或祖先的资产管理员

```json
{
	"token": "",
    "alert_uuid": uuid,
}
Success
{
	"code": 0,
	"info": "Succeed",
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 警告不存在或无权限： `code = 10, message = "invalid alert uuid"`

#### /alert/list

列出指定部门（不含子部门）的警告

权限：本部门或祖先的资产管理员

```json
{
	"token": "",
    "department_uuid": uuid,
}
Success
{
	"code": 0,
	"info": "Succeed",
    "data": {[
        "alert_uuid": uuid,
        "category_uuid": uuid,
        "type": "", //"VALUE", "NUM", "TO_RETIRE"
        "value": number // >= 0
    ]}
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 部门不存在或无权限： `code = 10, message = "invalid department uuid"`