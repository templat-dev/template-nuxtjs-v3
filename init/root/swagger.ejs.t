---
to: <%= rootDirectory %>/scripts/swagger.sh
force: true
---
#!/usr/bin/env bash
# swagger.yamlのtype: objectとexample: xxxを削除
sed -i '' 's|          type: object||g; s|example:.*||g' apis/swagger.yaml

npx openapi-generator generate -i apis/swagger.yaml -o apis -g typescript-axios --additional-properties=useSingleRequestParameter=true
