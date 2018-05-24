DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
docker build --tag proxy-state $DIR/..
docker images proxy-state
