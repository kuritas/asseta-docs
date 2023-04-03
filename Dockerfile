FROM python:3.9 as build

ENV TMP=/opt/tmp

WORKDIR $TMP

COPY . .

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

RUN mkdocs build

# Stage 1
FROM nginx:1.22

ENV HOME=/opt/app

WORKDIR $HOME

COPY --from=build /opt/tmp/site dist

COPY nginx /etc/nginx/conf.d

EXPOSE 80
# TODO End