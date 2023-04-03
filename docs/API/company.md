#### /company/create

新建业务实体

需求权限  admin

```json
POST
{
	"token": "",
	"name": ""
}
Success
{
	"code": 0,
	"info": "Succeed",
	"uuid": ""
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

#### /company/delete

删除业务实体

需求权限 superadmin

```json
POST
{
	"token": "",
	"company_uuid": "",
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
* 业务实体不存在： `code = 10, message = "invalid uuid"`
* 非空业务实体：`code = 11, message = "not empty company"`

#### /company/rename

修改业务实体名字

需求权限：superadmin

```json
POST
{
	"token": "",
	"uuid": "",
	"new_name": ""
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
* 业务实体不存在： `code = 10, message = "invalid uuid"`

#### /company/list

查看所有业务实体

需求权限：superadmin

```json
POST
{
	"token": ""
}
Success
{
	"code": 0,
	"info": "Succeed",
	"company": [
		{
			"company_uuid": "",
			"company_name": ""
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
* 权限不足：`code = 3, message = "no access"`

#### /company/query

返回部门树

```json
POST
{
	"token": "",
	"company_uuid": ""
}
Success
{
	"code": 0,
	"info": "Succeed",
	"data": [
		{
			"department_uuid": "",
			"department_name": "",
			"father": ""
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
* company_uuid无效：`code = 10, message = "invalid company_uuid"`