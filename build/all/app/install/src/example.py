import csv
import pyotherside
import os
import subprocess
from datetime import datetime

class ItemModel:
    def __init__(self, category_name='default'):
        self.items = []  # List to store expense items
        self.total_amount = 0.0  # Initialize total amount
        self.category_name = category_name  # Store the category name
        self.filepath = f"{self.category_name}_expenses.csv"  # Dynamic filepath based on category
        self.load_from_csv()  # Load existing items from CSV

    def set_category(self, category_name):
        """Set the category name and update the filepath accordingly."""
        self.category_name = category_name
        self.filepath = f"{self.category_name}_expenses.csv"
        self.load_from_csv()  # Reload items from the new file

    def add_item(self, item_name, item_amount):
        """Add a new item to the list and append it to CSV with date and time."""
        try:
            item_amount = float(item_amount)  # Convert amount to float
            if item_name and item_amount > 0:
                # Get the current date and time
                current_time = datetime.now()
                date_added = current_time.strftime("%Y-%m-%d %H:%M:%S")
                time_added = current_time.strftime("%H:%M:%S")

                item = {
                    'dateAdded': date_added,  # Store date
                    'timeAdded': time_added,
                    'itemName': item_name,
                    'itemAmount': item_amount
                }
                self.items.append(item)
                self.calculate_total()  # Update total amount after adding

                # Append the new item to CSV file
                with open(self.filepath, mode='a', newline='') as csvfile:
                    writer = csv.DictWriter(csvfile, fieldnames=['Date Added', 'Time Added', 'Item Name', 'Item Amount'])
                    if csvfile.tell() == 0:  # Write header if file is new
                        writer.writeheader()
                    writer.writerow({
                        'Date Added': date_added,
                        'Time Added': time_added,
                        'Item Name': item_name,
                        'Item Amount': item_amount
                    })

                pyotherside.send('totalAmountChanged', self.total_amount)
                return True  # Indicate successful addition
            else:
                return False  # Invalid data
        except ValueError:
            return False  # Error in conversion to float

    def remove_item(self, index):
        """Remove an item from the list by index and update the CSV."""
        if 0 <= index < len(self.items):
            del self.items[index]
            self.calculate_total()  # Update total amount after removing
            self.save_to_csv()  # Save the updated list to CSV
            pyotherside.send('totalAmountChanged', self.total_amount)
            return True  # Indicate successful removal
        return False  # Invalid index

    def save_to_csv(self):
        """Overwrite the CSV file with the current items."""
        try:
            with open(self.filepath, mode='w', newline='') as csvfile:
                fieldnames = ['Date Added', 'Time Added', 'Item Name', 'Item Amount']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                for item in self.items:
                    writer.writerow({
                        'Date Added': item['dateAdded'],
                        'Time Added': item['timeAdded'],
                        'Item Name': item['itemName'],
                        'Item Amount': item['itemAmount']
                    })
            return True  # Indicate successful save
        except IOError:
            return False  # Error during file write operation

    def load_from_csv(self):
        """Load items from the CSV file at startup."""
        if os.path.exists(self.filepath):
            try:
                with open(self.filepath, mode='r') as csvfile:
                    reader = csv.DictReader(csvfile)
                    self.items = [{
                        'itemName': row['Item Name'],
                        'itemAmount': float(row['Item Amount']),
                        'dateAdded': row['Date Added'],  # Load date
                        'timeAdded': row['Time Added']   # Load time
                    } for row in reader]
                self.calculate_total()  # Recalculate total amount after loading
            except (IOError, ValueError) as e:
                print(f"Error loading items from CSV: {e}")
                self.items = []  # In case of file read or parsing error
        else:
            # Create the CSV file with headers if it doesn't exist
            with open(self.filepath, mode='w', newline='') as csvfile:
                fieldnames = ['Date Added', 'Time Added', 'Item Name', 'Item Amount']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()

    def calculate_total(self):
        """Calculate the total amount of all items."""
        self.total_amount = sum(item['itemAmount'] for item in self.items)
        return self.total_amount

    def get_items_model(self):
        """Return the items list to be used as a model in QML."""
        return self.items

    def get_total_amount(self):
        """Return the current total amount."""
        return self.total_amount

    def get_file_path(self):
        """Return the absolute path to the CSV file."""
        return os.path.abspath(self.filepath)

    def shareCSV(self):
        """Share the CSV file using Thunderbird email."""
        if os.path.exists(self.filepath):
            try:
                # Construct the command to open Thunderbird with the CSV file attached
                subprocess.run(['thunderbird', '-compose', f'attachment="{self.filepath}"'])
                pyotherside.send('shareStatus', True)  # Signal success
                return True  # Indicate successful share
            except Exception as e:
                print(f"Error sharing CSV: {e}")
                pyotherside.send('shareStatus', False)  # Signal failure
                return False  # Indicate failure to share
        pyotherside.send('shareStatus', False)  # CSV file does not exist
        return False

class MainApp:
    def __init__(self):
        self.model = ItemModel()

    def setCategory(self, category_name):
        """Set the category in the item model and update the file path."""
        self.model.set_category(category_name)

    def addItem(self, item_name, item_amount):
        """Add a new item through the app."""
        return self.model.add_item(item_name, item_amount)

    def removeItem(self, index):
        """Remove an item through the app."""
        return self.model.remove_item(index)

    def saveToCSV(self):
        """Save the current items to a CSV file."""
        return self.model.save_to_csv()

    def getItemsModel(self):
        """Get the list of items for displaying in QML."""
        return self.model.get_items_model()

    def calculateTotal(self):
        """Calculate and return the total amount of all items."""
        return self.model.calculate_total()

    def getTotalAmount(self):
        """Return the total amount."""
        return self.model.get_total_amount()

    def shareCSV(self):
        """Share the CSV file using available applications."""
        return self.model.shareCSV()

# Create the main app instance
app = MainApp()

# Expose methods to QML
def setCategory(category_name):
    app.setCategory(category_name)

def addItem(item_name, item_amount):
    return app.addItem(item_name, item_amount)

def removeItem(index):
    return app.removeItem(index)

def saveToCSV():
    return app.saveToCSV()

def getItemsModel():
    return app.getItemsModel()

def calculateTotal():
    return app.calculateTotal()

def getTotalAmount():
    return app.getTotalAmount()

def shareCSV():
    return app.shareCSV()

def getFilePath():
    return app.model.get_file_path()

