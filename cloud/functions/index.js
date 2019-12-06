const functions = require('firebase-functions');
const admin = require('firebase-admin');
const app = require('express')();

admin.initializeApp(functions.config().firestore);

const db = admin.firestore();
const apiVersion = '/v1';

app.get(apiVersion + '/helloWorld', async (req, res) => {
    res.send("Hello from Firebase!");
});

app.get(apiVersion + '/user', async (req, res) => {
    res.send("Hello from Firebase!");
});

exports.createUserData = functions.auth.user().onCreate((user) => {
    const userObject = {
        displayName: user.displayName || "",
        email: user.email || "",
    };

    db.collection('users').doc(user.uid).set(userObject).catch(error => {
        console.log('Error writing document: ' + error);
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

exports.api = functions.https.onRequest(app);