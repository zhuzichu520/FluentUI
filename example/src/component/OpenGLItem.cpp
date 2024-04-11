#include "OpenGLItem.h"

#include <QOpenGLFramebufferObjectFormat>
#include <QOpenGLShaderProgram>

class FBORenderer : public QQuickFramebufferObject::Renderer, protected QOpenGLFunctions {
public:
    explicit FBORenderer(const OpenGLItem *item);

    void render() override;

    QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override;

    QOpenGLShaderProgram program;
    const OpenGLItem *item = nullptr;
};

FBORenderer::FBORenderer(const OpenGLItem *item) {
    this->item = item;
    initializeOpenGLFunctions();
    program.addCacheableShaderFromSourceCode(QOpenGLShader::Vertex,
                                             "attribute highp vec4 vertices;"
                                             "varying highp vec2 coords;"
                                             "void main() {"
                                             "    gl_Position = vertices;"
                                             "    coords = vertices.xy;"
                                             "}");
    program.addCacheableShaderFromSourceCode(QOpenGLShader::Fragment,
                                             "uniform lowp float t;"
                                             "varying highp vec2 coords;"
                                             "void main() {"
                                             "    lowp float i = 1. - (pow(abs(coords.x), 4.) + pow(abs(coords.y), 4.));"
                                             "    i = smoothstep(t - 0.8, t + 0.8, i);"
                                             "    i = floor(i * 20.) / 20.;"
                                             "    gl_FragColor = vec4(coords * .5 + .5, i, i);"
                                             "}");

    program.bindAttributeLocation("vertices", 0);
    program.link();
}

QOpenGLFramebufferObject *FBORenderer::createFramebufferObject(const QSize &size) {
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    format.setSamples(4);
    return new QOpenGLFramebufferObject(size, format);
}

void FBORenderer::render() {
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    program.bind();
    program.enableAttributeArray(0);
    float values[] = {
            -1, -1,
            1, -1,
            -1, 1,
            1, 1
    };
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    program.setAttributeArray(0, GL_FLOAT, values, 2);
    program.setUniformValue("t", (float) item->t());
    glViewport(0, 0, qRound(item->width()), qRound(item->height()));
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    program.disableAttributeArray(0);
    program.release();
}


OpenGLItem::OpenGLItem(QQuickItem *parent) : QQuickFramebufferObject(parent) {
    setMirrorVertically(true);
    startTimer(1);
}

void OpenGLItem::timerEvent(QTimerEvent *) {
    update();
}

void OpenGLItem::setT(qreal t) {
    if (t == m_t)
        return;
    m_t = t;
    emit tChanged();
}


QQuickFramebufferObject::Renderer *OpenGLItem::createRenderer() const {
    return new FBORenderer(this);
}
