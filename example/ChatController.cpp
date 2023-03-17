#include "ChatController.h"

ChatController::ChatController(QObject *parent)
    : QObject{parent}
{
    isLoading(false);
    networkManager = new QNetworkAccessManager(this);
}

void ChatController::sendMessage(const QString& text){
    isLoading(true);
    QUrl apiUrl("https://api.openai.com/v1/engines/text-davinci-003/completions");
    QNetworkRequest request(apiUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString::fromStdString("Bearer %1").arg(QString::fromUtf8(QByteArray::fromBase64(baseKey.toUtf8()))).toUtf8());
    QJsonObject requestData;
    requestData.insert("prompt", text);
    requestData.insert("max_tokens", 1000);
    requestData.insert("temperature", 0.5);
    QJsonDocument requestDoc(requestData);
    QByteArray requestDataBytes = requestDoc.toJson();
    QNetworkReply* reply = networkManager->post(request, requestDataBytes);
    connect(reply, &QNetworkReply::finished,this, [=]() {
        if (reply->error() == QNetworkReply::NoError) {
            QString responseString = QString::fromUtf8(reply->readAll());
            qDebug() << responseString;
            QJsonDocument doc = QJsonDocument::fromJson(responseString.toUtf8());
            QJsonObject jsonObj = doc.object();
            QString text = jsonObj.value("choices").toArray().at(0).toObject().value("text").toString();
            if(text.isEmpty()){
                text = "不好意思，我似乎听不懂您的意思";
            }
            responseData(text);
        } else {
            responseData("网络错误："+reply->errorString());
        }
        isLoading(false);
        reply->deleteLater();
    });
}
