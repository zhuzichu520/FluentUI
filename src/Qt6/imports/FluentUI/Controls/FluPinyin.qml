pragma Singleton

import QtQuick
import "./../JS/PinyinPro.mjs" as Pinyin

QtObject {
    property list<QtObject> children
    readonly property var context: Pinyin
    readonly property alias isPatternBuilt: d.isPatternBuilt
    readonly property var outputFormat: Pinyin.OutputFormat
    function buildDefaultPatterns(buildArg) {
        const arg = Object.assign({
                                      "buildAllAtOnce": true,
                                      "sizePerBuild": 500,
                                      "interval": 1500
                                  }, buildArg || {})
        const builder = context.getPatternsNormalBuilder(arg.sizePerBuild)
        if (!builder || d.isPatternBuilt || (d.patternTimer && d.patternTimer.running)) {
            return
        }
        if (arg.buildAllAtOnce) {
            while (!builder.next().done) {

            }
            d.isPatternBuilt = true
        } else {
            d.patternTimer = d.generatorExecutor(builder, () => d.isPatternBuilt = true, arg.interval)
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
    function createCache(data, options, buildCache = true) {
        return context.createCache(data, options, buildCache)
    }
    function rebuildCache(cache, data, asyncArg) {
        cache.data = data
        const arg = Object.assign({
                                      "async": true,
                                      "sizePerBuild": 50,
                                      "interval": 500,
                                      "triggeredOnStart": true
                                  }, asyncArg || {})
        if (arg.async) {
            const timer = d.generatorExecutor(cache.buildGenerator(arg.chunkSize, true, arg.interval, arg.triggeredOnStart))
            if (cache.data.length > arg.chunkSize) {
                cache.generatorDeleter = timer.destroy
            }
        } else {
            cache.build(true)
        }
    }
    function findMatches(cache, pinyin) {
        return context.findMatches(cache, pinyin)
    }
    children: [
        QtObject {
            id: d
            property Timer patternTimer: null
            property bool isPatternBuilt: false
            function generatorExecutor(generator, doneCallback, interval = 500, triggeredOnStart = true) {
                const timer = Qt.createQmlObject("import QtQuick 2.15; Timer {}", Qt.application)
                timer.interval = interval
                timer.triggered.connect(function () {
                    const result = generator.next()
                    if (result.done) {
                        timer.destroy()
                        if (typeof doneCallback === "function") {
                            doneCallback()
                        }
                    } else {
                        timer.start()
                    }
                })
                timer.Component.onDestruction.connect(() => generator = null)
                if (triggeredOnStart) {
                    generator.next()
                }
                timer.start()
                return timer
            }
        }
    ]
}
