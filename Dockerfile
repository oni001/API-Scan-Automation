FROM python:3.7-alpine


RUN mkdir /root/.aws
RUN pip3 --no-cache-dir install --upgrade awscli
RUN pip3 install requests
RUN pip3 install boto3

RUN apk add --no-cache bash
RUN apk add bash

ENV API_TOKEN=5563ff177863
ENV BASE_REPORT_URL=http://10.110.3.66:4242/
ENV JOB_ID=42
ENV IP_ADDRESSES=192.168.1.1
ENV BASE_API_URL=http://10.110.3.66:4242/scanjob/

### copy bash script and change permission
RUN mkdir workspace
COPY scan.py /workspace
RUN chmod +x  /workspace/scan.py
### copy python script and change permission
CMD ["sh", "-c", "python /workspace/scan.py --api_token $API_TOKEN --base_api_url $BASE_API_URL --base_report_url $BASE_REPORT_URL --job_id $JOB_ID --ip_addresses $IP_ADDRESSES"]
