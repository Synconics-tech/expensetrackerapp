import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.3
import io.thp.pyotherside 1.4

Page {
    id: itemTablePage
    width: parent.width
    height: parent.height
    anchors.fill: parent

    // Header for the table
    Text {
        id: header
        text: "Items Table"
        font.bold: true
        font.pointSize: 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 10
    }

    // Header row for the table columns
    GridLayout {
        id: headerRow
        columns: 3
        rowSpacing: 10
        columnSpacing: 20
        anchors.top: header.bottom
        anchors.topMargin: 20
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            text: "Item Name"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        Label {
            text: "Item Amount"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        Label {
            text: "Action"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }

    // Scrollable area for the table content
    ScrollView {
        anchors {
            top: headerRow.bottom
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }
        width: parent.width * 0.9
        clip: true

        // Column to hold the table content
        Column {
            spacing: 10
            width: parent.width * 0.9

            // Repeater to display the list of items from the itemsModel
            Repeater {
                model: itemsModel

                GridLayout {
                    columns: 3
                    rowSpacing: 10
                    columnSpacing: 20
                    width: parent.width * 0.9

                    // Item Name
                    Text {
                        text: modelData.itemName
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    // Item Amount
                    Text {
                        text: "₹ " + modelData.itemAmount
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    // Delete button
                    Button {
                        background: Rectangle {
                            color: "transparent"
                        }
                        padding: 8
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Image {
                            source: "file:///home/vboxuser/Desktop/trail/assets/delete.png"
                            width: 24
                            height: 24
                        }
                        onClicked: {
                            python.call('example.removeItem', [index], function() {
                                python.call('example.getItemsModel', [], function(result) {
                                    itemsModel = result;  // Update itemsModel after deleting an item
                                });
                            });
                        }
                    }
                }
            }
        }
    }

    // Row for Back and Share buttons at the bottom
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 20
        padding: 20

        Button {
            text: "Back"
            background: Rectangle {
                color: "#87CEFA"
                radius: 10
            }
            font.bold: true
            font.pixelSize: 16
            padding: 10
            onClicked: {
                pageStack.pop();
            }
        }

        Button {
            text: "Share"
            background: Rectangle {
                color: "green"
                radius: 10
            }
            font.bold: true
            font.pixelSize: 16
            padding: 10
            onClicked: {
                console.log("Share functionality to be implemented");
            }
        }
    }
}
