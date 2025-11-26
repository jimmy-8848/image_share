set -ex

if [ ! -n "$1" ]; then
    VER=`git tag | grep -v "v" | tail -n 1 | python3 -c "
import sys
vers = sys.stdin.readline().strip().split('.');
print('.'.join([*vers[:2], str(int(vers[2])+1)]))
"`
else
    VER="$1"
fi

git tag $VER
git push -u origin $VER

docker build -t <你的ACR地址>/<命名空间>/image_share:$VER .
docker push <你的ACR地址>/<命名空间>/image_share:$VER

echo <你的ACR地址>/<命名空间>/image_share:$VER

