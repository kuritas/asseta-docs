# API_assetss

#### /asset/create

导入资产

权限：assetadmin 权限范围为子树，superadmin/useradmin 不管

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

* token不存在：`code = 1, message = "invalid token"`
* token超时：`code = 2, message = "token expired"`
* 权限不足：`code = 3, message = "no access"`
* 部门不存在： `code = 10, message = "invalid department"`
* 类别不存在： `code = 11, message = "invalid category"`
* 子资产和父资产部门不同：`code = 30, message = "different departments between parent&child"`

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

* token不存在：`code = 1, message = "invalid token"`
* token超时：`code = 2, message = "token expired"`
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
		"department_uuid": [""],   // from root
        "department_name": [""],   // from root
		"category_uuid": [""],     // from root
        "category_name": [""],     // from root
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

* token不存在：`code = 1, message = "invalid token"`
* token超时：`code = 2, message = "token expired"`
* uuid 无效，包括查询到非本业务实体资产：`code = 10, message = "invalid asset uuid"`

