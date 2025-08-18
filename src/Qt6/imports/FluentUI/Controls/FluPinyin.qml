pragma Singleton

import QtQuick
import "./../JS/PinyinPro.mjs" as Pinyin

QtObject {
    property list<QtObject> children
    readonly property var context: Pinyin
    property int patternValue: 500 // In "size" mode, number of patterns per build; in "group" mode, number of groups to divide patterns into
    property string patternBuildMode: "size" // size, group
    property alias patternBuildInterval: patternTimer.interval
    readonly property alias isPatternBuilt: d.isPatternBuilt
    readonly property var outputFormat: Pinyin.OutputFormat
    function buildPattern(buildAllAtOnce = true) {
        if (d.isPatternBuilt || patternTimer.running) {
            return
        }
        d.builder = context.getPatternsNormalBuilder(patternValue,
                                                     patternBuildMode)
        if (buildAllAtOnce) {
            while (!d.buildNext()) {

            }
            d.builder = null
            d.isPatternBuilt = true
        } else {
            patternTimer.start()
        }
    }
    function addDict(dict, options) {
        context.addDict(dict, options)
    }
    function clearCustomDict(dict) {
        context.clearCustomDict(dict)
    }
    function convert(pinyin, options) {
        return context.convert(pinyin, options)
    }
    function customPinyin(config = {}, options) {
        context.customPinyin(config, options)
    }
    function html(text, options) {
        return context.html(text, options)
    }
    function match(text, pinyin, options) {
        return context.match(text, pinyin, options)
    }
    function pinyin(word, options) {
        return context.pinyin(word, options)
    }
    function removeDict(dictName) {
        context.removeDict(dictName)
    }
    function segment(word, options) {
        return context.segment(word, options)
    }
    children: [
        QtObject {
            id: d
            property bool isPatternBuilt: false
            property var builder: null
            function buildNext() {
                return d.builder.next().done
            }
        },
        Timer {
            id: patternTimer
            interval: 1500
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                if (d.buildNext()) {
                    d.builder = null
                    d.isPatternBuilt = true
                    stop()
                }
            }
        }
    ]
}
