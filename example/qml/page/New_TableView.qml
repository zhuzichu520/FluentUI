import QtQuick 2.15
import FluentUI 1.0
import "../component"

FluPage{
   title:"表格测试"
   TableView{
       columnSource:  [
           {
               title: "全选",
               dataIndex: 'patientsex',
               width:60,
               readOnly:true,
               position: 0,
               delegate: com_checkbox,
               headerDelegate: com_header_checkbox,
               frozen: true
           },

           {
               title: "检测日期",
               dataIndex: 'testdate',
               readOnly:true,
               //            width:150,
               //            delegate: com_action
           },
           {
               title: "条码号",
               dataIndex: 'barcode',
               width:80,
               readOnly:true,
               position: 0,
               movable: false,
               frozen: true
               //            delegate: com_checkbox,
               //            headerDelegate: com_header_checkbox
           },
           {
               title: "样本号",
               dataIndex: 'sampleid',
               width:100,
               position: 1,
               minimumWidth:100,
               maximumWidth:100,
           },
           {
               title: "姓名",
               dataIndex: 'patientname',
               width:220,
               minimumWidth:100,
               maximumWidth:250
           },
           {
               title:"操作",
               dataIndex:"",
               delegate:com_action,
               frozen: true,
               width: 250
           },
           {
               title: "头像",
               dataIndex: 'imageurl',
               width:120,
               minimumWidth:80,
               maximumWidth:250,
               delegate:com_avatar,
               frozen: true
           },
           {
               title: "性别",
               dataIndex: 'patientsex',
               width:130,
               minimumWidth:50,
               maximumWidth:250,
               //            delegate:com_avatar
           },

           {
               title: "年龄",
               dataIndex: 'patientage',
               width:100,
               minimumWidth:80,
               maximumWidth:330
           },
           {
               title: "电话",
               dataIndex: 'patienttel',
               width:200,
               minimumWidth:100,
               maximumWidth:300,
               editMultiline: true
           },
           {
               title: "身份证号",
               dataIndex: 'patientidenno',
               width:120,
               minimumWidth:100,
               maximumWidth:250
           },
           {
               title: "检测项目",
               dataIndex: 'hisitemnamelist',
               width:120,
               minimumWidth:100,
               maximumWidth:250
           },
           {
               title: "开单科室",
               dataIndex: 'deptname',
               width:150,
               minimumWidth:100,
               maximumWidth:250
           },
           {
               title: "开单医生",
               dataIndex: 'doctorname',
               width:140,
               minimumWidth:100,
               maximumWidth:250
           }
           ,
           {
               title: "接收时间",
               dataIndex: 'incepttime',
               width:120,
               minimumWidth:100,
               maximumWidth:250
           },
           {
               title: "核收时间",
               dataIndex: 'accepttime',
               width:220,
               minimumWidth:100,
               maximumWidth:250
           }
       ]
       model: ListModel{
           id: customModel
       }
   }
   Component.onCompleted: {
       // generateTestData(1000)  // 生成100条测试数据
       for (var i = 0; i < 100000; i++) {
           customModel.append(generateTestData(i))
       }
       // uvRecord.setProperty()
   }
   Component{
       id:com_avatar
       Item{
           anchors.fill: parent
           FluClip{
               anchors.centerIn: parent
               width: Math.min(parent.width,parent.height)
               height: width
               radius: [width/2,width/2,width/2,width/2]
               Image{
                   anchors.fill: parent
                   source: display
                   sourceSize: Qt.size(80,80)
                   fillMode: Image.PreserveAspectFit
               }
           }
       }
   }
   Component {
       id: com_checkbox
       Item{
           FluCheckBox {
               width: 15
               height: 15
               anchors.centerIn: parent
           }
       }
   }
   Component {
       id: com_header_checkbox
       Item{
           FluCheckBox {
               width: 15
               height: 15
               anchors.centerIn: parent
           }
       }
   }
   Component{
       id: com_action
       Item{
           Row{
               anchors.centerIn: parent
               FluTextButton{
                   text:"插入"
                   onClicked: {
                       // uvRecord.insertRecord(row)
                       uvRecord.insert(row,generateTestData(row))
                   }
               }
               FluTextButton{
                   text:"上移"
                   onClicked:{
                       if (row > 0) {
                           uvRecord.move(row, row - 1, 1)
                       }
                   }
               }
               FluTextButton{
                   text:"下移"
                   onClicked:{
                       if (row < uvRecord.rowCount() - 1) {
                           uvRecord.move(row, row + 2, 1)  // 注意这里是 row + 2
                       }
                   }
               }
               FluTextButton{
                   text:"查看"
                   onClicked: {
                       showSuccess(JSON.stringify(control.model.get(row)))
                   }
               }
               FluTextButton{
                   text:"删除"
                   onClicked: {
                       uvRecord.remove(row)
                   }
               }
           }
       }
   }

   function generateTestData(i) {
       var sexes = ["男", "女"]
       var departments = ["内科", "外科", "儿科", "妇科", "眼科"]
       var doctors = ["张医生", "李医生", "王医生", "刘医生", "陈医生"]
       var images = [
                   "qrc:/res/image/pages/exchange.png",
                   "qrc:/res/image/pages/nuclear.png",
                   "qrc:/res/image/pages/ocr.png",
                   "qrc:/res/image/pages/room-temperature.png",
                   "qrc:/res/image/pages/rt-pcr-machine.png"
               ]
       return {
           testdate: new Date().toLocaleDateString(),
           barcode: "BC" + (1000000 + i).toString(),
           sampleid: "S" + (100000 + i).toString(),
           patientname: "患者" + (i + 1),
           patientsex: sexes[Math.floor(Math.random() * sexes.length)],
           patientage: Math.floor(Math.random() * 80 + 1) + "岁",
           patienttel: "1" + Math.floor(Math.random() * 9000000000 + 1000000000),
           patientidenno: (310000000000000000 + i).toString(),
           hisitemnamelist: "项目1,项目2,项目3",
           deptname: departments[Math.floor(Math.random() * departments.length)],
           doctorname: doctors[Math.floor(Math.random() * doctors.length)],
           incepttime: new Date().toLocaleString(),
           accepttime: new Date().toLocaleString(),
           imageurl: images[Math.floor(Math.random() * images.length)],
           _minimumHeight: 42,
           _maximumHeight: 800,
           height: 42
       }

   }

}
