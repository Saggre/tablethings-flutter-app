const firebaseFunctions = require('firebase-functions');
const stripe = require('stripe')(firebaseFunctions.config().stripe.sk);
const express = require('express');
const validate = require('express-jsonschema').validate;
const app = express();
const functions = require('./functions.js');

app.use(express.json());

const apiVersion = '/v1';

/**
 * Gets user object with user id
 */
app.post(apiVersion + '/user/get_user', validate({
    body: {
        type: 'object',
        properties: {
            user_id: {
                type: 'string',
                required: true
            },
        }
    },
}), async (req, res) => {
    try {
        let userId = req.body.user_id;
        let user = await functions.getUser(userId);

        if (!doc.exists) {
            throw Error('User doesn\'t exist');
        } else {
            console.log('Got user for id:', userId);

            let stripeCustomerId = user.stripeCustomerId;

            if (!stripeCustomerId) {
                // TODO create a stripe customer id?
                throw Error('User doesn\'t have a stripe client id');
            }

            try {
                user.stripeCustomer = await stripe.customers.retrieve(
                    stripeCustomerId
                );

                delete user.stripeCustomerId;
            } catch (err) {
                throw Error(err.message);
            }
        }

        res.status(200).json(user);

    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
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
        const paymentMethod = await stripe.paymentMethods.create(
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
 * Gets a single payment method by id
 */
app.post(apiVersion + '/payment/get_payment_method', validate({
    body: {
        type: 'object',
        properties: {
            payment_method_id: {
                type: 'string',
                required: true
            }
        }
    },
}), async (req, res) => {
    try {
        const paymentMethod = await stripe.paymentMethods.retrieve(
            req.body.payment_method_id
        );

        res.status(200).json(paymentMethod);

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
        const paymentMethods = await stripe.paymentMethods.list(
            req.body
        );

        res.status(200).json(paymentMethods);

    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
});

app.post(apiVersion + '/payment/get_order_value', validate({
    body: {
        type: 'object',
        properties: {
            establishment_id: {
                type: 'string',
                required: true
            },
            product_ids: {
                type: 'array',
                required: true
            }
        }
    },
}), async (req, res) => {
    try {
        const orderValue = await functions.calculateOrderValue(req.body.establishment_id, req.body.product_ids);
        res.status(200).json(orderValue);
    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
});

app.post(apiVersion + '/payment/create_session', validate({
    body: {
        type: 'object',
        properties: {
            establishment_id: {
                type: 'string',
                required: true
            },
            product_ids: {
                type: 'array',
                required: true
            },
            customer_id: {
                type: 'string',
                required: true
            }
        }
    },
}), async (req, res) => {
    try {

        const checkoutPrice = functions.calculateOrderValue(req.body.establishment_id, req.body.product_ids);

        const paymentIntent = await stripe.paymentIntents.create({
            amount: checkoutPrice,
            currency: 'eur',
            payment_method_types: ['card'],
            metadata: {order_id: 6735},
        });

        res.status(200).json(paymentIntent);

    } catch (err) {
        res.status(500).json(getErrorJson(err.message));
    }
});


/**
 * Called on firebase user create
 * Creates a Stripe customer and adds user data to firestore
 * @type {CloudFunction<UserRecord>}
 */
exports.createUserData = firebaseFunctions.auth.user().onCreate(async (user) => {
    let userObject = {
        displayName: user.displayName || "",
        email: user.email || "",
        stripeCustomerId: "",
    };

    try {
        const customer = await stripe.customers.create({
            email: user.email,
        });

        userObject.stripeCustomerId = customer.id;

        await functions.addUser(userObject);

    } catch (err) {
        console.log('Error adding user: ' + err);
    }
});

/**
 * Catch-all error
 */
app.get('*', function (req, res) {
    res.status(404).json(getErrorJson("Error"));
});

function getErrorJson(errorMsg = "An unknown error occurred") {
    return {error: true, error_msg: errorMsg};
}

exports.api = firebaseFunctions.https.onRequest(app);