import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

export const createUserData = functions.auth.user().onCreate((user) => {
    let userObject = {
        displayName: user.displayName,
        email: user.email,
    };

    admin.firestore().collection('users').doc(user.uid).set(userObject).catch(error => {
        console.log('Error writing document: ' + error);
        return false;
    });
});
