import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import FluentUI 1.0

FluScrollablePage{

    title:"Carousel"



    FluCarousel{
        id:carousel

        Component.onCompleted: {
            carousel.setData([{color:"#000000"},{color:"#FFFFFF"},{color:"#666666"}])
        }

    }
}
