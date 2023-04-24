
#### /ticket/request/create

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
- 资产不可申请：`code = 11, message = "asset cannot apply"`

#### /ticket/maintain/create

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

#### /ticket/return/create

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
