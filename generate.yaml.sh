cd ~/dev-newton/${1}/Swagger/sbcrestapi-swagger-res-${2};

java -jar "d:\\dev-newton\\dev-tools\\swagger-codegen-master\\modules\\swagger-codegen-cli\\target\\swagger-codegen-cli.jar" generate -i "d:\\dev-newton\\${1}\\Swagger\\sbcrestapi-swagger-res-${2}\\Swagger.yaml" -l spring -o "d:\\dev-newton\\${1}\\Swagger\\sbcrestapi-swagger-res-${2}\\" -c "d:\\dev-newton\\${1}\\Swagger\\sbcrestapi-swagger-res-${2}\\swagger-package.json" -DhideGenerationTimestamp=true;

echo "find . -type f | xargs grep -l \"io\\.swagger\\.[model|api]\" | ~/dev-newton/scripts/ReplaceFileList.sh \"\(.*\)\" \"~/dev-newton/scripts/re-generate-with-dialogic.sh ${1} ${2} \1\" > ./re-gen.sh" > ./re-list.sh
echo "./re-gen.sh" >> ./re-list.sh
./re-list.sh
