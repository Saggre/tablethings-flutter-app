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

module.exports.getEstablishment = async function (establishmentId) {
    let ref = db.collection('establishments').doc(establishmentId);
    let doc = await ref.get();

    return doc.data();
};

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
    let ref = functions.db.collection('users').doc(userId);
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