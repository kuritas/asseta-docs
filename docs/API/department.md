#### /department/create

新建部门

需求权限  superadmin / useradmin

```json
POST
{
	"token": "",
	"father_uuid": "",
	"name": ""
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
* 父部门不存在或为根： `code = 10, message = "invalid father"`

#### /department/delete

删除部门

需求权限 superadmin / useradmin

```json
POST
{
	"token": "",
	"department_uuid": "",
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
* 部门不存在： `code = 10, message = "invalid uuid"`
* 非空部门：`code = 11, message = "not empty department"`

#### /department/rename

修改部门名字

需求权限：superadmin / useradmin

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
* 部门不存在： `code = 10, message = "invalid uuid"`


#### department/get_self_company

（仅作数据库过渡用）

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