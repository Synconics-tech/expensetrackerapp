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

    width: units.gu(45)
    height: units.gu(75)

    PageStack {
        id: pageStack

        // First Page: For adding items and viewing the list
        Page {
            id: firstPage
            anchors.fill: parent

            header: PageHeader {
                id: header
                title: i18n.tr('Expenses Reporting App')
            }

            // Center the Column in the Page
            Column {
                anchors.centerIn: parent
                spacing: units.gu(2)

                // Input for item name
                TextField {
                    id: itemNameInput
                    placeholderText: i18n.tr("Item Name")
                    color: "black"
                    width: units.gu(30)
                }

                // Input for item amount
                TextField {
                    id: itemAmountInput
                    placeholderText: i18n.tr("Item Amount (in ₹)")
                    color: "black"
                    inputMethodHints: Qt.ImhDigitsOnly
                    width: units.gu(30)
                }

                // Warning Label for missing input
                Label {
                    id: warningLabel
                    text: ""
                    color: "red"
                    visible: false
                }

                // Row for Add and Save buttons
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Add Button
                    Button {
                        text: i18n.tr("Add")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        onClicked: {
                            if (itemNameInput.text === "" || itemAmountInput.text === "") {
                                warningLabel.text = i18n.tr("Please fill in both the Item Name and Item Amount.")
                                warningLabel.visible = true
                            } else {
                                python.call('example.addItem', [itemNameInput.text, itemAmountInput.text], function() {
                                    itemNameInput.text = ""
                                    itemAmountInput.text = ""
                                    warningLabel.visible = false

                                    // Refresh items model after adding an item
                                    python.call('example.getItemsModel', [], function(result) {
                                        itemsModel = result;
                                    })
                                })
                            }
                        }
                    }

                    // Save Button
                    Button {
                        text: i18n.tr("Share")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        onClicked: {
                             console.log("share function not implemented.");
                        }
                    }
                }

                // Row for Total and Share buttons
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Total Button
                    Button {
                        id: totalButton
                        text: i18n.tr("Total: ₹ 0.00")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        onClicked: {
                            python.call('example.calculateTotal', [], function(result) {
                                totalButton.text = i18n.tr("Total: ₹ ") + result.toFixed(2);
                            })
                        }
                    }
                }

                // Navigation Button to go to the Item List Page
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: i18n.tr("View List")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5
                        }
                        onClicked: {
                            pageStack.push(itemlistPage)
                        }
                    }
                }
            }
        }

        // Item List page
        Component {
            id: itemlistPage
            ItemListPage {
                id: listPage
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

            python.call('example.getItemsModel', [], function(model) {
                itemsModel = model;
            });
        }

        onError: {
            console.log("Python error: " + traceback);
        }
    }

    // Global property for the item model
    property var itemsModel: null

    Connections {
        target: python
        onTotalAmountChanged: function(value) {
            totalButton.text = i18n.tr("Total: ₹ ") + value.toFixed(2);
        }
    }
}
