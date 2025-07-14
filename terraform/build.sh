# #!/usr/bin/env bash
# set -e
 
# filename=$1
# code_path=$2
 
# pushd "${code_path}" > /dev/null
# rm -rf .package
# rm -f "${filename}".zip
# mkdir -p .package
 
# if [[ -f "requirements.txt" ]]; then
#     pip3 install -q -r requirements.txt -t .package/
# fi
# cp *.py .package/
# if [[ -f "package.txt" ]]; then
#     cp -r "$(cat package.txt)" .package/
# fi
# rm -rf `$(find .package -type d -name __pycache__)`
# (cd .package && zip -X -q -r9 ../"${filename}".zip .)
# hash="$(find .package ! -path "*${filename}.zip" -type f -exec sha256sum {} \; | sort -k 1 | sha256sum | cut -f 1 -d " ")"
# echo "{\"filename\": \"${filename}.zip\", \"hash\": \"${hash[0]}\"}"
# popd > /dev/null