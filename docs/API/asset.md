# API_assetss

#### /asset/create

导入资产

权限：assetadmin 权限范围为子树，superadmin/useradmin 不管

```json
{
	"token": "",
	"asset_list": [
		"name": "", // 0 < len <= 128
		"description": "", // optional, default is "", 0 <= len <= 1024
		"department_uuid": "",
		"category_uuid": "",
		"is_distinct": boolean,
		"count": number // optional, default is 1
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

#### /asset/search

查询资产列表

权限 user 仅限本公司

```json
{
	"token": "",
	"filter": { // optional
		"category_uuid": "",
		"asset_name_contains": "", // 搜子串
		"status": "",
		"user": ""
	}
	"numberperpage": number // optional, None for 50, Max = 50
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
			"status": "", ["IDLE", "IN_USE", "IN_MAINTAIN", "RETIRED", "DELETED "]
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
Fault{
	"code": *,
	"info": message
}

```


