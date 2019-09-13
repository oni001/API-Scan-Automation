Build the docker file with the below command with build arguments,

docker build -t scanimage:v12 . 




RUN SCAN

docker run -it -v ~/.aws/credentials:/root/.aws/credentials -v ~/.aws/config:/root/.aws/config -e scanimage:v12  
