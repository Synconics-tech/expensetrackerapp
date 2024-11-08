import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import io.thp.pyotherside 1.4
import QtQuick.Controls 2.7

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'smartxpenses.mouli'
    automaticOrientation: true

    property var itemsModel: []  // Define itemsModel as a property

    width: units.gu(45)
    height: units.gu(75)

    ListModel {
        id: categoryModel
        ListElement { name: "Food" }
        ListElement { name: "Travel" }
        ListElement { name: "Shopping" }
        ListElement { name: "Bills" }
        ListElement { name: "Event" }
        ListElement { name: "Other" }
    }

    PageStack {
        id: pageStack

        Page {
            id: firstPage
            anchors.fill: parent

            header: PageHeader {
                id: header
                title: i18n.tr('Expenses Reporting App')
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(2)

                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    ComboBox {
                        id: categoryComboBox
                        width: units.gu(12)  // Adjusted width to match
                        height: units.gu(5)   // Match the height of the item amount input box
                        model: categoryModel
                        textRole: "name"

                        onCurrentIndexChanged: {
                            if (categoryComboBox.currentIndex === 5) {
                                customCategoryDialog.open();  // Open the dialog for custom category
                            }
                        }

                        Text {
                            text: i18n.tr("Select Category")
                            anchors.centerIn: parent
                            visible: categoryComboBox.currentIndex === -1
                        }
                    }

                    TextField {
                        id: itemNameInput
                        placeholderText: i18n.tr("Item Name")
                        color: "black"
                        width: units.gu(21)
                        height: units.gu(5)
                    }
                }

                TextField {
                    id: itemAmountInput
                    placeholderText: i18n.tr("Item Amount (in ₹)")
                    color: "black"
                    
                    inputMethodHints: Qt.ImhDigitsOnly
                    width: units.gu(35)
                    height: units.gu(5)
                }

                Item {
                    width: units.gu(30)
                    height: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label {
                        id: statusLabel
                        text: ""
                        color: "red"
                        visible: false
                        anchors.centerIn: parent
                    }

                    Timer {
                        id: hideStatusTimer
                        interval: 2000
                        repeat: false
                        onTriggered: {
                            statusLabel.visible = false;
                        }
                    }
                }

                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        id: addButton
                        text: i18n.tr("Add")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        width: units.gu(14)
                        height: units.gu(5)

                        MouseArea {
                            anchors.fill: parent

                            onEntered: {
                                addButton.background.color = "deepskyblue";
                            }

                            onExited: {
                                addButton.background.color = "skyblue";
                            }

                            onClicked: {
                                if (itemNameInput.text === "" || itemAmountInput.text === "") {
                                    statusLabel.text = i18n.tr("Please fill in both the Item Name and Item Amount.");
                                    statusLabel.color = "red";  
                                    statusLabel.visible = true;
                                    hideStatusTimer.start();
                                } else {
                                    let addedItemName = itemNameInput.text;

                                    python.call('example.addItem', [itemNameInput.text, itemAmountInput.text], function() {
                                        itemNameInput.text = "";
                                        itemAmountInput.text = "";
                                        statusLabel.text = i18n.tr("Item added successfully: ") + addedItemName;  
                                        statusLabel.color = "green";  
                                        statusLabel.visible = true;
                                        hideStatusTimer.start();  

                                        python.call('example.getItemsModel', [], function(result) {
                                            itemsModel = result;
                                        });
                                    });
                                }
                            }
                        }
                    }

                    Button {
                        id: shareButton
                        text: i18n.tr("Share")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        width: units.gu(14)
                        height: units.gu(5)

                        MouseArea {
                            anchors.fill: parent

                            onEntered: {
                                shareButton.background.color = "deepskyblue";
                            }

                            onExited: {
                                shareButton.background.color = "skyblue";
                            }

                            onClicked: {
                                python.call('example.shareCSV', [], function(result) {
                                    if (result) {
                                        console.log("Email sharing initiated successfully.");
                                    } else {
                                        console.log("Failed to share the file.");
                                    }
                                });
                            }
                        }
                    }
                }

                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        id: totalButton
                        text: i18n.tr("Total: ₹ 0.00")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        width: units.gu(30)
                        height: units.gu(5)

                        MouseArea {
                            anchors.fill: parent

                            onEntered: {
                                totalButton.background.color = "deepskyblue";
                            }

                            onExited: {
                                totalButton.background.color = "skyblue";
                            }

                            onClicked: {
                                python.call('example.calculateTotal', [], function(result) {
                                    totalButton.text = i18n.tr("Total: ₹ ") + result.toFixed(2);
                                });
                            }
                        }
                    }
                }

                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: i18n.tr("View List")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        width: units.gu(30)
                        height: units.gu(5)

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                const selectedCategory = categoryComboBox.currentText !== undefined ? categoryComboBox.currentText : "No Category Selected";
                                pageStack.push(itemlistPage, { model: itemsModel, selectedCategory: selectedCategory });
                            }
                        }
                    }
                }
            }
        }

        Component {
            id: itemlistPage
            ItemListPage {
                id: listPage
                property var model: []  
                property string selectedCategory: ""  

                Column {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: selectedCategory + " Items List"  
                        font.bold: true
                        color: "red"
                        font.pointSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        padding: 20
                    }
                }
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('example', function() {
                console.log("Python module loaded");
            });

            pyotherside.call('getItemsModel', [], function(result) {
                itemsModel = result;
            });
        }
    }
}
