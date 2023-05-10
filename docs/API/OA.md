### OA 飞书

所有带 token 的

- token 不存在：`code = 1, message = "invalid token"`
- token 超时：`code = 2, message = "token expired"`

用户唯一标识：open_id

前端将获取到的 code 发送给后端，

然后后端向 `https://passport.feishu.cn/suite/passport/oauth/token` 发送 `POST` 请求，获取 `access_token`

请求格式：
```json
{
	"grant_type": "authorization_code",
	"client_id": APP_ID,
	"client_secret": APP_SECRET,
	"code": code
}
```
注：此处的 body 的格式为 `application/x-www-form-urlencoded`，header 应有："Content-Type": "application/x-www-form-urlencoded"。

然后后端向 `https://open.feishu.cn/open-apis/authen/v1/user_info` 发送 `GET` 请求，获取该用户的用户信息，然后进行相关操作。

请求格式： header 中添加 "Authorization": "Bearer " + access_token。

[飞书相关 API 1](https://open.feishu.cn/document/common-capabilities/sso/api/get-access_token)
[飞书相关 API 2](https://open.feishu.cn/document/uAjLw4CM/ukTMukTMukTM/reference/authen-v1/user_info/get)

#### /oa/login

使用 OA 认证进行身份验证

```json
POST
{
	"code" : "", # user_access_token
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
错误信息：将飞书的错误信息返回即可。

- code = 10, message = "openid is not bound to any user"

#### /oa/binding

用户绑定飞书账号

```json
POST
{
  "token": "",
	"code" : "", # user_access_token
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

错误信息：

- token 相关错误

- code = 10, message = "user is bound to feishu account"
- code = 11, message = "feishu account is bound to another user"

- code 错误：将飞书的错误信息返回即可。

#### /oa/unbinding

用户取消绑定飞书账号，若原本就没有绑定，则不操作。

```json
POST
{
  "token": "",
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

错误信息：

token 相关错误
