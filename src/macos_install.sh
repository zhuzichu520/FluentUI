RUN_TYPE=$1
PRESET_PATH=$2
BUILDER_BIN_PATH=$3
QT_QML_FLUENT_PATH=$4

echo ${RUN_TYPE}
if [ ${RUN_TYPE} = "PRESET" ]; then
cp    -r  ${PRESET_PATH}/FluentUI.h ${BUILDER_BIN_PATH}
cp    -r  ${PRESET_PATH}/build-preset/* ${BUILDER_BIN_PATH}
else
rm    -rf ${QT_QML_FLUENT_PATH=}
mkdir -pv ${QT_QML_FLUENT_PATH=}
cp    -r  ${BUILDER_BIN_PATH}/* ${QT_QML_FLUENT_PATH=}
fi
