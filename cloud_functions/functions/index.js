const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp()




    




exports.addNewContact = functions.region('europe-west1').firestore.document('addContactRequest/{docId}')
                                    .onCreate(async (snap, context) => {
                                        const userId = snap.data()['userId']
                                        const contactUsername = snap.data()['contactUsername']
                                        const docId = context.params.docId
                                        
                                        const checks = [
                                            checkContactUsernameExists(contactUsername),
                                            checkContactNotAdded(userId, contactUsername)
                                        ]
                                        const [contactUsernameExists, ContactNotAdded] = await Promise.all(checks)

                                        if(contactUsernameExists) {
                                            await response('addContactResponse/'+userId, {'contactUsernameExists': true, 'docId': docId})
                                        }
                                        else await response('addContactResponse/'+userId, {'contactUsernameExists': false, 'docId':docId})
                                        


                                    })
                                

exports.createAccount = functions.region('europe-west1').auth.user().onCreate((user) => {
    return admin.firestore().doc('users/'+user.uid).set({'username': user.email.split('@')[0]})
})


async function checkContactUsernameExists(contactUsername) {
    try{
        await admin.auth().getUserByEmail(contactUsername+'@firechat.com');
        return true;
    } catch(error){
        console.log(error)
        return false;

    }
    

}
function checkContactNotAdded(contactUsername) {
    return false;
}

async function response(dbPath, params){
    admin.firestore().doc(dbPath).set(params)

}