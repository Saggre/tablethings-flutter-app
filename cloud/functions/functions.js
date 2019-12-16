const firebaseFunctions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(firebaseFunctions.config().firestore);
const db = admin.firestore();

/**
 * Returns the value of an order in cents
 * @param establishmentId The establishment offering the products
 * @param productIds
 * @returns {Promise<number>}
 */
module.exports.calculateOrderValue = async function (establishmentId, productIds) {
    let orderValue = 0;

    let ref = db.collection('establishments').doc(establishmentId).collection('products');
    let docs = await ref.get();

    docs.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
        const product = doc.data();
        if (productIds.includes(doc.id)) {
            orderValue += product.price;
        }
    });

    return orderValue;
};

/**
 * Gets an establishment by id
 * @param establishmentId
 * @returns {Promise<*>}
 */
module.exports.getEstablishment = async function (establishmentId) {
    let ref = db.collection('establishments').doc(establishmentId);
    let doc = await ref.get();

    return doc.data();
};

/**
 * Gets all establishments
 * @returns {Promise<any[]>}
 */
module.exports.getEstablishments = async function () {
    let establishments = Array();

    let ref = db.collection('establishments');
    let docs = await ref.get();

    docs.forEach(doc => {
        let establishment = doc.data();
        establishment['id'] = doc.id;

        establishments.push(
            establishment
        );
    });

    return establishments;
};

/**
 * Gets all products for an establishment
 * @param establishmentId
 * @returns {Promise<any[]>}
 */
module.exports.getProducts = async function (establishmentId) {
    let products = Array();

    let ref = db.collection('establishments').doc(establishmentId).collection('products');
    let docs = await ref.get();

    docs.forEach(doc => {
        products.push(
            doc.data()
        );
    });

    return products;
};

/**
 * Gets user by id
 * @param userId
 * @returns {Promise<*>}
 */
module.exports.getUser = async function (userId) {
    let ref = db.collection('users').doc(userId);
    let doc = await ref.get();

    return doc.data();
};

/**
 * Adds user
 * @param userObject
 * @returns {Promise<void>}
 */
module.exports.addUser = async function (userObject) {
    let ref = db.collection('users').doc(user.uid);

    await ref.set(userObject);
};


module.exports.db = db;