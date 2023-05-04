# record的实现

record 支持：按时间范围 filter，按其中包含的各种域 filter。返回的 record 支持 paginator。

## record的设计

record 包含几个 field：

例如，登录成功的 record 可以是：

```python
uuid
time
caller
company
event = "success: /user/login"
brief_template: "{user} at {ip} successfully loginin at {time}"
brief_json = '{"user": "admin", "ip": "1.2.3.4", time: "2023-01-02T14:13:11.302226"}'
# searchable with substring, iso time format
detail_json = '{"user": user.detail(), ...}'
```
