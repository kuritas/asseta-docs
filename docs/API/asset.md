# API_assetss

- token 不存在：`code = 1, message = "invalid token"`
- token 超时：`code = 2, message = "token expired"`

#### /asset/create

导入资产

权限：assetadmin 权限范围为子树，superadmin/useradmin 没有权限

```json
{
	"token": "",
	"asset_list": [
		{
			"name": "", // 0 < len <= 32
			"description": "", // optional, default is "", 0 <= len <= 1024
			"department_uuid": "",
			"category_uuid": "",
			"children": [
				{
					"name": "", // 0 < len <= 32
					"description": "", // optional, default is "", 0 <= len <= 1024
					"department_uuid": "", // must the same as father's department
					"category_uuid": "",
					"children": [], // empty
					"is_distinct": boolean,
					"count": number
				}
			],
			"is_distinct": boolean,
			"count": number // non-negative integer, optional, default is 1, 
					            // must not exceed 1 when is_distinct is True
		}
	]
}
Success
{
	"code": 0,
	"info": "Succeed"
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 权限不足：`code = 3, message = "no access"`
- 部门不存在： `code = 10, message = "invalid department"`
- 类别不存在： `code = 11, message = "invalid category"`
- 子资产和父资产部门不同：`code = 30, message = "different departments between parent&child"`

#### /asset/modify

修改指定的资产，只能修改下面列出的字段。如果一个字段不需要修改，就不要传入这个字段。

只能修改空闲资产，修改会使得所有相关待审批工单失效（副作用！）。

权限：assetadmin 权限范围为子树，superadmin/useradmin 没有权限

```json
{
	"token": "",
	"asset_uuid": "",
	// every field below is optional, not given means no change
	"name": "", // 0 < len <= 32
	"description": "", // 0 <= len <= 1024
	"category_uuid": "",
	"parent_uuid": "", // "" to make root, not given to keep the same
}
Success
{
	"code": 0,
	"info": "Succeed"
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

- 权限不足：`code = 3, message = "no access"`
- asset_uuid 本资产不存在（包括资产不可见）： `code = 10, message = "invalid asset_uuid"`
- 类别不存在： `code = 11, message = "invalid category"`
- parent_uuid 父资产不存在（包括资产不可见）： `code = 12, message = "invalid parent_uuid"`
- 父资产回环（父资产是自己，或者是孙子）：`code = 30, message = "making loop"`
- 只能修改空闲资产： `code = 31, message = "asset is not idle"`


#### /asset/search

查询资产列表

权限：仅限本业务实体

```json
{
	"token": "",
	"filter": { // optional
		"category_uuid": "",
		"asset_name_contains": "", // 搜子串
		"status": "",
		"username": ""
	},
	"numberperpage": number, // optional, None for 50, Max = 50
	"pagenumber": number // optional, None for 1
}
Success
{
	"code": 0,
	"info": "Succeed",
	"num_pages": number,
	"num_items": number,
	"data": [
		{
			"uuid": "",
			"name": "",
			"status": "", // ["IDLE", "IN_USE", "IN_MAINTAIN", "RETIRED", "DELETED"]
			"username": "",
			"department_name": "",
			"department_uuid": "",
			"category_name": "",
			"category_uuid": "",
			"is_distinct": bool,
			"count": number
		}
	]
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

* 类别不存在： `code = 11, message = "invalid category"`


#### /asset/info

查询资产详细信息

权限：仅限本业务实体

```json
{
    "token": "",
    "asset_uuid": ""
}
Success
{
    "code": 0,
    "info": "Succeed",
    "data": {
     	"name": "",
    	"description": "",
        "username": "", // 挂账人
        "status": "", // ["IDLE", "IN_USE", "IN_MAINTAIN", "RETIRED", "DELETED"]
		"department_uuids": [""],   // from company
        "department_names": [""],   // from company
		"category_uuids": [""],     // from dummy
        "category_names": [""],     // from dummy
        "is_distinct": boolean,
        "count": number,
        "father_uuid": "", // return "" if no father
        "father_name": "", // return "" if no father
        "children": [ // 所有的附属资产
            {
                "uuid": "",
                "name": "",
            }
        ]
    }
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效，包括查询到非本业务实体资产：`code = 10, message = "invalid asset uuid"`

#### /asset/transfer

子级资产更换父亲（只能从一个资产的附属资产变为另一个资产的附属资产）。

权限：仅限本业务实体。

```json
{
    "token": "",
    "source_uuid": "", // 待转移资产 uuid
    "target_uuid": ""  // 转移到的父资产的 uuid
}
Success
{
    "code": 0,
    "info": "Succeed"
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效，包括查询到非本业务实体资产：`code = 10, message = "invalid asset uuid"`
- 待转移资产不是子级资产，或目标资产不是父级资产：`code = 11, message = "invalid source or target asset"`

#### /asset/apply

员工申请资产，创建申请工单

权限：仅限员工申请当前业务实体的资产

```json
{
	"token": "",
  	"asset_uuid": "",
	"description": "", // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": message
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效，包括申请到非本业务实体资产：`code = 10, message = "invalid asset uuid"`
- 资产当前处于不可申请状态：`code = 11, message = "asset cannot apply"`

#### /asset/maintain

用户提出请求对资产进行维保，创建维保工单

权限：仅限用户提出自己的资产

```json
{
	"token": "",
    "asset_uuid": "",
	"description": "" // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": message
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效：`code = 10, message = "invalid asset uuid"`
- 资产不属于自己：`code = 11, message = "asset not belong to you"`

#### /asset/return

员工申请归还资产，创建归还工单

权限：仅限员工归还自己的资产

```json
{
	"token": "",
  	"asset_uuid": "",
	"description": "", // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": message
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效：`code = 10, message = "invalid asset uuid"`
- 资产不属于自己：`code = 11, message = "asset not belong to you"`

#### /asset/setstatus

资产管理员修改资产的状态

权限：当前部门的资产管理员

若相关字段不存在意味不进行修改

```json
{
	"token": "",
    "asset_uuid": "",
    "status": "", // ["IDLE", "IN_USE", "IN_MAINTAIN", "RETIRED", "DELETED"] IDLE means set user=null  ontional
}
Success
{
    "code": 0,
    "info": message
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- 权限不足，自己非资产管理员或者资产不属于当前部门： `code = 3, message = "no access"`
- uuid 无效：`code = 10, message = "invalid asset uuid"`

