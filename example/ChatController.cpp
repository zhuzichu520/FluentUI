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
    request.setRawHeader("Authorization", "Bearer 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");
    QJsonObject requestData;
    requestData.insert("prompt", text);
    requestData.insert("max_tokens", 1000);
    requestData.insert("temperature", 0.5);
    QJsonDocument requestDoc(requestData);
    QByteArray requestDataBytes = requestDoc.toJson();
    QNetworkReply* reply = networkManager->post(request, requestDataBytes);
    connect(reply, &QNetworkReply::finished,this, [=]() {
        QString responseString = QString::fromUtf8(reply->readAll());
        qDebug() << responseString;
        QJsonDocument doc = QJsonDocument::fromJson(responseString.toUtf8());
        QJsonObject jsonObj = doc.object();
        QString text = jsonObj.value("choices").toArray().at(0).toObject().value("text").toString();
        if(text.isEmpty()){
            text = "不好意思，我似乎听不懂您的意思";
        }
        responseData(text);
        reply->deleteLater();
        isLoading(false);
    });
    connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred), this, [=](QNetworkReply::NetworkError) {
        qDebug() << "Network error occurred: " << reply->errorString();
        reply->deleteLater();
        isLoading(false);
    });
}
