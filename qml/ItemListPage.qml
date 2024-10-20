import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.3

Page {
    id: itemListPage
    anchors.fill: parent

    // Page Header
    Text {
        id: header
        text: "Items List"
        font.bold: true
        color: "red"
        font.pointSize: 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 10
    }

    // ListView for displaying items
    ListView {
        id: itemListView
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter  // Center the ListView vertically
        width: parent.width * 0.9
        height: parent.height * 0.75
        model: itemsModel

        // Header Row for the ListView
        header: Item {
            width: itemListView.width
            height: 40

            Row {
                spacing: 20  // Set spacing between headers
                anchors.verticalCenter: parent.verticalCenter

                // Header for Item Name
                Text {
                    text: "Item Name"
                    font.bold: true
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignHCenter
                }

                // Header for Item Amount
                Text {
                    text: "Item Amount"
                    font.bold: true
                    width: parent.width * 0.3
                    horizontalAlignment: Text.AlignHCenter
                }

                // Header for Delete
                Text {
                    text: "Delete"
                    font.bold: true
                    width: 40
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        delegate: Item {
            width: itemListView.width
            height: 50

            Row {
                spacing: 20  // Set spacing between items
                anchors.verticalCenter: parent.verticalCenter

                // Item Name
                Text {
                    text: modelData.itemName
                    width: parent.width * 0.4
                    horizontalAlignment: Text.AlignHCenter
                }

                // Item Amount
                Text {
                    text: "₹ " + modelData.itemAmount
                    width: parent.width * 0.3
                    horizontalAlignment: Text.AlignHCenter
                }

                // Container for Delete Button
                Rectangle {
                    width: 40
                    height: 24
                    color: "transparent"  // Transparent background
                    border.color: "red"
                    radius: 5

                    Image {
                        anchors.centerIn: parent
                        source: "file:///home/vboxuser/Desktop/trail/assets/delete.png"
                        width: 24
                        height: 24
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            python.call('example.removeItem', [index], function() {
                                python.call('example.getItemsModel', [], function(result) {
                                    itemsModel = result;  // Update itemsModel after deletion
                                });
                            });
                        }
                    }
                }
            }
        }
    }

    Row {
        anchors.bottom: itemListView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        // Back button at the bottom
        Button {
            text: i18n.tr("Back")
            background: Rectangle {
                color: "skyblue"
                radius: 5
            }
            onClicked: {
                pageStack.pop();
            }
        }

        // Save button
        Button {
            text: i18n.tr("Save")
            background: Rectangle {
                color: "skyblue"
                radius: 5
            }
            onClicked: {
                python.call('example.saveToCSV', [], function() {
                    console.log("Data saved to CSV.");
                });
            }
        }
    }
}
