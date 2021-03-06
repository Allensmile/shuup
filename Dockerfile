FROM node:11.14-slim
LABEL maintainer="Eero Ruohola <eero.ruohola@shuup.com>"

RUN apt-get update && \
    apt-get -y install python3 python3-pip python3-dev python3-pil && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app

RUN pip3 install shuup

RUN python3 -m shuup_workbench migrate
RUN python3 -m shuup_workbench shuup_init
RUN echo 'from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser("admin", "admin@admin.com", "admin")' \
    | python3 -m shuup_workbench shell

CMD python3 -m shuup_workbench runserver 0.0.0.0:8000
