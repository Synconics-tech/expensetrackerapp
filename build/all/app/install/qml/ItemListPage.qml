import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2  // Import Dialogs module

Page {
    id: itemListPage
    anchors.fill: parent

    // Container for ListView
    Rectangle {
        id: listViewContainer
        anchors.centerIn: parent  // Center the container
        width: parent.width * 0.9
        height: parent.height * 0.75
        color: "white"  // Background color of the container
        border.color: "lightgray"
        border.width: 1
        radius: 10
        clip: true  // Ensures the content doesn't overflow outside the container

        // ListView for displaying items
        ListView {
            id: itemListView
            anchors.fill: parent  // Fill the container
            model: itemsModel

            // Header Row for the ListView
            header: Item {
                width: itemListView.width
                height: 40

                Row {
                    spacing: 20  // Set spacing between headers
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        text: "Date & Time"
                        font.bold: true
                        width: itemListView.width * 0.3 // Adjusted width
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                        
                    
                        
                    }
                    // Header for Item Name
                    Text {
                        text: "Items"
                        font.bold: true
                        width: itemListView.width * 0.2 // Adjusted width
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                    }

                    // Header for Item Amount
                    Text {
                        text: "Amount"
                        font.bold: true
                        width: itemListView.width * 0.15 // Adjusted width
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                    }

                    // Header for Delete
                    Text {
                        text: "Delete"
                        font.bold: true
                        width: 40  // Fixed width for delete button
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                    }
                }
            }

            delegate: Item {
                width: itemListView.width
                height: 50

                Row {
                    spacing: 20  // Set spacing between items
                    anchors.verticalCenter: parent.verticalCenter
                    
                    ColumnLayout {
                        width: itemListView.width * 0.3 // Total width for date and time

                        // Date
                        Text {
                            text: modelData.dateAdded.split(" ")[0]  // Display only the date part
                            Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                        }

                        // Time
                        Text {
                            text: modelData.dateAdded.split(" ")[1]  // Display only the time part
                            font.pixelSize: 12
                            color: "gray"
                            Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                        }
                    }

                    // Item Name
                    Text {
                        text: modelData.itemName
                        width: itemListView.width * 0.2 // Adjusted width
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
                    }

                    // Item Amount
                    Text {
                        text: "₹ " + modelData.itemAmount
                        width: itemListView.width * 0.15 // Adjusted width
                        Layout.alignment: Qt.AlignHCenter  // Use Layout.alignment instead
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
                                deleteIndex = index  // Store the index of the item to delete
                                confirmationDialog.open()  // Open the confirmation dialog
                            }
                        }
                    }
                }
            }
        }
    }

    // Row for Back and Save buttons
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        anchors.bottomMargin: 20

        // Back button at the bottom
        Button {
            text: i18n.tr("Back")
            background: Rectangle {
                color: "skyblue"
                radius: 5
            }
            width: units.gu(14)  // Increase width
            height: units.gu(5)  // Increase height
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
            width: units.gu(14)  // Increase width
            height: units.gu(5)  // Increase height
            onClicked: {
                python.call('example.saveToCSV', [], function() {
                    console.log("Data saved to CSV.");
                    saveConfirmationDialog.open();  // Open the "List saved" dialog after saving
                });
            }
        }
    }

    // Confirmation Dialog for deletion
    MessageDialog {
        id: confirmationDialog
        title: "Delete Confirmation"
        text: "Are you sure you want to delete this item?"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            python.call('example.removeItem', [deleteIndex], function() {
                python.call('example.getItemsModel', [], function(result) {
                    itemsModel = result;  // Update itemsModel after deletion
                });
            });
            confirmationDialog.close();
        }
        onNo: {
            confirmationDialog.close();
        }
    }

    // Dialog to show when the list is saved
    MessageDialog {
        id: saveConfirmationDialog
        title: "Save Confirmation"
        text: "List saved successfully."
    }

    property int deleteIndex: -1  // Store the index of the item to delete
}
