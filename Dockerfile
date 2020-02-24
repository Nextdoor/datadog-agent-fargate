FROM datadog/agent:latest

RUN echo '#!/bin/bash\n\
if [[ -n "${ECS_FARGATE}" ]]; then\n\
  task_id=$(curl --silent "${ECS_CONTAINER_METADATA_URI}/task" | grep -Eo "arn:aws:ecs:[a-z0-9-]+:[0-9]+:task(\/([A-Za-z0-9-]+))+" | head -n1 | cut -d"/" -f2-)\n\
  export DD_TAGS="$DD_TAGS task_id:$task_id"\n\
  export DD_DOGSTATSD_TAGS="$DD_DOGSTATSD_TAGS task_id:$task_id"\n\
fi\n\
/init\n'\
>> /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh