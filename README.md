# Ruokamenu

## Customer-eater app version

### Views

**Map view**
Map view is the application's main view. Map view contains a map, and fetches the locations and other data of customer-restaurants to show on the map.
-> **Restaurant class**

**Scanner view**
In the scanner view, a user is able to scan a qr-code. The QR-code contains information laid out in the QR-code section.

## QR-code

The QR-code contains an url in the following form:
https://domain.com/restaurant-id/table-id/
This url should be parsed without entering the url to minimize traffic.

**Restaurant ID** is an ID assigned to each customer-restaurant.

**Table ID** is an ID assigned to each table in the aforementioned restaurant.

## Database structure