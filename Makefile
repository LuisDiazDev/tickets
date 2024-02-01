STORE_PASS=TicketsApps2023
KEY_PASS=TicketsApps2023
KEY_ALIAS=key
ORGANIZATION_NAME=TICKETS2023
LOCATION=SANTIAGO
STATE=RM
COUNTRY=CL
ORGANIZATION_UNIT=TI
ORGANIZATION_DOMAIN=tickets.cl

FOLDER=android
FILE_NAME=${KEY_ALIAS}.jks
FILE=android/${FILE_NAME}
KEY_PROPS_FILE=android/key.properties

BUNDLETOOL_VERSION=1.15.6
BUNDLETOOL_FILE=bundletool-all-${BUNDLETOOL_VERSION}.jar
BUNDLETOOL_INSTALL_PATH=/usr/bin
BUNDLETOOL_EXEC=${BUNDLETOOL_INSTALL_PATH}/bundletool

GENERATED_BUNDLE_FILE=build/app/outputs/bundle/release/app-release.aab
GENERATED_APKS=/tmp/${ORGANIZATION_NAME}.apks

install_bundletool:
	@wget https://github.com/google/bundletool/releases/download/${BUNDLETOOL_VERSION}/${BUNDLETOOL_FILE}
	@sudo mv ./${BUNDLETOOL_FILE} ${BUNDLETOOL_EXEC}
	@sudo chmod +x ${BUNDLETOOL_EXEC}


create_key_prop_file:
	@rm -f ${KEY_PROPS_FILE}
	@echo "storePassword=${STORE_PASS}" >> ${KEY_PROPS_FILE}
	@echo "keyPassword=${KEY_PASS}" >> ${KEY_PROPS_FILE}
	@echo "keyAlias=${KEY_ALIAS}" >> ${KEY_PROPS_FILE}
	@echo "storeFile=../${FILE_NAME}" >> ${KEY_PROPS_FILE}

generate_keys: create_key_prop_file
	@rm -f ${FILE}
	@echo "Generando una nueva keystore con los siguientes datos:"
	@echo "store pass=${STORE_PASS}"
	@echo "key pass=${KEY_PASS}"
	@keytool -genkey -v -keystore ${FILE} -keyalg RSA -keysize 2048 \
		-validity 10000 -alias ${KEY_ALIAS}  -storepass ${STORE_PASS} -keypass ${KEY_PASS} \
		-dname "CN=${ORGANIZATION_DOMAIN}, OU=${ORGANIZATION_UNIT}, O=${ORGANIZATION_NAME}, L=${LOCATION}, S=${STATE}, C=${COUNTRY}"

build:
	 @flutter build appbundle --target-platform android-arm,android-arm64,android-x64

test_bundle:
	@rm -f ${GENERATED_APKS}
	@java -jar ${BUNDLETOOL_EXEC} build-apks --bundle=${GENERATED_BUNDLE_FILE} --output=${GENERATED_APKS} \
	--ks=${FILE} \
	--ks-pass=pass:${STORE_PASS} \
	--key-pass=pass:${KEY_PASS} \
	--ks-key-alias=${KEY_ALIAS}
