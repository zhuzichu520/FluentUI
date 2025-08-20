import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage {

    title: qsTr("Pinyin")

    property var pinyinCache: null
    property var matchingData: []
    property string elapsedStr: "0ms"

    Component.onCompleted: {
        FluPinyin.buildDefaultPatterns()
        const chineseWords = ["中国", "北京", "上海", "广州", "深圳", "杭州", "成都", "你好", "谢谢", "再见", "请问", "名字", "朋友", "学习", "天气", "今天", "明天", "昨天", "时间", "星期", "早上", "中文", "拼音", "输入法", "计算机", "手机", "电视", "音乐", "旅游", "美食", "餐厅", "医院", "学校", "工作", "工资", "重要", "快乐", "幸福", "爱情", "家庭", "孩子", "父母", "银行", "行长", "长大", "重量", "重新", "重庆", "长城", "苹果", "香蕉", "西瓜", "草莓", "咖啡", "茶", "啤酒", "汽车", "飞机", "地铁", "自行车", "出租车", "公交", "走路"]
        box_pinyin.items = chineseWords.map(text => ({
                                                         [box_pinyin.textRole]: text
                                                     }))
        matchingData = ["成吉思汗", "四通八达", "一模一样", "青藏高原", "阿弥陀佛", "解放思想", "所作所为", "迷迷糊糊", "荷枪实弹", "兴高采烈", "无能为力", "布鲁塞尔", "为所欲为", "克什米尔", "没完没了", "不为人知", "结结巴巴", "前仆后继", "铺天盖地", "直截了当", "供不应求", "御史大夫", "不为瓦全", "不可收拾", "胡作非为", "分毫不差", "模模糊糊", "不足为奇", "悄无声息", "了如指掌", "深恶痛绝", "高高兴兴", "唉声叹气", "汉藏语系", "处心积虑", "泣不成声", "半夜三更", "失魂落魄", "二十八宿", "转来转去", "数以万计", "相依为命", "恋恋不舍", "屈指可数", "神出鬼没", "结结实实", "有的放矢", "叽哩咕噜", "调兵遣将", "载歌载舞", "转危为安", "踏踏实实", "桑给巴尔", "装模作样", "见义勇为", "相差无几", "叹为观止", "闷闷不乐", "喜怒哀乐", "鲜为人知", "张牙舞爪", "为非作歹", "含糊其辞", "疲于奔命", "勉为其难", "依依不舍", "顶头上司", "不着边际", "大模大样", "寻欢作乐", "一走了之", "字里行间", "含含糊糊", "恰如其分", "破涕为笑", "深更半夜", "千差万别", "数不胜数", "据为己有", "天旋地转", "养尊处优", "玻璃纤维", "吵吵闹闹", "晕头转向", "土生土长", "宁死不屈", "不省人事", "尽力而为", "精明强干", "唠唠叨叨", "叽叽喳喳", "功不可没", "锲而不舍", "排忧解难", "稀里糊涂", "各有所长", "的的确确", "哄堂大笑", "听而不闻", "刀耕火种", "内分泌腺", "化险为夷", "百发百中", "重见天日", "反败为胜", "一了百了", "大大咧咧", "心急火燎", "粗心大意", "鸡皮疙瘩", "夷为平地", "日积月累", "设身处地", "投其所好", "间不容发", "人满为患", "穷追不舍", "为时已晚", "如数家珍", "心里有数", "以牙还牙", "神不守舍", "孟什维克", "各自为战", "怨声载道", "救苦救难", "好好先生", "怪模怪样", "抛头露面", "游手好闲", "无所不为", "调虎离山", "步步为营", "好大喜功", "众矢之的", "长生不死", "蔚为壮观", "不可胜数", "鬼使神差", "洁身自好", "敢作敢为", "茅塞顿开", "走马换将", "为时过早", "为人师表", "阴差阳错", "油腔滑调", "重蹈覆辙", "骂骂咧咧", "絮絮叨叨", "如履薄冰", "损兵折将", "拐弯抹角", "像模像样", "供过于求", "开花结果", "仔仔细细", "川藏公路", "河北梆子", "长年累月", "正儿八经", "不识抬举", "重振旗鼓", "气息奄奄", "紧追不舍", "服服帖帖", "强词夺理", "噼里啪啦", "人才济济", "发人深省", "不足为凭", "为富不仁", "连篇累牍", "呼天抢地", "落落大方", "自吹自擂", "乐善好施", "以攻为守", "磨磨蹭蹭", "削铁如泥", "助纣为虐", "以退为进", "嘁嘁喳喳", "枪林弹雨", "令人发指", "转败为胜", "转弯抹角", "在劫难逃", "正当防卫", "不足为怪", "难兄难弟", "咿咿呀呀", "弹尽粮绝", "阿谀奉承", "稀里哗啦", "返老还童", "好高骛远", "鹿死谁手", "差强人意", "大吹大擂", "成家立业", "自怨自艾", "负债累累", "古为今用", "入土为安", "下不为例", "一哄而上", "没头苍蝇", "天差地远", "风卷残云", "多灾多难", "乳臭未干", "行家里手", "狼狈为奸", "处变不惊", "一唱一和", "一念之差", "金蝉脱壳", "滴滴答答", "硕果累累", "好整以暇", "红得发紫", "传为美谈", "富商大贾", "四海为家", "了若指掌", "大有可为", "出头露面", "鼓鼓囊囊", "窗明几净", "泰然处之", "怒发冲冠", "有机玻璃", "骨头架子", "义薄云天", "一丁点儿", "时来运转", "陈词滥调", "化整为零", "火烧火燎", "干脆利索", "吊儿郎当", "广种薄收", "种瓜得瓜", "种豆得豆", "难舍难分", "歃血为盟", "奋发有为", "阴错阳差", "东躲西藏", "烟熏火燎", "钻牛角尖", "乔装打扮", "改弦更张", "河南梆子", "好吃懒做", "何乐不为", "大出风头", "攻城掠地", "漂漂亮亮", "折衷主义", "大马哈鱼", "绿树成荫", "率先垂范", "家长里短", "宽大为怀", "左膀右臂", "一笑了之", "天下为公", "还我河山", "何足为奇", "好自为之", "风姿绰约", "大雨滂沱", "传为佳话", "吃里扒外", "重操旧业", "小家子气", "少不更事", "难分难舍", "添砖加瓦", "是非分明", "舍我其谁", "偏听偏信", "量入为出", "降龙伏虎", "钢化玻璃", "正中下怀", "以身许国", "一语中的", "丧魂落魄", "三座大山", "济济一堂", "好事之徒", "干净利索", "出将入相", "袅袅娜娜", "狐狸尾巴", "好逸恶劳", "大而无当", "打马虎眼", "板上钉钉", "吆五喝六", "虾兵蟹将", "水调歌头", "数典忘祖", "人事不省", "曲高和寡", "屡教不改", "互为因果", "互为表里", "厚此薄彼", "过关斩将", "疙疙瘩瘩", "大腹便便", "走为上策", "冤家对头", "有隙可乘", "一鳞半爪", "片言只语", "开花结实", "经年累月", "含糊其词", "寡廉鲜耻", "成年累月", "不徇私情", "不当人子", "膀大腰圆", "指腹为婚", "这么点儿", "意兴索然", "绣花枕头", "无的放矢", "望闻问切", "舍己为人", "穷年累月", "排难解纷", "处之泰然", "指鹿为马", "危如累卵", "天兵天将", "舍近求远", "南腔北调", "苦中作乐", "厚积薄发", "臭味相投", "长幼有序", "逼良为娼", "悲悲切切", "败军之将", "欺行霸市", "削足适履", "先睹为快", "啼饥号寒", "疏不间亲", "神差鬼使", "敲敲打打", "平铺直叙", "没头没尾", "寥寥可数", "哼哈二将", "鹤发童颜", "各奔前程", "弹无虚发", "大人先生", "与民更始", "树碑立传", "是非得失", "实逼处此", "塞翁失马", "日薄西山", "切身体会", "片言只字", "跑马卖解", "宁折不弯", "零零散散", "量体裁衣", "连中三元", "礼崩乐坏", "不为已甚", "转悲为喜", "以眼还眼", "蔚为大观", "未为不可", "童颜鹤发", "朋比为奸", "莫此为甚", "夹枪带棒", "富商巨贾", "淡然处之", "箪食壶浆", "创巨痛深", "草长莺飞", "坐视不救", "以己度人", "随行就市", "文以载道", "文不对题", "铁板钉钉", "身体发肤", "缺吃少穿", "目无尊长", "吉人天相", "毁家纾难", "钢筋铁骨", "丢卒保车", "丢三落四", "闭目塞听", "削尖脑袋", "为非作恶", "人才难得", "情非得已", "切中要害", "火急火燎", "画地为牢", "好酒贪杯", "长歌当哭", "载沉载浮", "遇难呈祥", "榆木疙瘩", "以邻为壑", "洋为中用", "言为心声", "言必有中", "图穷匕见", "滂沱大雨", "目不暇给", "量才录用", "教学相长", "悔不当初", "呼幺喝六", "不足为训", "不拘形迹", "傍若无人", "罪责难逃", "自我吹嘘", "转祸为福", "勇冠三军", "易地而处", "卸磨杀驴", "玩儿不转", "天道好还", "身单力薄", "撒豆成兵", "片纸只字", "宁缺毋滥", "没没无闻", "量力而为", "历历可数", "口碑载道", "君子好逑", "好为人师", "豪商巨贾", "各有所好", "度德量力", "指天为誓", "逸兴遄飞", "心宽体胖", "为德不卒", "天下为家", "视为畏途", "三灾八难", "沐猴而冠", "哩哩啦啦", "见缝就钻", "夹层玻璃", "急公好义", "积年累月", "划地为牢", "更名改姓", "奉为圭臬", "多难兴邦", "不破不立", "坐地自划", "坐不重席", "坐不窥堂", "作嫁衣裳", "左枝右梧", "左宜右有", "钻头觅缝", "钻天打洞", "钻皮出羽", "钻火得冰", "钻洞觅缝", "钻冰求火", "子为父隐", "擢发难数", "着人先鞭", "斫雕为朴", "锥处囊中", "椎心饮泣", "椎心泣血", "椎牛飨士", "椎牛歃血", "椎牛发冢", "椎埋屠狗", "椎埋狗窃", "壮发冲冠", "庄严宝相", "转愁为喜"]
        pinyinCache = FluPinyin.createCache(matchingData, { "continuous": true })
        cache_view.model = matchingData
    }

    function testElapsed(callback) {
        const start = Date.now()
        callback()
        const end = Date.now()
        const duration = end - start;
        return `${duration}ms`
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
                id: box_pinyin
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
                text: 'FluPinyin.segment("汉语拼音") --> \n%1'.arg(JSON.stringify(FluPinyin.segment("汉语拼音")))
            }
        }
    }

    FluGroupBox {
        Layout.topMargin: 20
        Layout.fillWidth: true
        padding: 10
        title: "cache"
        ColumnLayout {
            RowLayout {
                FluTextBox {
                    placeholderText: qsTr("Input Chinese or Pinyin")
                    iconSource: FluentIcons.Search
                    onTextChanged: {
                        if (length === 0) {
                            cache_view.model = matchingData
                            return
                        }
                        if (switch_cache.checked) {
                            elapsedStr = testElapsed(function () {
                                cache_view.model = FluPinyin.findMatches(pinyinCache, text)
                            })
                        } else {
                            elapsedStr = testElapsed(function () {
                                cache_view.model = matchingData.filter(item => FluPinyin.match(item, text, { "continuous": true }))
                            })
                        }
                    }
                }
                FluText {
                    text: qsTr("Matching time: %1").arg(elapsedStr)
                }
                FluToggleSwitch {
                    id: switch_cache
                    checked: true
                    text: qsTr("Matching with cache")
                }
            }
            GridView {
                id: cache_view
                Layout.preferredWidth: 6 * cellWidth
                Layout.preferredHeight: 3 * cellHeight
                cellWidth: 110
                cellHeight: 110
                clip: true
                boundsBehavior: GridView.StopAtBounds
                ScrollBar.vertical: FluScrollBar {}
                delegate: Item {
                    width: 100
                    height: 100
                    FluIconButton {
                        anchors.fill: parent
                        text: modelData
                        display: Button.TextOnly
                        onClicked: {
                            showSuccess(text)
                        }
                    }
                }
            }
        }
    }
}
