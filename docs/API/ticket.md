# API_tickets

- token 不存在：`code = 1, message = "invalid token"`
- token 超时：`code = 2, message = "token expired"`

## 抽象工单

```python
requester = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name="+")
request_time = models.DateTimeField(auto_now_add=True)
request_msg = models.TextField(max_length=MAX_TICKETMSG_LEN, blank=True, default="")
approver = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, default=None, related_name="+") # '+' for unavailable backward relation 
approve_time = models.DateTimeField(null=True, default=None)
approve_msg = models.TextField(null=True, max_length=MAX_TICKETMSG_LEN, default=None)
uuid = models.UUIDField(primary_key=True, default=uuid.uuid4, unique=True, editable=False)
asset = models.ForeignKey(Asset, on_delete=models.SET_NULL, null=True)
department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True)
status = OPEN = "OPEN", ACCEPTED = "ACCEPTED", REJECTED = "REJECTED", INVALID = "INVALID"
```

## asset的状态

```python
IDLE, IN_USE, IN_MAINTAIN, RETIRED, DELETED
新增： TO_MAINTAIN, TO_RETURN
```

#### /ticket/search

搜索工单。仅限自己可见的那些。可见包括：

- 资产管理员可见，工单的部门是自己的子树
- 用户可见，工单的参与者包含自己

权限：仅限本业务实体

```json
{
	"token": "",
	"filter": { // every field is optional
        "type": "REQUEST", // ["REQUEST", "MAINTAIN", "RETURN"]
        "status": "OPEN", // ["OPEN", "ACCEPTED", "REJECTED", "INVALID"] 后端对应OPEN, APPROVED, REJECTED, INVALID/RETURNED
        "asset_uuid": "", // exact
        "username": "", // exact
        "department_uuid_exact": "", // exact
        "department_uuid_subtree": "", // subtree; 如果不包含，其实对于资产管理员来说就是自己的department的子树
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
            "type": "",
            "asset_uuid": "",
            "asset_name": "",
            "requester_username": "",
            "request_time": "",
            "approver_username": "",
            "approve_time": "",
            "status": "",
            "department_uuid": "",
            "department_name": "",
		}
	]
}
Fault
{
	"code": *,
	"info": message
}

```

不会出错，错了就是空列表。

### /ticket/request

create, approve

INVALID 仅仅发生在，被申请的资产被修改了。【记得改asset相关操作的副作用！】

#### /ticket/request/create

- IDLE -> IDLE

员工申请资产，创建申请工单。会把平行的其他申请工单都拒绝掉。

权限：仅限员工申请当前业务实体的根资产

```json
{
	"token": "",
  	"asset_uuid": "",
	"description": "", // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": "Succeed",
    "ticket_uuid": ""
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- uuid 无效，包括申请到非本业务实体资产：`code = 10, message = "invalid asset uuid"`
- 资产不是根：`code = 11, message = "asset not root"`
- 资产不是idle：`code = 12, message = "asset not idle"`

#### /ticket/request/approve

- accept=true: IDLE -> IN_USE
- accept=false: IDLE -> IDLE

资产管理员审批申请工单，同意或拒绝；自己拒绝自己的申请

权限：资产管理员为子树；用户为自己，且只能拒绝

```json
{
    "token": "",
    "ticket_uuid": "",
    "accept": true, // true for accept, false for reject
    "message": "" // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": "Succeed",
    "ticket_uuid": "",
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：
- uuid 无效，包括自己不可见、不是申请工单：`code = 30, message = "invalid ticket uuid"`
- 工单不是open：`code = 31, message = "ticket not open"`
- 自己通过自己的工单：`code = 32, message = "cannot accept your own ticket"`

### /ticket/maintain

create, approve, return

return 事实上不操作工单，只是把资产状态改为 IN_USE。

#### /ticket/maintain/create

- IN_USE -> TO_MAINTAIN

用户提出请求对资产进行维保，创建维保工单。维保时，挂账人为自己。

权限：仅限用户提出自己的资产

```json
{
	"token": "",
    "asset_uuid": "",
	"message": "" // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": "Succeed",
    "ticket_uuid": ""
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：

- 资产不存在，包括不属于自己：`code = 11, message = "asset does not exist"`
- 资产不是IN_USE：`code = 12, message = "asset not in use"`

#### /ticket/maintain/approve

- accept=true: TO_MAINTAIN -> IN_MAINTAIN
- accept=false: TO_MAINTAIN -> IN_USE

资产管理员审批维保工单，同意或拒绝；自己拒绝自己的申请

权限：资产管理员为子树；用户为自己，且只能拒绝

```json
{
    "token": "",
    "ticket_uuid": "",
    "accept": true, // true for accept, false for reject
    "message": "" // 0 <= len <= 1024
}
Success
{
    "code": 0,
    "info": "Succeed",
    "ticket_uuid": "",
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：
- uuid 无效，包括自己不可见、不是维保工单：`code = 30, message = "invalid ticket uuid"`
- 工单不是open：`code = 31, message = "ticket not open"`
- 自己通过自己的工单：`code = 32, message = "cannot accept your own ticket"`

#### /ticket/maintain/return

- IN_MAINTAIN -> IN_USE

资产管理员归还维保资产，把资产状态改为 IN_USE。不涉及工单。

权限：资产管理员为子树

```json
{
    "token": "",
    "asset_uuid": "",
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
- 资产 uuid 无效，包括资产挂账部门不是子树：`code = 10, message = "asset does not exist"`
- 资产不是 IN_MAINTAIN：`code = 11, message = "asset not in maintain"`

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
    "info": "Succeed",
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
