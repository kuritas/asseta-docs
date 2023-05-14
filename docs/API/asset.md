# API_assetss

- token 不存在：`code = 1, message = "invalid token"`
- token 超时：`code = 2, message = "token expired"`

#### /asset/create

导入资产。通过包含 "upload_img": True 来获取传图链接。这个 url 必须通过 put 访问，10分钟过期。必须要在header里包含 'Content-Type': 'image/jpeg'。

保质期单位为「天」。**所有价格全部精确到整数，前端可以考虑精确到 0.1 分（也就是把用户输入数字乘 1000）** 。

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
					"count": number,
					"value": number, // positive, <= 2147483647, optional, default is 0
					"lifespan": number, // positive, <= 2147483647, optional, default is inherit
				}
			],
			"is_distinct": boolean,
			"count": number, // non-negative integer, optional, default is 1, 
					             // must not exceed 1 when is_distinct is True
			"value": number, // positive, <= 2147483647
			"lifespan": number, // positive, <= 2147483647
			"upload_img": boolean, // optional; if True, return contains upload url
		}
	]
}
Success
{
	"code": 0,
	"info": "Succeed",
	"assets": [{ // list of successfully created assets
		"uuid": "",
		"url": "" // upload url, is nonempty only when corresponding upload_img is True
	}]
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

upload_img 为 True 时，会返回 url。这个 url 必须通过 put 访问，10分钟过期。必须要在header里包含 'Content-Type': 'image/jpeg'。

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
	"upload_img": boolean,
}
Success
{
	"code": 0,
	"info": "Succeed"
}
Fault
{
	"code": *,
	"info": message,
	"url": "" // exists only when upload_img is True
}

```

错误类型：

- 权限不足：`code = 3, message = "no access"`
- asset_uuid 本资产不存在（包括资产不可见）： `code = 10, message = "invalid asset_uuid"`
- 类别不存在： `code = 11, message = "invalid category"`
- parent_uuid 父资产不存在（包括资产不可见）： `code = 12, message = "invalid parent_uuid"`
- 父资产回环（父资产是自己，或者是孙子）：`code = 30, message = "making loop"`
- 只能修改空闲资产： `code = 31, message = "asset is not idle"`
- 子资产和父资产部门不同：`code = 32, message = "different departments between parent&child"`
- 父不为空，且自己或父亲为非distinct：`code = 33, message = "build tree on non-distinct asset"`


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
			"total_value": number, 
			"current_value": number,
			"lifespan": number, 
			"rest_life": number,
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

查询资产详细信息。当 include_img 为 True 时，返回的 url 可以访问文件，10分钟过期。如果图片不存在，本函数不会报错，但是返回的 url 会给 404 not found。

权限：仅限本业务实体

```json
{
    "token": "",
    "asset_uuid": "",
	"include_img": boolean // optional, default is False
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
		"total_value": number, 
		"current_value": number,
		"lifespan": number, 
		"rest_life": number,
        "is_distinct": boolean,
        "count": number,
        "father_uuid": "", // return "" if no father
        "father_name": "", // return "" if no father
        "children": [ // 所有的附属资产
            {
                "uuid": "",
                "name": "",
            }
        ],
		"img_url": "", // exists only when include_img is True
    }
}
Fault
{
    "code": *,
    "info": message
}
```


#### /asset/retire

资产清退

资产状态变为 RETIRED，直接子资产的父亲变为空。

清退的资产不能处于 RETIRED / DELETED 状态。

权限：资产管理员，且并且资产管理员可以管理资产。


```json
{
    "token": "",
    "asset_uuid_list": [
        "",
    ],
}
Success
{
    "code": 0,
    "info": "Succeed",
    "success_list": [
        "",
    ],
    "fail_list": [
        "",
    ],//No access or has retired or deleted
}
Fault
{
    "code": *,
    "info": message,
}
```

错误类型：如果用户是资产管理员，那么不会有错误。未成功的uuid将被放入fail_list

#### /asset/statistic

权限：资产管理员，且指定的部门需要在其子树中

```json
{
    "token": "",
    "department_uuid": "",
}
Success
{
    "code": 0,
    "info": "Succeed",
    "data": {
     	"total_num": number, //资产总数
    	"total_value": number, //资产总价值
        "status_info": [
            {
                "status": ["IDLE", "IN_USE", "IN_MAINTAIN"],
                "total_num": number,
                "total_value": number,
            }
        ], // 共有 3 项，分别是 IDLE IN_USE IN_MAINTAIN 的资产信息
		"subdepartment_info":[
			{
				"department_uuid": uuid, 
                "department_name": "",
				"total_num": number,
				"total_value": number,
			}
		],
		"history":[
			{
				"date": date,
				"total_value": number
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

- 不存在或没有权限的部门：`code = 10, message = "invalid department uuid"`
- 不存在的状态：`code = 11, message = "invalid status"`

~~#### /asset/transfer~~

子级资产更换父亲（只能从一个资产的附属资产变为另一个资产的附属资产）。

权限：仅限本业务实体。

```jsonx
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


~~#### /asset/setstatus~~

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
