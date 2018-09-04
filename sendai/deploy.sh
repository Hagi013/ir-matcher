#!/bin/bash
echo -e "\n========== [$(pwd)/$0] ==========\n" 1>&2
set -o pipefail
set -vxeu

################################################################################
#
# 説明
# ==========
#
# Lambda FunctionのDeployをSAMを用いて行う。
#
# 前提条件
# ==========
#
# - なし
#
# パラメータ
# ==========
#
# 1. ENV_NAME: Deploy先の環境名(e.g. dev, prod, ...)
# 2. (Optional) ALIAS: Deploy時のAlias名、リリース名や開発時用の個人名等を付ける
#
# 成果物/戻り値
# ==========
#
# 成果物
# ----------
#
# - SAMプロジェクトのディレクトリ構造を持った新たなディレクトリ。
#
# 戻り値
# ----------
#
# - なし
#
################################################################################
# 簡易引数チェック
:

readonly PROJECT_DIR=$(pwd)
readonly FUNCTION_SRC="${PROJECT_DIR}/src"
readonly ENV_NAME=${1:-dev}
readonly ACCOUNT_ID=$(aws sts get-caller-identity --output text | awk -F' ' '{print $1}') # aws sts get-caller-identity | jq .Account -r
readonly BUCKET_NAME="ir-mathcer-${ENV_NAME}-stacktemplate-${ACCOUNT_ID}"
readonly ZIPPED_DIR_NAME=sendai.zip

# 一時ディレクトリを作成し、カレントディレクトリを移動
readonly WORK_DIR=$(mktemp -d)
# readonly FUNCTIONS_DIR="${WORK_DIR}/functions"
trap "rm -rf ${WORK_DIR}" EXIT
cd ${WORK_DIR}
# mkdir -p ${FUNCTIONS_DIR}

# 必要なファイル群のコピー
cp -f ${PROJECT_DIR}/template.yaml ${WORK_DIR}
cp -f ${PROJECT_DIR}/package*.json ${WORK_DIR}
cp -rf ${FUNCTION_SRC} ${WORK_DIR}

# packageのinstall
npm install --production

# zip化
zip -r ${ZIPPED_DIR_NAME} ./

# S3 にファイル一式をパッケージ化して配置する
aws cloudformation package --template-file template.yaml --output-template-file template-output.yaml --s3-bucket ${BUCKET_NAME}

# スタックを作成
aws cloudformation deploy --template-file template-output.yaml --stack-name $BUCKET_NAME --capabilities CAPABILITY_IAM --parameter-overrides Environments=${ENV_NAME}
