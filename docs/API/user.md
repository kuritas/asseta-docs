#### /user/login

用户登录

```json
POST
{
	"username" : "", # a-zA-Z0-9, 1 <= length <= 20
	"password" : "", # this is hashed
	"timestamp": Int64 # unix time in miliseconds
}
Success
{
	"code": 0,
	"info": "Succeed",
	"token": ""
}
Fault
{
	"code": *,
	"info": message
}

```

错误类型：

* 用户名或密码错误：`code = 1, message = "username or password error"`
* 登录超时：`code = 2, message = "login timeout"`
* 用户已被锁定：`code = 10, message = "user locked"`

密码哈希方式，使用 `sha256` 进行哈希加密。

散列值即为  `Hash(Hash("sto" + password + "orz") + (string)timestamp)`

后端数据库只存储 `Hash("sto" + password + "orz")`

python里写作hashlib.sha256(("sto" + password + "orz").encode("utf-8")).hexdigest()，结果是64位16进制数，小写

#### /user/logout

这个请求的语义是：让给定的token立刻expire，但是不删除。

```json
POST
{
	"token": ""
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

#### /user/username

获取用户名

```json
POST
{
	"token": ""
}
Success
{
	"code": 0,
	"info": "Succeed",
	"username": ""
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

#### /user/userinfo

获取用户信息

```json
POST
{
	"token": ""
}
Success
{
	"code": 0,
	"info": "Succeed",
	"data": {
		"username": "",
		"department_list_name": [""],
		"company_uuid": "",
		"department_uuid": "",
		# 对于超管，list为空，两个uuid为空串
		"is_superadmin": bool,
		"is_useradmin": bool,
		"is_assetadmin": bool
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

#### /user/changepassword

用户自己修改密码

```json
POST
{
	"username": "",
	"oldpassword": "", # hash with sto-orz and timestamp
	"timestamp": "",
	"newpassword": "" # hash with sto-orz; no timestamp!
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

* 用户名或密码错误：`code = 1, message = "username or password error"`
* 登录超时：`code = 2, message = "login timeout"`

#### /user/setpassword

管理员强制修改密码

需求权限：admin / useradmin

```json
POST
{
	"token": "",
	"username": "",
	"newpassword": ""
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
* 用户不存在： `code = 10, message = "invalid username"`

#### /user/create

管理员创建用户

需求权限：admin / useradmin

```json
POST
{
	"token": "",
	"username": "", # a-zA-Z0-9, 1 <= length <= 20
	"password": "", # this is hashed
	"department_uuid": ""
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
* 用户已经存在： `code = 10, message = "exist the same user"`
* 部门不存在： `code = 11, message = "invalid department uuid"`

#### /user/delete

管理员删除用户

需求权限：admin / useradmin

```json
POST
{
	"token": "",
	"username": ""
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
* 用户不存在： `code = 10, message = "invalid username"`
* 删除自己：`code = 20, message = "deleting self"`

#### /user/privilege

管理员设置用户权限

需求权限： special

```json
POST
{
	"token": "",
	"username": "",
	"set_useradmin": bool,
	"set_assetadmin": bool
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
* 用户不存在： `code = 10, message = "invalid username"`

#### /user/lock

管理员锁定用户，此操作的副作用该用户的所有当前有效的token立刻失效

需求权限： admin / useradmin

```json
POST
{
	"token": "",
	"username": ""
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
* 用户不存在： `code = 10, message = "invalid username"`
* 用户已被锁定： `code = 11, message = "user has been locked"`

#### /user/unlock

管理员解锁用户

需求权限：admin / useradmin

```json
POST
{
	"token": "",
	"username": ""
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
* 用户不存在： `code = 10, message = "invalid username"`
* 用户未被锁定：`code = 11, message = "user not locked"`

#### /user/search

搜索用户

```json
POST
{
	"token": "",
	"filter": {
		"department_uuid": "", // optional
		"username": "" // optional
	}, // optional
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
			"username": "",
			"department_list_name": [""],
			"company_uuid": "",
			"department_uuid": "",
			# 对于超管，list为空，两个uuid为空串
			"is_superadmin": bool,
			"is_useradmin": bool,
			"is_assetadmin": bool
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
* 部门不存在： `code = 11, message = "invalid department uuid"`



