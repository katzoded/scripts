cat $1 \
| grep -e "\[controller\] verify_token" -e "http\:\:re" \
| grep -v "http\:\:response\:\:from\: certificate" \
| ~/dev-newton/scripts/search_and_replace.py --search "^\[.*\] \[controller\] verify_token\: (\{.*\})" --cmd "echo '{MATCH}' | jq | tr '\n' '\\'" \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*" --replace "sdwan->\3: \2 \4\\\\n \1" \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/.*\" (.*) \(.*\)" --replace "\2->sdwan:\3: \\\\n \1" \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) .* (\{.*\})" --replace "note over sdwan:\2: \\\\n \1" \
| sed 's/\\/\\n/g'


#| ~/dev-newton/scripts/search_and_replace.py --search "(\[[0-9]*\-[0-9]*\-[0-9]*\ [0-9]*\:[0-9]*\:[0-9]*\.[0-9]*\])" --replace "\n\1" \
