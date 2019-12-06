const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.sk);
const express = require('express');
const validate = require('express-jsonschema').validate;
const app = express();
app.use(express.json());

admin.initializeApp(functions.config().firestore);

const db = admin.firestore();
const apiVersion = '/v1';

/**
 * Gets user object with user id
 */
app.get(apiVersion + '/user', validate({
    body: {
        type: 'object',
        properties: {
            id: {
                type: 'string',
                required: true
            },
        }
    },
}), async (req, res) => {
    res.send("Hello from Firebase!");
});

/**
 * Creates and adds a payment method for a Stripe user
 */
app.post(apiVersion + '/payment/add_payment_method', validate({
    body: {
        type: 'object',
        properties: {
            customer: {
                type: 'string',
                required: true
            },
            payment_method: {
                type: 'object',
                required: true
            }
        }
    },
}), async (req, res) => {
    try {
        let paymentMethod = await stripe.paymentMethods.create(
            req.body.payment_method
        );

        await stripe.paymentMethods.attach(
            paymentMethod.id,
            {customer: req.body.customer},
        );

        res.sendStatus(200);

    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
});

/**
 * Gets all payment methods for a Stripe customer
 */
app.post(apiVersion + '/payment/get_payment_methods', validate({
    body: {
        type: 'object',
        properties: {
            customer: {
                type: 'string',
                required: true
            },
            type: {
                type: 'string',
                required: true
            }
        }
    },
}), async (req, res) => {
    try {
        let paymentMethods = await stripe.paymentMethods.list(
            req.body
        );

        res.status(200).json(paymentMethods);

    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
});

/**
 * Called on firebase user create
 * Creates a Stripe customer and adds user data to firestore
 * @type {CloudFunction<UserRecord>}
 */
exports.createUserData = functions.auth.user().onCreate(async (user) => {
    let userObject = {
        displayName: user.displayName || "",
        email: user.email || "",
        stripeCustomerId: "",
    };

    try {
        let customer = await stripe.customers.create({
            email: user.email,
        });

        userObject.stripeCustomerId = customer.id;
    } catch (err) {
        console.log('Error adding Stripe customer: ' + err);
    }

    await db.collection('users').doc(user.uid).set(userObject).catch(err => {
        console.log('Error writing document: ' + err);
        return false;
    });
});

/*
exports.user = functions.https.onRequest(async (request, response) => {
    const request_response = await request({
        uri: WEBHOOK_URL,
        method: 'POST',
        json: true,
        body: snap.val(),
        resolveWithFullResponse: true,
    });
    if (response.statusCode >= 400) {
        throw new Error(`HTTP Error: ${response.statusCode}`);
    }
    console.log('SUCCESS! Posted', snap.ref);
});
*/

/**
 * Catch-all error
 */
app.get('*', function (req, res) {
    res.status(404).json(getErrorJson("Error"));
});

function getErrorJson(errorMsg = "An unknown error occurred") {
    return {error: true, error_msg: errorMsg};
}

exports.api = functions.https.onRequest(app);