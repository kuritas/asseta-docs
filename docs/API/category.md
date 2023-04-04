### API

category是一个森林，每个公司都有自己的根节点，每个公司根节点的名字都是dummy，但是uuid不同。dummy不能删改。不存在超级根。

类别对公司所有员工展示，但是不跨公司展示。资产管理员可以创建和重命名类别，但是不能删除类别（一个例外是，类别的上一次修改者是自己）。挂在根节点的资产管理员可以删除类别。删除类别要求类别下没有子类别，也没有资产。

每次创建/重命名，会改变资产的“上次修改人”和“上次修改时间”。

【前端】dummy不对用户展示，挂在dummy的资产/类别直接出现在根目录。

【后端】由于无法为每个公司建立dummy，我们会在一旦涉及到dummy的时候，自动创建一个dummy，假装它一直存在。

超管由于不属于任何公司，什么都看不到，什么都不能做。

#### general

```json
Fault
{
	"code": *,
	"info": message
}
```

所有基于用户token的请求，都遵循：

* token不存在：`code = 1, message = "invalid token"`
* token超时：`code = 2, message = "token expired"`


#### /category/create

创建类别。

权限：公司的资产管理员

```json
{
	"token": "",
    "name": "",
    "father_uuid": "",
}
Success
{
	"code": 0,
	"info": "Succeed",
    "uuid": "",
}
```

错误类型：

* 权限不足（包括超管）：`code = 3, message = "no access"`
* 父类别不存在（包括父类别是别的公司的）： `code = 10, message = "no such father"`

#### /category/rename

重命名类别。

权限：公司的根资产管理员；普通资产管理员，且上次修改者是自己

```json
{
	"token": "",
    "name": "",
    "uuid": "",
}
Success
{
	"code": 0,
	"info": "Succeed",
}
```

错误类型：

* 权限不足（包括超管）：`code = 3, message = "no access"`
* 类别不存在（包括类别是别的公司的）： `code = 10, message = "no such category"`
* 操作dummy：`code = 20, message="dont touch dummy"`

#### /category/delete

删除类别，要求没有子类别也没有资产。

权限：公司的根资产管理员；普通资产管理员，且上次修改者是自己。

```json
{
	"token": "",
    "uuid": "",
}
Success
{
	"code": 0,
	"info": "Succeed",
}
```

错误类型：

* 权限不足（包括超管）：`code = 3, message = "no access"`
* 类别不存在（包括类别是别的公司的）： `code = 10, message = "no such category"`
* 类别下有子类别：`code = 11, message = "category has children"`
* 类别下有资产：`code = 12, message = "category has assets"`
* 操作dummy：`code = 20, message="dont touch dummy"`

#### /category/queryall

查询公司的类别树。（如果数据库还没有dummy，后端会立刻创建dummy）

权限：公司所有员工。

```json
{
	"token": "",
}
Success
{
	"code": 0,
	"info": "Succeed",
    "data": [ # list of categories
        {
            "name": "",
            "uuid": "",
            "father_uuid": "",
            "created_by": "username",
            "created_at": "time", # 标准格式，如"2009-06-15T13:45:30"，UTC时区
        }
    ]
}
```

错误类型：

* 超管的请求：`code = 4, message = "super admin has no company"`

