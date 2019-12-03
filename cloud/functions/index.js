const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

exports.createUserData = functions.auth.user().onCreate((user) => {
    let userObject = {
        displayName: user.displayName,
        email: user.email,
    };

    return functions.firestore.document('users/' + user.uid).set(userObject);
});