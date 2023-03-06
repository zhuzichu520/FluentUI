pragma Singleton

import QtQuick 2.15

QtObject {

    property color _Black: Qt.rgba(0/255,0/255,0/255,1)
    property color _White: Qt.rgba(255/255,255/255,255/255,1)

    property color _Grey10: Qt.rgba(250/255,249/255,248/255,1)
    property color _Grey20: Qt.rgba(243/255,242/255,241/255,1)
    property color _Grey30: Qt.rgba(237/255,235/255,233/255,1)
    property color _Grey40: Qt.rgba(225/255,223/255,221/255,1)
    property color _Grey50: Qt.rgba(210/255,208/255,206/255,1)
    property color _Grey60: Qt.rgba(200/255,198/255,196/255,1)
    property color _Grey70: Qt.rgba(190/255,187/255,184/255,1)
    property color _Grey80: Qt.rgba(179/255,176/255,173/255,1)
    property color _Grey90: Qt.rgba(161/255,159/255,157/255,1)
    property color _Grey100: Qt.rgba(151/255,149/255,147/255,1)
    property color _Grey110: Qt.rgba(138/255,136/255,134/255,1)
    property color _Grey120: Qt.rgba(121/255,119/255,117/255,1)
    property color _Grey130: Qt.rgba(96/255,94/255,92/255,1)
    property color _Grey140: Qt.rgba(72/255,70/255,68/255,1)
    property color _Grey150: Qt.rgba(59/255,58/255,57/255,1)
    property color _Grey160: Qt.rgba(50/255,49/255,48/255,1)
    property color _Grey170: Qt.rgba(41/255,40/255,39/255,1)
    property color _Grey180: Qt.rgba(37/255,36/255,35/255,1)
    property color _Grey190: Qt.rgba(32/255,31/255,30/255,1)
    property color _Grey200: Qt.rgba(27/255,26/255,25/255,1)
    property color _Grey210: Qt.rgba(22/255,21/255,20/255,1)
    property color _Grey220: Qt.rgba(17/255,16/255,15/255,1)

    property FluColorSetOld _Yellow:FluColorSetOld{
        darkest: Qt.rgba(249/255,168/255,37/255,1)
        darker:Qt.rgba(251/255,192/255,45/255,1)
        dark:Qt.rgba(253/255,216/255,53/255,1)
        normal:Qt.rgba(255/255,235/255,59/255,1)
        light:Qt.rgba(255/255,238/255,88/255,1)
        lighter:Qt.rgba(255/255,241/255,118/255,1)
        lightest:Qt.rgba(255/255,245/255,157/255,1)
    }

    property FluColorSetOld _Orange:FluColorSetOld{
        darkest: Qt.rgba(153/255,61/255,7/255,1)
        darker:Qt.rgba(172/255,68/255,8/255,1)
        dark:Qt.rgba(209/255,84/255,10/255,1)
        normal:Qt.rgba(247/255,99/255,12/255,1)
        light:Qt.rgba(248/255,122/255,48/255,1)
        lighter:Qt.rgba(249/255,145/255,84/255,1)
        lightest:Qt.rgba(250/255,158/255,104/255,1)
    }

    property FluColorSetOld _Red:FluColorSetOld{
        darkest: Qt.rgba(143/255,10/255,21/255,1)
        darker:Qt.rgba(162/255,11/255,24/255,1)
        dark:Qt.rgba(185/255,13/255,28/255,1)
        normal:Qt.rgba(232/255,17/255,35/255,1)
        light:Qt.rgba(236/255,64/255,79/255,1)
        lighter:Qt.rgba(238/255,88/255,101/255,1)
        lightest:Qt.rgba(240/255,107/255,118/255,1)
    }

    property FluColorSetOld _Magenta:FluColorSetOld{
        darkest: Qt.rgba(111/255,0/255,79/255,1)
        darker:Qt.rgba(126/255,0/255,110/255,1)
        dark:Qt.rgba(144/255,0/255,126/255,1)
        normal:Qt.rgba(180/255,0/255,158/255,1)
        light:Qt.rgba(195/255,51/255,177/255,1)
        lighter:Qt.rgba(202/255,76/255,187/255,1)
        lightest:Qt.rgba(208/255,96/255,194/255,1)
    }

    property FluColorSetOld _Purple:FluColorSetOld{
        darkest: Qt.rgba(71/255,47/255,104/255,1)
        darker:Qt.rgba(81/255,53/255,118/255,1)
        dark:Qt.rgba(100/255,66/255,147/255,1)
        normal:Qt.rgba(116/255,77/255,169/255,1)
        light:Qt.rgba(134/255,100/255,180/255,1)
        lighter:Qt.rgba(157/255,130/255,194/255,1)
        lightest:Qt.rgba(168/255,144/255,201/255,1)
    }

    property FluColorSetOld _Blue:FluColorSetOld{
        darkest: Qt.rgba(0/255,74/255,131/255,1)
        darker:Qt.rgba(0/255,84/255,148/255,1)
        dark:Qt.rgba(0/255,102/255,180/255,1)
        normal:Qt.rgba(0/255,120/255,212/255,1)
        light:Qt.rgba(38/255,140/255,218/255,1)
        lighter:Qt.rgba(76/255,160/255,224/255,1)
        lightest:Qt.rgba(96/255,171/255,228/255,1)
    }

    property FluColorSetOld _Teal:FluColorSetOld{
        darkest: Qt.rgba(0/255,110/255,91/255,1)
        darker:Qt.rgba(0/255,124/255,103/255,1)
        dark:Qt.rgba(0/255,151/255,125/255,1)
        normal:Qt.rgba(0/255,178/255,148/255,1)
        light:Qt.rgba(38/255,189/255,164/255,1)
        lighter:Qt.rgba(76/255,201/255,180/255,1)
        lightest:Qt.rgba(96/255,207/255,188/255,1)
    }

    property FluColorSetOld _Green:FluColorSetOld{
        darkest: Qt.rgba(9/255,76/255,9/255,1)
        darker:Qt.rgba(12/255,93/255,12/255,1)
        dark:Qt.rgba(14/255,111/255,14/255,1)
        normal:Qt.rgba(16/255,124/255,16/255,1)
        light:Qt.rgba(39/255,137/255,39/255,1)
        lighter:Qt.rgba(75/255,156/255,75/255,1)
        lightest:Qt.rgba(106/255,173/255,106/255,1)
    }
}
