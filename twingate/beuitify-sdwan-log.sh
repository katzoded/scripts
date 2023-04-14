cat $1 \
| grep -e "\[controller\] verify_token" -e "http\:\:re" \
| grep -v "http\:\:response\:\:from\: certificate" \
| ~/dev-newton/scripts/search_and_replace.py --search "^\[.*\] \[controller\] verify_token\: (\{.*\})" --cmd "echo '{MATCH}' | jq" \
| tr '\n' '\\n' \
| ~/dev-newton/scripts/search_and_replace.py --search "(\[[0-9]*\-[0-9]*\-[0-9]*\ [0-9]*\:[0-9]*\:[0-9]*\.[0-9]*\])" --replace "\n\1"
