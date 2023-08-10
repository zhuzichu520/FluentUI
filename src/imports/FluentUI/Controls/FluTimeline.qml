import QtQuick
import QtQuick.Controls
import FluentUI

Item{
    property var items: []
    id:control

    ListModel{
        id:list_model
    }

    Component.onCompleted: {
        items = [
                    {
                      text: 'Create a services site 2015-09-01',
                    },
                    {
                      text: 'Solve initial network problems 2015-09-01',
                    },
                    {
                      text: 'Technical testing 2015-09-01',
                    },
                    {
                      text: 'Network problems being solved 2015-09-01',
                    },
                  ];
    }

    Column{
        id:layout_column
        Repeater{

            model:list_model
            FluText{
                text: model.text
            }
        }

    }


}
