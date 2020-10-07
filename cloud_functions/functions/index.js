const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp()
exports.addNewContact = functions.firestore.document('addContactRequest/{userId}')
                                    .onCreate((change, context) => {
                                        const userId = context.params['userId']
                                        admin.firestore().doc('addContactResponse/{userId}').set({'userid':userId})


                                    });
