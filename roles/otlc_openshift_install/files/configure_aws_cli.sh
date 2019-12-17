ansible localhost -m lineinfile -a 'path=$HOME/.bashrc state=present line="export REGION='"${REGION}"'"'

mkdir $HOME/.aws
cat << EOF >>  $HOME/.aws/credentials
[default]
aws_access_key_id = ${AWSKEY}
aws_secret_access_key = ${AWSSECRETKEY}
region = $REGION
EOF
