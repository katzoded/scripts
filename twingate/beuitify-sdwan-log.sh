FILENAME=$1

echo "#!$(which bash)" > /tmp/beuitify_all_json.sh
echo "cat - \\" >> /tmp/beuitify_all_json.sh

# build loop for json beuitifier
cat  ${FILENAME} \
| grep -e "\{.*\}" \
| ~/dev-newton/scripts/search_and_replace.py --search "^\[.*[0-9]\] " --replace "" \
| awk -F '[\{]' '{print $1}' \
| sort -u  \
| ~/dev-newton/scripts/search_and_replace.py --search "^(.*)$" --replace "| ~/dev-newton/scripts/twingate/beuitify-sdwan-json-line.sh \"\1\" \\\\" >> /tmp/beuitify_all_json.sh

echo "" >> /tmp/beuitify_all_json.sh
chmod +x /tmp/beuitify_all_json.sh


(echo "title $(basename ${FILENAME})" && cat ${FILENAME}) \
| grep -e "\{.*\}" -e "http\:\:re" -e "title" \
| grep -v "http\:\:response\:\:from\: certificate" \
| /tmp/beuitify_all_json.sh \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*" --replace "sdwan->\3: \2 \4\\\\n \1" \
| ~/dev-newton/scripts/search_and_replace.py --search "^(\[.*\]) http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/.*\" (.*) \(.*\)" --replace "\2->sdwan:\3: \\\\n \1"


rm -f /tmp/beuitify_all_json.sh

