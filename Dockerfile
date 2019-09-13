FROM alpine

# Install curl, python3, pip3, aws-cli and set PATH
 RUN apk --no-cache add curl python3 && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    pip3 install awscli --upgrade --user
ENV PATH /root/.local/bin:$PATH

# Set AWS Arguments
#ENV AWS_KEY
#ENV AWS_SECRET_KEY
#ENV AWS_REGION

#ARG api_url
#ARG api_token
#ARG username
#ARG password

# Configure AWS arguments
#RUN aws configure set aws_access_key_id $AWS_KEY \
 #   && aws configure set aws_secret_access_key $AWS_SECRET_KEY \
  #  && aws configure set default.region $AWS_REGION

### copy bash script and change permission
RUN mkdir workspace
COPY scan-api.sh /workspace
RUN chmod +x  /workspace/scan-api.sh 
CMD ["/bin/sh", "/workspace/scan-api.sh"]
