import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("Pinyin")

    Component.onCompleted: {
        FluPinyin.buildPattern()
        const chineseWords = ["中国", "北京", "上海", "广州", "深圳", "杭州", "成都", "你好", "谢谢", "再见", "请问", "名字", "朋友", "学习", "天气", "今天", "明天", "昨天", "时间", "星期", "早上", "中文", "拼音", "输入法", "计算机", "手机", "电视", "音乐", "旅游", "美食", "餐厅", "医院", "学校", "工作", "工资", "重要", "快乐", "幸福", "爱情", "家庭", "孩子", "父母", "银行", "行长", "长大", "重量", "重新", "重庆", "长城", "苹果", "香蕉", "西瓜", "草莓", "咖啡", "茶", "啤酒", "汽车", "飞机", "地铁", "自行车", "出租车", "公交", "走路"]
        pinyinBox.items = chineseWords.map(text => ({
                                                        [pinyinBox.textRole]: text
                                                    }))
    }

    FluText {
        textFormat: Text.MarkdownText
        onLinkActivated: link => {
                             Qt.openUrlExternally(link)
                         }
        onLinkHovered: link => {
                           if (link === "") {
                               FluTools.restoreOverrideCursor()
                           } else {
                               FluTools.setOverrideCursor(Qt.PointingHandCursor)
                           }
                       }
        text: qsTr('[pinyin-pro document](https://pinyin-pro.cn/guide/compare.html)')
    }

    FluGroupBox {
        Layout.fillWidth: true
        padding: 10
        title: "pinyin"
        ColumnLayout {
            FluText {
                text: 'FluPinyin.pinyin("汉语拼音") --> %1'.arg(FluPinyin.pinyin("汉语拼音"))
            }
            FluText {
                text: 'FluPinyin.pinyin("汉语拼音", { "toneType": "none" }) --> %1'.arg(FluPinyin.pinyin("汉语拼音", { "toneType": "none" }))
            }
            FluText {
                text: 'FluPinyin.pinyin("汉语拼音", { "toneType": "num" }) --> %1'.arg(FluPinyin.pinyin("汉语拼音", { "toneType": "num" }))
            }
            FluText {
                text: 'FluPinyin.pinyin("汉语拼音", { "type": "array" }) --> %1'.arg(JSON.stringify(FluPinyin.pinyin("汉语拼音", { "type": "array" })))
            }
        }
    }

    FluGroupBox {
        Layout.topMargin: 20
        Layout.fillWidth: true
        padding: 10
        title: "match"
        ColumnLayout {
            Layout.fillWidth: true
            FluText {
                text: 'FluPinyin.match("汉语拼音", "hanyupinyin") --> %1'.arg(JSON.stringify(FluPinyin.match("汉语拼音", "hanpin")))
            }
            FluText {
                text: 'FluPinyin.match("汉语拼音", "hanpin") --> %1'.arg(JSON.stringify(FluPinyin.match("汉语拼音", "hanpin")))
            }
            FluText {
                text: 'FluPinyin.match("汉语拼音", "hanpin", { "continuous": true }) --> %1'.arg(JSON.stringify(FluPinyin.match("汉语拼音", "hanpin", { "continuous": true })))
            }
            FluAutoSuggestBox {
                id: pinyinBox
                Layout.topMargin: 10
                placeholderText: qsTr("Input Chinese or Pinyin")
                showSuggestWhenPressed: true
                filter: function (item) {
                    return length === 0 || FluPinyin.match(item[textRole], text, { "continuous": true })
                }
            }
        }
    }

    FluGroupBox {
        Layout.topMargin: 20
        Layout.fillWidth: true
        padding: 10
        title: "convert"
        ColumnLayout {
            FluText {
                text: 'FluPinyin.convert("pin1 yin1", { "format": "numToSymbol" }) --> %1'.arg(FluPinyin.convert("pin1 yin1", { "format": "numToSymbol" }))
            }
            FluText {
                text: 'FluPinyin.convert("pīn yīn", { "format": "symbolToNum" }) --> %1'.arg(FluPinyin.convert("pīn yīn", { "format": "symbolToNum" }))
            }
            FluText {
                text: 'FluPinyin.convert("pīn yīn", { "format": "toneNone" }) --> %1'.arg(FluPinyin.convert("pīn yīn", { "format": "toneNone" }))
            }
        }
    }

    FluGroupBox {
        Layout.topMargin: 20
        Layout.fillWidth: true
        padding: 10
        title: "html"
        ColumnLayout {
            FluText {
                text: 'FluPinyin.html("汉语拼音") --> %1'.arg(FluPinyin.html("汉语拼音"))
            }
            FluText {
                text: 'FluPinyin.html("汉语拼音", { "toneType": "none" }) --> %1'.arg(FluPinyin.html("汉语拼音", { "toneType": "none" }))
            }
        }
    }

    FluGroupBox {
        Layout.topMargin: 20
        Layout.fillWidth: true
        padding: 10
        title: "segment"
        ColumnLayout {
            FluText {
                text: 'FluPinyin.segment("小明硕士毕业于中国科学院计算所") --> \n%1'.arg(JSON.stringify(FluPinyin.segment("小明硕士毕业于中国科学院计算所，后在日本京都大学深造"), null, 2))
            }
        }
    }
}
