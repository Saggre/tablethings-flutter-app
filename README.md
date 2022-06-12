# QR-code Restaurant Menu App (WIP)

**This project has been abandoned since 2020.** In order to continue, the project needs to be documented and refactored
for more robust coding standards, and to work with a more recent Flutter version. It's not recommended trying to compile
the project before this has been done.

The app makes it easy for customers to order from a restaurant simply by scanning a qr-code present at the table.
Restaurants will appreciate receiving notifications about new customers and orders in real time.

## User flow

1. A customer enters the restaurant and is seated at a table.
2. The customer scans a QR-code present at the table. If the customer does not have this application installed, the
   customer will be prompted to install it (this is up to the scanned website to execute).
3. The app opens to the restaurant's menu, and a new customer session starts automatically.
4. The restaurant will receive a notification after the customer has completed their order in the app, which includes
   all the necessary order details, for example, order lines and customer table number.
5. The customer can at any point make a new order, that will be sent to the restaurant right away.
6. The app uses GPS to automatically detect when customers have left the restaurant, so the restaurant can be notified
   for cleaning and seating capacity control.
7. After the transaction is complete, it will be visible in the customer's order list.

## QR-code

QR-codes are scanned with `firebase-ml-vision` using `firebase-ml-vision-barcode-model`.

The QR-code contains a url of the following form:
`https://<app-domain>/<restaurant-id>/<table-id>/`

- `restaurant-id` is an identifier assigned to each restaurant.
- `table-id` is an identifier assigned to each table in the aforementioned restaurant.

## Application design

The app uses BLoC pattern via the `bloc` library and implements it with `flutter_bloc` state-reactive components.

## Development

### Update launcher icon using `flutter_launcher_icons`

- `flutter pub run flutter_launcher_icons:main`

### Update db models using `json_annotation`

- `flutter pub run build_runner build`

## UI Designs / Screenshots

<p float="left">
  <img alt="" src="https://i.imgur.com/KCqynts.png" width="300" />
  <img alt="" src="https://i.imgur.com/lgUG4HG.png" width="300" />
  <img alt="" src="https://i.imgur.com/0xsJJCo.png" width="300" />
  <img alt="" src="https://i.imgur.com/QcUVccu.png" width="300" />
  <img alt="" src="https://i.imgur.com/Woe1x0A.png" width="300" />
</p>

