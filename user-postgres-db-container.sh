#! /bin/bash
CONTAINER_NAME="user_db_container"
CONTAINER_PORT="5432"
#choose your own username
POSTGRES_USER="postgres"
# choose your own password
POSTGRES_PASSWORD="password123"
DB_NAME="freelanceeasy"
export ERR_BAD=100
export ERR=""

function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}
function throw()
{
    exit $1
}
function catch()
{
    export exception_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $exception_code
}

#if you don't have postgres image, pull it first
#docker pull postgres 

if  docker inspect $CONTAINER_NAME &>/dev/null; then
   echo "container with the same name already exist"
   exit 1;
else 
try
(
  docker run -d \
     --name $CONTAINER_NAME \
     -e POSTGRES_USER=$POSTGRES_USER \
     -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
     -e POSTGRES_DB=$DB_NAME \
     -p $CONTAINER_PORT:$CONTAINER_PORT \
     postgres:14.7 || throw $ERR_BAD
)
catch ||  {
    echo "ooops!! an internal problem occured"
}
fi
     