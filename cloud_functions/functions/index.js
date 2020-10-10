const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp()




    




exports.addNewContact = functions.region('europe-west1').firestore.document('addContactRequest/{docId}')
                            .onCreate(async (snap, context) => {
                                const userId = snap.data()['userId']
                                const contactUsername = snap.data()['contactUsername']
                                const requestId = context.params.docId
                                
                                const checks = [
                                    checkContactUsernameExists(contactUsername),
                                    checkContactNotAdded(userId, contactUsername)
                                ]
                                const [contactUsernameExists, ContactNotAdded] = await Promise.all(checks)

                                if(!contactUsernameExists || !ContactNotAdded){
                                    await response('addContactResponse/'+userId,
                                            {'requestId':requestId, 'done': false})
                                }

                                else {

                                    await response('addContactResponse/'+userId,
                                            {'requestId':requestId, 'done': true})

                                    const userDoc = await admin.firestore().collection('users').doc(userId).get()
                                    const username = userDoc.data()['username']
                                    const docRef = await admin.firestore().collection('conversations')
                                                                    .add({
                                                                        'username1': username,
                                                                        'username2': contactUsername,
                                                                    })
                                    await admin.firestore().collection('users/'+userId+'/contacts')
                                                        .add({'conversationId':docRef.id, 'contactUsername': contactUsername})
                                    
                                    
                                    const snap = await admin.firestore().collection('users/')
                                                            .where('username', '==', contactUsername).get()
                                    await admin.firestore().collection('users/'+snap.docs[0].id+'/contacts')
                                                            .add({'contactUsername': snap.docs[0]['username']})
                                    
                                    
                                }
                                                                                                


                    })
                                

exports.createAccount = functions.region('europe-west1').auth.user().onCreate((user) => {
    return admin.firestore().doc('users/'+user.uid).set({'username': user.email.split('@')[0]})
})


async function checkContactUsernameExists(contactUsername) {
  
    const docRef = await admin.firestore().collection('users').where('username', '==', contactUsername).get();
    return !docRef.empty;
}
async function checkContactNotAdded(userId, contactUsername) {
    const docs = await admin.firestore().collection('users/'+userId+'/contacts').where('contactUsername', '==', contactUsername).get();
    return docs.empty;
}

function response(dbPath, params){
    return admin.firestore().doc(dbPath).set(params)

}